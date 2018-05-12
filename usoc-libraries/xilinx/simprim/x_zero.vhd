-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/simprim/VITAL/Attic/x_zero.vhd,v 1.6 2005/04/25 20:56:20 fphillip Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  GND Connection
-- /___/   /\     Filename : X_ZERO.vhd
-- \   \  /  \    Timestamp : Thu Apr  8 10:57:22 PDT 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.

----- CELL X_ZERO -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.Vital_Primitives.all;
use IEEE.Vital_Timing.all;

entity X_ZERO is
  generic(
    LOC : string  := "UNPLACED"
    );
  port(
    O : out std_ulogic := '0'
    );

  attribute VITAL_LEVEL0 of
    X_ZERO : entity is true;
end X_ZERO;

architecture X_ZERO_V of X_ZERO is
  attribute VITAL_LEVEL0 of
    X_ZERO_V : architecture is true;
begin
  O <= '0';
end X_ZERO_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Boundary Scan Logic Control Circuit for VIRTEX4
-- /___/   /\     Filename : X_BSCAN_VIRTEX4.v
-- \   \  /  \    Timestamp : Sat Mar 26 16:03:05 PST 2005
--  \___\/\___\
--
-- Revision:
--    03/26/05 - Initial version.

----- CELL X_BSCAN_VIRTEX4 -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library simprim;
use simprim.vcomponents.all;
entity X_BSCAN_VIRTEX4 is
  generic(

        TimingChecksOn  : boolean       := true;
        InstancePath    : string        := "*";
        Xon             : boolean       := true;
        MsgOn           : boolean       := true;

        JTAG_CHAIN : integer := 1;
        LOC : string  := "UNPLACED"
        );

  port(
    CAPTURE : out std_ulogic := 'H';
    DRCK    : out std_ulogic := 'H';
    RESET   : out std_ulogic := 'H';
    SEL     : out std_ulogic := 'L';
    SHIFT   : out std_ulogic := 'L';
    TDI     : out std_ulogic := 'L';
    UPDATE  : out std_ulogic := 'L';

    TDO     : in std_ulogic := 'X'
    );

end X_BSCAN_VIRTEX4;

architecture X_BSCAN_VIRTEX4_V of X_BSCAN_VIRTEX4 is

signal SEL_zd : std_ulogic := '0';
signal UPDATE_zd : std_ulogic := '0';

begin

--####################################################################
--#####                        Initialization                      ###
--####################################################################
  prcs_init:process
  begin
     if((JTAG_CHAIN /= 1) and (JTAG_CHAIN /= 2)  and (JTAG_CHAIN /= 3)
                                           and (JTAG_CHAIN /= 4)) then
        assert false
        report "Attribute Syntax Error: The allowed values for JTAG_CHAIN are 1, 2, 3 or 4"
        severity Failure;
     end if;
     wait;
  end process prcs_init;

-- synopsys translate_off

--####################################################################
--#####                        jtag_select                         ###
--####################################################################
  prcs_jtag_select:process (JTAG_SEL1_GLBL, JTAG_SEL2_GLBL, JTAG_SEL3_GLBL, JTAG_SEL4_GLBL)
  begin
      if(JTAG_CHAIN = 1) then
        SEL_zd <= JTAG_SEL1_GLBL;
      elsif(JTAG_CHAIN = 2) then
        SEL_zd <= JTAG_SEL2_GLBL;
      elsif(JTAG_CHAIN = 3) then
        SEL_zd <= JTAG_SEL3_GLBL;
      elsif(JTAG_CHAIN = 4) then
        SEL_zd <= JTAG_SEL4_GLBL;
     end if;

  end process prcs_jtag_select;

--####################################################################
--#####                        USER_TDO                            ###
--####################################################################
  prcs_jtag_UserTDO:process (TDO)
  begin
      if(JTAG_CHAIN = 1) then
        JTAG_USER_TDO1_GLBL <= TDO;
      elsif(JTAG_CHAIN = 2) then
        JTAG_USER_TDO2_GLBL <= TDO;
      elsif(JTAG_CHAIN = 3) then
        JTAG_USER_TDO3_GLBL <= TDO;
      elsif(JTAG_CHAIN = 4) then
        JTAG_USER_TDO4_GLBL <= TDO;
     end if;

  end process prcs_jtag_UserTDO;
--####################################################################

  CAPTURE <= JTAG_CAPTURE_GLBL;
  DRCK  <= ((SEL_zd and not JTAG_SHIFT_GLBL and not JTAG_CAPTURE_GLBL) or
            (SEL_zd and JTAG_SHIFT_GLBL and JTAG_TCK_GLBL) or
            (SEL_zd and JTAG_CAPTURE_GLBL and JTAG_TCK_GLBL));
  TDI     <= JTAG_TDI_GLBL;
  SEL     <= SEL_zd;
  SHIFT   <= JTAG_SHIFT_GLBL;
  UPDATE  <= JTAG_UPDATE_GLBL;
  RESET   <= JTAG_RESET_GLBL;

-- synopsys translate_on

end X_BSCAN_VIRTEX4_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Global Clock Mux Buffer
-- /___/   /\     Filename : X_BUFGCTRL.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:19 PST 2004
--  \___\/\___\
--
-- Revision:
--    03/23/04 - Initial version.
--    11/28/05 - CR 221551 fix.
--    08/13/07 - CR 413180 Initialization mismatch fix for unisims.
--    04/07/08 - CR 469973 -- Header Description fix
--    05/20/08 - Remove GSR Vital (CR444306)
--    05/22/08 - Add init_done to pass initial values (CR 473625).
-- End Revision

----- CELL X_BUFGCTRL -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_BUFGCTRL is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_CE0       : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CE1       : VitalDelayType01 := (0 ps, 0 ps);
      tipd_I0        : VitalDelayType01 := (0 ps, 0 ps);
      tipd_I1        : VitalDelayType01 := (0 ps, 0 ps);
      tipd_IGNORE0   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_IGNORE1   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S0        : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S1        : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_I0_O       : VitalDelayType01 := (0 ps, 0 ps);
      tpd_I1_O       : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL tisd & tisd variables
      tisd_CE0_I0    : VitalDelayType   := 0.0 ps;
      tisd_CE0_I1    : VitalDelayType   := 0.0 ps;
      tisd_CE1_I0    : VitalDelayType   := 0.0 ps;
      tisd_CE1_I1    : VitalDelayType   := 0.0 ps;

      tisd_I1_I0     : VitalDelayType   := 0.0 ps;
      tisd_I0_I1     : VitalDelayType   := 0.0 ps;

      tisd_IGNORE0_I0     : VitalDelayType   := 0.0 ps;
      tisd_IGNORE1_I1     : VitalDelayType   := 0.0 ps;

      tisd_S0_I0     : VitalDelayType   := 0.0 ps;
      tisd_S0_I1     : VitalDelayType   := 0.0 ps;
      tisd_S1_I0     : VitalDelayType   := 0.0 ps;
      tisd_S1_I1     : VitalDelayType   := 0.0 ps;

      ticd_I0        : VitalDelayType   := 0.0 ps;
      ticd_I1        : VitalDelayType   := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE0_I0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE0_I0_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE0_I0_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_CE0_I0_negedge_negedge : VitalDelayType := 0 ps;

      thold_CE0_I0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE0_I0_negedge_posedge  : VitalDelayType := 0 ps;
      thold_CE0_I0_posedge_negedge  : VitalDelayType := 0 ps;
      thold_CE0_I0_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_CE0_I1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE0_I1_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE0_I1_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_CE0_I1_negedge_negedge : VitalDelayType := 0 ps;

      thold_CE0_I1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE0_I1_negedge_posedge  : VitalDelayType := 0 ps;
      thold_CE0_I1_posedge_negedge  : VitalDelayType := 0 ps;
      thold_CE0_I1_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_CE1_I0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE1_I0_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE1_I0_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_CE1_I0_negedge_negedge : VitalDelayType := 0 ps;

      thold_CE1_I0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE1_I0_negedge_posedge  : VitalDelayType := 0 ps;
      thold_CE1_I0_posedge_negedge  : VitalDelayType := 0 ps;
      thold_CE1_I0_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_CE1_I1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE1_I1_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE1_I1_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_CE1_I1_negedge_negedge : VitalDelayType := 0 ps;

      thold_CE1_I1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE1_I1_negedge_posedge  : VitalDelayType := 0 ps;
      thold_CE1_I1_posedge_negedge  : VitalDelayType := 0 ps;
      thold_CE1_I1_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_S0_I0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S0_I0_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S0_I0_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_S0_I0_negedge_negedge : VitalDelayType := 0 ps;

      thold_S0_I0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S0_I0_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S0_I0_posedge_negedge  : VitalDelayType := 0 ps;
      thold_S0_I0_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_S0_I1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S0_I1_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S0_I1_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_S0_I1_negedge_negedge : VitalDelayType := 0 ps;

      thold_S0_I1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S0_I1_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S0_I1_posedge_negedge  : VitalDelayType := 0 ps;
      thold_S0_I1_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_S1_I0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S1_I0_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S1_I0_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_S1_I0_negedge_negedge : VitalDelayType := 0 ps;

      thold_S1_I0_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S1_I0_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S1_I0_posedge_negedge  : VitalDelayType := 0 ps;
      thold_S1_I0_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_S1_I1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S1_I1_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S1_I1_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_S1_I1_negedge_negedge : VitalDelayType := 0 ps;

      thold_S1_I1_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S1_I1_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S1_I1_posedge_negedge  : VitalDelayType := 0 ps;
      thold_S1_I1_negedge_negedge  : VitalDelayType := 0 ps;

      tsetup_I1_I0_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_I1_I0_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_I1_I0_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_I1_I0_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_I0_I1_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_I0_I1_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_I0_I1_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_I0_I1_negedge_negedge : VitalDelayType := 0 ps;

-- VITAL pulse width variables
      tpw_I0_posedge               : VitalDelayType := 0 ps;
      tpw_I0_negedge               : VitalDelayType := 0 ps;
      tpw_I1_posedge               : VitalDelayType := 0 ps;
      tpw_I1_negedge               : VitalDelayType := 0 ps;


-- VITAL period variable
      tperiod_I0_posedge           : VitalDelayType := 0 ps;
      tperiod_I1_posedge           : VitalDelayType := 0 ps;

      INIT_OUT     : integer := 0;
      PRESELECT_I0 : boolean := false;
      PRESELECT_I1 : boolean := false
      );

  port(
    O		: out std_ulogic;

    CE0		: in  std_ulogic;
    CE1		: in  std_ulogic;
    I0	        : in  std_ulogic;
    I1        	: in  std_ulogic;
    IGNORE0	: in  std_ulogic;
    IGNORE1	: in  std_ulogic;
    S0		: in  std_ulogic;
    S1		: in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_BUFGCTRL : entity is true;

end X_BUFGCTRL;

architecture X_BUFGCTRL_V OF X_BUFGCTRL is

  attribute VITAL_LEVEL0 of
    X_BUFGCTRL_V : architecture is true;


  constant SYNC_PATH_DELAY : time := 100 ps;

  signal CE0_ipd	: std_ulogic := 'X';
  signal CE1_ipd	: std_ulogic := 'X';
  signal I0_ipd	: std_ulogic := 'X';
  signal I1_ipd	: std_ulogic := 'X';
  signal IGNORE0_ipd	: std_ulogic := 'X';
  signal IGNORE1_ipd	: std_ulogic := 'X';
  signal S0_ipd  	: std_ulogic := 'X';
  signal S1_ipd  	: std_ulogic := 'X';

  signal CE0_dly        : std_ulogic := 'X';
  signal CE1_dly        : std_ulogic := 'X';
  signal I0_dly         : std_ulogic := 'X';
  signal I1_dly         : std_ulogic := 'X';
  signal IGNORE0_dly    : std_ulogic := 'X';
  signal IGNORE1_dly    : std_ulogic := 'X';
  signal S0_dly         : std_ulogic := 'X';
  signal S1_dly         : std_ulogic := 'X';

  signal O_zd		: std_ulogic := 'X';

  signal q0             : std_ulogic := 'X';
  signal q1             : std_ulogic := 'X';
  signal q0_enable      : std_ulogic := 'X';
  signal q1_enable      : std_ulogic := 'X';

  signal preslct_i0     : std_ulogic := 'X';
  signal preslct_i1     : std_ulogic := 'X';

  signal i0_int         : std_ulogic := 'X';
  signal i1_int         : std_ulogic := 'X';
  signal init_done      : boolean := false;
begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (CE0_ipd,  CE0, tipd_CE0);
    VitalWireDelay (CE1_ipd,  CE1, tipd_CE1);
    VitalWireDelay (I0_ipd, I0, tipd_I0);
    VitalWireDelay (I1_ipd, I1, tipd_I1);
    VitalWireDelay (IGNORE0_ipd, IGNORE0, tipd_IGNORE0);
    VitalWireDelay (IGNORE1_ipd, IGNORE1, tipd_IGNORE1);
    VitalWireDelay (S0_ipd,  S0, tipd_S0);
    VitalWireDelay (S1_ipd,  S1, tipd_S1);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CE0_dly,  CE0_ipd, tisd_CE0_I0);
    VitalSignalDelay (CE1_dly,  CE1_ipd, tisd_CE1_I1);
    VitalSignalDelay (I0_dly, I0_ipd, ticd_I0);
    VitalSignalDelay (I1_dly, I1_ipd, ticd_I1);
    VitalSignalDelay (IGNORE0_dly, IGNORE0_ipd, tisd_IGNORE0_I0);
    VitalSignalDelay (IGNORE1_dly, IGNORE1_ipd, tisd_IGNORE1_I1);
    VitalSignalDelay (S0_dly,  S0_ipd, tisd_S0_I0);
    VitalSignalDelay (S1_dly,  S1_ipd, tisd_S1_I1);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable FIRST_TIME : boolean := true;
  variable preslct_i0_var : std_ulogic;
  variable preslct_i1_var : std_ulogic;

  begin
    if(FIRST_TIME) then

      -- check for PRESELECT_I0
      case PRESELECT_I0  is
        when true  => preslct_i0_var := '1';
        when false => preslct_i0_var := '0';
        when others =>
         assert false report
           "*** Attribute Syntax Error: Legal values for PRESELECT_I0 are TRUE or FALSE"
          severity failure;
      end case;

      -- check for PRESELECT_I1
      case PRESELECT_I1  is
        when true  => preslct_i1_var := '1';
        when false => preslct_i1_var := '0';
        when others =>
         assert false report
           "*** Attribute Syntax Error: Legal values for PRESELECT_I0 are TRUE or FALSE"
          severity failure;
      end case;

      -- both preslcts can not be 1 simultaneously 
      if((preslct_i0_var = '1') and (preslct_i1_var = '1')) then
         assert false report
           "*** Attribute Syntax Error: The attributes PRESELECT_I0 and PRESELECT_I1 should not be set to TRUE simultaneously"
          severity failure;
      end if;
        
      -- check for INIT_OUT
      if((INIT_OUT /= 0) and (INIT_OUT /= 1)) then
         assert false report
           "*** Attribute Syntax Error: Legal values for INIT_OUT are 0 or 1 "
          severity failure;
      end if;

      preslct_i0 <= preslct_i0_var;
      preslct_i1 <= preslct_i1_var;
      FIRST_TIME := false;
      init_done <= true;
    end if;
    wait;

  end process prcs_init;


----- *** Start
     
  prcs_clk:process(i0_dly, i1_dly)
  begin
     if(INIT_OUT = 1) then
        i0_int <= NOT i0_dly; 
     else
        i0_int <= i0_dly; 
     end if;

     if(INIT_OUT = 1) then
        i1_int <= NOT i1_dly; 
     else
        i1_int <= i1_dly; 
     end if;
  end process prcs_clk;
--####################################################################
--#####                            I1                          #####
--####################################################################
----- *** Input enable for i1
  prcs_en_i1:process(IGNORE1_dly, i1_int, S1_dly, GSR, q0, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR = '1')) then
         q1_enable <= preslct_i1;
         FIRST_TIME := false;
      elsif (GSR = '0') then
         if ((i1_int  = '0') and (IGNORE1_dly = '0')) then 
             q1_enable <= q1_enable;
         elsif((i1_int = '1') or (IGNORE1_dly = '1')) then
             q1_enable <= ((NOT q0) AND (S1_dly));
          end if;
             
      end if;
  end process prcs_en_i1;
    
----- *** Output q1
  prcs_out_i1:process(q1_enable, CE1_dly, i1_int, IGNORE1_dly, GSR, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR = '1')) then
         q1 <= preslct_i1;
         FIRST_TIME := false;
      elsif (GSR = '0') then
         if ((i1_int  = '1') and (IGNORE1_dly = '0')) then 
             q1 <= q1;
         elsif((i1_int = '0') or (IGNORE1_dly = '1')) then
             if ((CE0_dly='1' and q0_enable='1') and (CE1_dly='1' and q1_enable='1')) then
                q1 <=  'X';
             else
                q1 <=  CE1_dly AND q1_enable;
             end if;
         end if;
      end if;
  end process prcs_out_i1;

--####################################################################
--#####                            I0                          #####
--####################################################################
----- *** Input enable for i0
  prcs_en_i0:process(IGNORE0_dly, i0_int, S0_dly, GSR, q1, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR = '1')) then
         q0_enable <= preslct_i0;
         FIRST_TIME := false;
      elsif (GSR = '0') then
         if ((i0_int  = '0') and (IGNORE0_dly = '0')) then 
             q0_enable <= q0_enable;
         elsif((i0_int = '1') or (IGNORE0_dly = '1')) then
             q0_enable <= ((NOT q1) AND (S0_dly));
          end if;
             
      end if;
  end process prcs_en_i0;
    
----- *** Output q0
  prcs_out_i0:process(q0_enable, CE0_dly, i0_int, IGNORE0_dly, GSR, init_done)
  variable FIRST_TIME        : boolean    := TRUE;
  begin
      if (((FIRST_TIME) and (init_done)) or (GSR = '1')) then
         q0 <= preslct_i0;
         FIRST_TIME := false;
      elsif (GSR = '0') then
         if ((i0_int  = '1') and (IGNORE0_dly = '0')) then 
             q0 <= q0;
         elsif((i0_int = '0') or (IGNORE0_dly = '1')) then
             if ((CE0_dly='1' and q0_enable='1') and (CE1_dly='1' and q1_enable='1')) then
                q0 <=  'X';
             else
                q0 <=  CE0_dly AND q0_enable;
             end if;
         end if;
      end if;
  end process prcs_out_i0;

--####################################################################
--#####                          OUTPUT                          #####
--####################################################################
  prcs_selectout:process(q0, q1, i0_int, i1_int)
  variable tmp_buf : std_logic_vector(1 downto 0);
  begin
    tmp_buf := q1&q0;
    case tmp_buf is
      when "01" => O_zd <= I0_dly;
      when "10" => O_zd <= I1_dly;
      when "00" => 
            if(INIT_OUT = 1) then
              O_zd <= '1';
            elsif(INIT_OUT = 0) then
              O_zd <= '0';
            end if;
      when "XX" => 
              O_zd <= 'X';
      when others =>
    end case;
  end process prcs_selectout;
--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process

  variable Tviol_CE0_I0_posedge : std_ulogic := '0'; 
  variable Tmkr_CE0_I0_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_CE0_I1_posedge : std_ulogic := '0'; 
  variable Tmkr_CE0_I1_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_CE1_I0_posedge : std_ulogic := '0'; 
  variable Tmkr_CE1_I0_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_CE1_I1_posedge : std_ulogic := '0'; 
  variable Tmkr_CE1_I1_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_S0_I0_posedge : std_ulogic := '0'; 
  variable Tmkr_S0_I0_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_S0_I1_posedge : std_ulogic := '0'; 
  variable Tmkr_S0_I1_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_S1_I0_posedge : std_ulogic := '0'; 
  variable Tmkr_S1_I0_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_S1_I1_posedge : std_ulogic := '0'; 
  variable Tmkr_S1_I1_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_I1_I0_posedge : std_ulogic := '0'; 
  variable Tmkr_I1_I0_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Tviol_I0_I1_posedge : std_ulogic := '0'; 
  variable Tmkr_I0_I1_posedge  : VitalTimingDataType := VitalTimingDataInit;

  variable Pviol_I0            : std_ulogic := '0';
  variable PInfo_I0            : VitalPeriodDataType := VitalPeriodDataInit;

  variable Pviol_I1            : std_ulogic := '0';
  variable PInfo_I1            : VitalPeriodDataType := VitalPeriodDataInit;

  variable O_GlitchData        : VitalGlitchDataType;

  begin
     if (TimingChecksOn) then
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE0_I0_posedge,
         TimingData     => Tmkr_CE0_I0_posedge,
         TestSignal     => CE0_dly,
         TestSignalName => "CE0",
         TestDelay      => tisd_CE0_I0,
         RefSignal      => I0_dly,
         RefSignalName  => "I0",
         RefDelay       => ticd_I0,
         SetupHigh      => tsetup_CE0_I0_posedge_posedge,
         SetupLow       => tsetup_CE0_I0_negedge_posedge,
         HoldLow        => thold_CE0_I0_posedge_posedge,
         HoldHigh       => thold_CE0_I0_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE0_I1_posedge,
         TimingData     => Tmkr_CE0_I1_posedge,
         TestSignal     => CE0_dly,
         TestSignalName => "CE0",
         TestDelay      => tisd_CE0_I1,
         RefSignal      => I1_dly,
         RefSignalName  => "I1",
         RefDelay       => ticd_I1,
         SetupHigh      => tsetup_CE0_I1_posedge_posedge,
         SetupLow       => tsetup_CE0_I1_negedge_posedge,
         HoldLow        => thold_CE0_I1_posedge_posedge,
         HoldHigh       => thold_CE0_I1_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE1_I0_posedge,
         TimingData     => Tmkr_CE1_I0_posedge,
         TestSignal     => CE1_dly,
         TestSignalName => "CE1",
         TestDelay      => tisd_CE1_I0,
         RefSignal      => I0_dly,
         RefSignalName  => "I0",
         RefDelay       => ticd_I0,
         SetupHigh      => tsetup_CE1_I0_posedge_posedge,
         SetupLow       => tsetup_CE1_I0_negedge_posedge,
         HoldLow        => thold_CE1_I0_posedge_posedge,
         HoldHigh       => thold_CE1_I0_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE1_I1_posedge,
         TimingData     => Tmkr_CE1_I1_posedge,
         TestSignal     => CE1_dly,
         TestSignalName => "CE1",
         TestDelay      => tisd_CE1_I1,
         RefSignal      => I1_dly,
         RefSignalName  => "I1",
         RefDelay       => ticd_I1,
         SetupHigh      => tsetup_CE1_I1_posedge_posedge,
         SetupLow       => tsetup_CE1_I1_negedge_posedge,
         HoldLow        => thold_CE1_I1_posedge_posedge,
         HoldHigh       => thold_CE1_I1_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_I1_I0_posedge,
         TimingData     => Tmkr_I1_I0_posedge,
         TestSignal     => I1_dly,
         TestSignalName => "I1",
         TestDelay      => tisd_I1_I0,
         RefSignal      => I0_dly,
         RefSignalName  => "I0",
         RefDelay       => ticd_I0,
         SetupHigh      => tsetup_I1_I0_posedge_posedge,
         SetupLow       => tsetup_I1_I0_negedge_posedge,
         HoldLow        => 0 ns,
         HoldHigh       => 0 ns,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_I0_I1_posedge,
         TimingData     => Tmkr_I0_I1_posedge,
         TestSignal     => I0_dly,
         TestSignalName => "I0",
         TestDelay      => tisd_I0_I1,
         RefSignal      => I1_dly,
         RefSignalName  => "I1",
         RefDelay       => ticd_I1,
         SetupHigh      => tsetup_I0_I1_posedge_posedge,
         SetupLow       => tsetup_I0_I1_negedge_posedge,
         HoldLow        => 0 ns,
         HoldHigh       => 0 ns,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_S0_I0_posedge,
         TimingData     => Tmkr_S0_I0_posedge,
         TestSignal     => S0_dly,
         TestSignalName => "S0",
         TestDelay      => tisd_S0_I0,
         RefSignal      => I0_dly,
         RefSignalName  => "I0",
         RefDelay       => ticd_I0,
         SetupHigh      => tsetup_S0_I0_posedge_posedge,
         SetupLow       => tsetup_S0_I0_negedge_posedge,
         HoldLow        => thold_S0_I0_posedge_posedge,
         HoldHigh       => thold_S0_I0_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_S0_I1_posedge,
         TimingData     => Tmkr_S0_I1_posedge,
         TestSignal     => S0_dly,
         TestSignalName => "S0",
         TestDelay      => tisd_S0_I1,
         RefSignal      => I1_dly,
         RefSignalName  => "I1",
         RefDelay       => ticd_I1,
         SetupHigh      => tsetup_S0_I1_posedge_posedge,
         SetupLow       => tsetup_S0_I1_negedge_posedge,
         HoldLow        => thold_S0_I1_posedge_posedge,
         HoldHigh       => thold_S0_I1_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_S1_I0_posedge,
         TimingData     => Tmkr_S1_I0_posedge,
         TestSignal     => S1_dly,
         TestSignalName => "S1",
         TestDelay      => tisd_S1_I0,
         RefSignal      => I0_dly,
         RefSignalName  => "I0",
         RefDelay       => ticd_I0,
         SetupHigh      => tsetup_S1_I0_posedge_posedge,
         SetupLow       => tsetup_S1_I0_negedge_posedge,
         HoldLow        => thold_S1_I0_posedge_posedge,
         HoldHigh       => thold_S1_I0_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_S1_I1_posedge,
         TimingData     => Tmkr_S1_I1_posedge,
         TestSignal     => S1_dly,
         TestSignalName => "S1",
         TestDelay      => tisd_S1_I1,
         RefSignal      => I1_dly,
         RefSignalName  => "I1",
         RefDelay       => ticd_I1,
         SetupHigh      => tsetup_S1_I1_posedge_posedge,
         SetupLow       => tsetup_S1_I1_negedge_posedge,
         HoldLow        => thold_S1_I1_posedge_posedge,
         HoldHigh       => thold_S1_I1_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_BUFGCTRL",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => WARNING
       );
     end if;
-- End of (TimingChecksOn)
--  Output-to-Clock path delay
     VitalPathDelay01
       (
         OutSignal     => O,
         GlitchData    => O_GlitchData,
         OutSignalName => "O",
         OutTemp       => O_zd,
         Paths         => (0 => (I0_dly'last_event, tpd_I0_O, TRUE),
                           1 => (I1_dly'last_event, tpd_I1_O, TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
      VitalPeriodPulseCheck 
       (
         Violation               => Pviol_I0,
         PeriodData              => PInfo_I0,
         TestSignal              => I0_dly,
         TestSignalName          => "I0",
         TestDelay               => 0 ns,
         Period                  => tperiod_I0_posedge,
         PulseWidthHigh          => tpw_I0_posedge,
         PulseWidthLow           => tpw_I0_negedge,
         CheckEnabled            => TRUE,
         HeaderMsg               => InstancePath &"/X_BUFGCTRL",
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
      );
      VitalPeriodPulseCheck 
       (
         Violation               => Pviol_I1,
         PeriodData              => PInfo_I1,
         TestSignal              => I1_dly,
         TestSignalName          => "I1",
         TestDelay               => 0 ns,
         Period                  => tperiod_I1_posedge,
         PulseWidthHigh          => tpw_I1_posedge,
         PulseWidthLow           => tpw_I1_negedge,
         CheckEnabled            => TRUE,
         HeaderMsg               => InstancePath &"/X_BUFGCTRL",
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
      );
      wait on I0_dly, I1_dly, S0_dly, S1_dly, CE0_dly, CE1_dly,
              IGNORE0_dly, IGNORE1_dly, O_zd;
  end process prcs_tmngchk;

end X_BUFGCTRL_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Regional Clock Buffer
-- /___/   /\     Filename : X_BUFR.vhd
-- \   \  /  \    Timestamp : Fri Mar 26 08:18:19 PST 2004
--  \___\/\___\
-- Revision:
--    03/23/04 - Initial version.
--    04/04/2005 - Add SIM_DEVICE paramter to support rainier. CE pin has 4 clock
--                 latency for Virtex 4 and none for Rainier
--    06/30/2005 - CR # 211199 -- removed sync path delay. Made delayed start only
--                 depend on CE (not CLR)
--    07/25/05 - Updated names to Virtex5
--    08/31/05 - Add ce_en to sensitivity list of i_in which make ce asynch.
--    05/23/06 - Add clk_count =0 and first_time=true when CE = 0 (CR 232206).
--    08/09/06 - Initial output to 0 (CR 217760).
-- End Revision


----- CELL X_BUFR -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_BUFR is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_CE   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_I    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLR  : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
--    06/30/2005 - CR # 211199 -- 
--    tpd_I_O   : VitalDelayType01 := (100 ps, 100 ps);
      tpd_I_O   : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL async rest-to-output path delay variables
      tpd_CLR_O : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_O : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL tisd & tisd variables
      tisd_GSR_I : VitalDelayType   := 0.0 ps;
      tisd_CLR_I : VitalDelayType   := 0.0 ps;
      ticd_I     : VitalDelayType   := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_I_posedge_posedge   : VitalDelayType := 0 ps;
      tsetup_CE_I_posedge_negedge   : VitalDelayType := 0 ps;
      tsetup_CE_I_negedge_posedge   : VitalDelayType := 0 ps;
      tsetup_CE_I_negedge_negedge   : VitalDelayType := 0 ps;

      thold_CE_I_posedge_posedge   : VitalDelayType := 0 ps;
      thold_CE_I_posedge_negedge   : VitalDelayType := 0 ps;
      thold_CE_I_negedge_posedge   : VitalDelayType := 0 ps;
      thold_CE_I_negedge_negedge   : VitalDelayType := 0 ps;

-- VITAL pulse width variables
      tpw_I_posedge              : VitalDelayType := 0 ps;
      tpw_I_negedge              : VitalDelayType := 0 ps;
      tpw_GSR_posedge            : VitalDelayType := 0 ps;
      tpw_CLR_posedge            : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_I_posedge          : VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_I_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_CLR_I_negedge_posedge : VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_I_negedge_posedge : VitalDelayType := 0 ps;
      tremoval_CLR_I_negedge_posedge : VitalDelayType := 0 ps;

      BUFR_DIVIDE   : string := "BYPASS";
      SIM_DEVICE    : string := "VIRTEX4"
      );

  port(
      O           : out std_ulogic;

      CE          : in  std_ulogic;
      CLR         : in  std_ulogic;
      I           : in  std_ulogic
      );

  attribute VITAL_LEVEL0 of
    X_BUFR : entity is true;

end X_BUFR;

architecture X_BUFR_V OF X_BUFR is

  attribute VITAL_LEVEL0 of
    X_BUFR_V : architecture is true;


--    06/30/2005 - CR # 211199 -- 
--  constant SYNC_PATH_DELAY : time := 100 ps;

  signal CE_ipd	        : std_ulogic := 'X';
  signal GSR_ipd	: std_ulogic := '0';
  signal I_ipd	        : std_ulogic := 'X';
  signal CLR_ipd	: std_ulogic := 'X';

  signal CE_dly       	: std_ulogic := 'X';
  signal GSR_dly	: std_ulogic := '0';
  signal I_dly       	: std_ulogic := 'X';
  signal CLR_dly	: std_ulogic := 'X';

  signal O_zd	        : std_ulogic := '0';
  signal O_viol	        : std_ulogic := '0';

  signal q4_sig	        : std_ulogic := 'X';
  signal ce_en	        : std_ulogic;

  signal divide   	: boolean    := false;
  signal divide_by	: integer    := -1;
  signal FIRST_TOGGLE_COUNT     : integer    := -1;
  signal SECOND_TOGGLE_COUNT    : integer    := -1;

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (CE_ipd,  CE,  tipd_CE);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
    VitalWireDelay (I_ipd,   I,   tipd_I);
    VitalWireDelay (CLR_ipd, CLR, tipd_CLR);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (CE_dly,   CE_ipd,   ticd_I);
    VitalSignalDelay (GSR_dly,  GSR_ipd,  tisd_GSR_I);
    VitalSignalDelay (I_dly,    I_ipd,    ticd_I);
    VitalSignalDelay (CLR_dly,  CLR_ipd,  tisd_CLR_I);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


--####################################################################
--#####                     Initialize                           #####
--####################################################################
  prcs_init:process
  variable FIRST_TOGGLE_COUNT_var  : integer    := -1;
  variable SECOND_TOGGLE_COUNT_var : integer    := -1;
  variable ODD                     : integer    := -1;
  variable divide_var  	   : boolean    := false;
  variable divide_by_var           :  integer    := -1;

  begin
      if(BUFR_DIVIDE = "BYPASS") then
         divide_var := false;
      elsif(BUFR_DIVIDE = "1") then
         divide_var    := true;
         divide_by_var := 1;
         FIRST_TOGGLE_COUNT_var  := 1;
         SECOND_TOGGLE_COUNT_var := 1;
      elsif(BUFR_DIVIDE = "2") then
         divide_var    := true;
         divide_by_var := 2;
         FIRST_TOGGLE_COUNT_var  := 2;
         SECOND_TOGGLE_COUNT_var := 2;
      elsif(BUFR_DIVIDE = "3") then
         divide_var    := true;
         divide_by_var := 3;
         FIRST_TOGGLE_COUNT_var  := 2;
         SECOND_TOGGLE_COUNT_var := 4;
      elsif(BUFR_DIVIDE = "4") then
         divide_var    := true;
         divide_by_var := 4;
         FIRST_TOGGLE_COUNT_var  := 4;
         SECOND_TOGGLE_COUNT_var := 4;
      elsif(BUFR_DIVIDE = "5") then
         divide_var    := true;
         divide_by_var := 5;
         FIRST_TOGGLE_COUNT_var  := 4;
         SECOND_TOGGLE_COUNT_var := 6;
      elsif(BUFR_DIVIDE = "6") then
         divide_var    := true;
         divide_by_var := 6;
         FIRST_TOGGLE_COUNT_var  := 6;
         SECOND_TOGGLE_COUNT_var := 6;
      elsif(BUFR_DIVIDE = "7") then
         divide_var    := true;
         divide_by_var := 7;
         FIRST_TOGGLE_COUNT_var  := 6;
         SECOND_TOGGLE_COUNT_var := 8;
      elsif(BUFR_DIVIDE = "8") then
         divide_var    := true;
         divide_by_var := 8;
         FIRST_TOGGLE_COUNT_var  := 8;
         SECOND_TOGGLE_COUNT_var := 8;
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " BUFR_DIVIDE ",
             EntityName => "/BUFR",
             GenericValue => BUFR_DIVIDE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " BYPASS, 1, 2, 3, 4, 5, 6, 7 or 8 ",
             TailMsg => "",
             MsgSeverity => ERROR 
         );
      end if;

     if (SIM_DEVICE /= "VIRTEX4" and SIM_DEVICE /= "VIRTEX5") then
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " SIM_DEVICE ",
             EntityName => "/BUFR",
             GenericValue => SIM_DEVICE,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " VIRTEX4 or VIRTEX5 ",
             TailMsg => "",
             MsgSeverity => ERROR
         );
      end if;

      FIRST_TOGGLE_COUNT  <= FIRST_TOGGLE_COUNT_var; 
      SECOND_TOGGLE_COUNT <= SECOND_TOGGLE_COUNT_var; 

      divide    <= divide_var;
      divide_by <= divide_by_var;

     wait;
  end process prcs_init;
--####################################################################
--#####                      CLOCK_ENABLE                        #####
--####################################################################
   prcs_ce:process(I_Dly, GSR_dly)
   variable fall_i_count : integer    := 0;
   variable q4_var       : std_ulogic := '0';
   variable q3_var       : std_ulogic := '0';
   variable q2_var       : std_ulogic := '0';
   variable q1_var       : std_ulogic := '0';
   begin
--    06/30/2005 - CR # 211199 -- removed CLR_dly dependency
      if(GSR_dly = '1')  then
         q4_var := '0';
         q3_var := '0';
         q2_var := '0';
         q1_var := '0';
      elsif(GSR_dly = '0') then
         if(falling_edge(I_dly)) then
          if (SIM_DEVICE = "VIRTEX5") then
             q4_var := CE_dly;
          else
            q4_var := q3_var;
            q3_var := q2_var;
            q2_var := q1_var;
            q1_var := CE_dly;
          end if;
         end if;
  
         q4_sig	 <= q4_var;
      end if;
   end process prcs_ce;

   ce_en <= CE_dly when (SIM_DEVICE = "VIRTEX5") else q4_sig;

--####################################################################
--#####                       CLK-I                              #####
--####################################################################
  prcs_I:process(I_dly, GSR_dly, CLR_dly, ce_en)
  variable clk_count      : integer := 0;
  variable toggle_count   : integer := 0;
  variable first          : boolean := true;
  variable FIRST_TIME     : boolean := true;
  begin
       if(divide) then
          if((GSR_dly = '1') or (CLR_dly = '1')) then
            O_zd       <= '0';
            clk_count  := 0;
            FIRST_TIME := true;
          elsif((GSR_dly = '0') and (CLR_dly = '0')) then
             if(ce_en = '1') then
                if((I_dly='1') and (FIRST_TIME)) then
                    O_zd <= '1';
                    first        := true;
                    toggle_count := FIRST_TOGGLE_COUNT;
                    FIRST_TIME := false;
                elsif ((I_dly'event) and ( FIRST_TIME = false)) then
                    if(clk_count = toggle_count) then
                       O_zd <= not O_zd;
                       clk_count := 0;
                       first := not first;
                       if(first = true) then
                         toggle_count := FIRST_TOGGLE_COUNT;
                       else
                         toggle_count := SECOND_TOGGLE_COUNT;
                       end if;
                    end if;
                 end if;

                 if (FIRST_TIME = false) then
                       clk_count := clk_count + 1;
                end if;
             else
                 clk_count := 0;
                 FIRST_TIME := true;
             end if;
          end if;
       else
          O_zd <= I_dly;
       end if;

  end process prcs_I;

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
--  Pin Timing Violations (all input pins)
     variable	Tviol_CE_I_posedge	: STD_ULOGIC := '0';
     variable	Tmkr_CE_I_posedge	: VitalTimingDataType := VitalTimingDataInit;
     variable	Tviol_GSR_I_posedge	: STD_ULOGIC := '0';
     variable	Tmkr_GSR_I_posedge	: VitalTimingDataType := VitalTimingDataInit;
     variable   Violation               : std_ulogic          := '0';

     begin

--  Setup/Hold Check Violations (all input pins)

     if (TimingChecksOn) then
       VitalSetupHoldCheck
         (
           Violation      => Tviol_CE_I_posedge,
           TimingData     => Tmkr_CE_I_posedge,
           TestSignal     => CE,
           TestSignalName => "CE",
           TestDelay      => 0 ns,
           RefSignal      => I_dly,
           RefSignalName  => "I",
           RefDelay       => 0 ns,
           SetupHigh      => tsetup_CE_I_posedge_posedge,
           SetupLow       => tsetup_CE_I_negedge_posedge,
           HoldLow        => thold_CE_I_posedge_posedge,
           HoldHigh       => thold_CE_I_negedge_posedge,
           CheckEnabled   => TRUE,
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_BUFR",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => WARNING
         );
--=====================================================
       VitalRecoveryRemovalCheck (
         Violation            => Tviol_GSR_I_posedge,
         TimingData           => Tmkr_GSR_I_posedge,
         TestSignal           => GSR_dly,
         TestSignalName       => "GSR",
         TestDelay            => tisd_GSR_I,
         RefSignal            => I_dly,
         RefSignalName        => "I",
         RefDelay             => ticd_I,
         Recovery             => trecovery_GSR_I_negedge_posedge,
         Removal              => tremoval_GSR_I_negedge_posedge,
         ActiveLow            => FALSE,
         CheckEnabled         => true,
         RefTransition        => 'R',
         HeaderMsg            => "/X_BUFR",
         Xon                  => Xon,
         MsgOn                => true,
         MsgSeverity          => warning);
--=====================================================
     end if;  -- End of (TimingChecksOn)

     Violation :=  Tviol_CE_I_posedge or 
                   Tviol_GSR_I_posedge;

     O_viol <= Violation xor O_zd; 

     wait on
       O_zd,
       I_dly,
       CLR_dly,
       CE_dly;
  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
--  Output Pin glitch declaration
     variable  O_GlitchData : VitalGlitchDataType;
  begin

--  Output-to-Clock path delay
     VitalPathDelay01
       (
         OutSignal     => O,
         GlitchData    => O_GlitchData,
         OutSignalName => "O",
         OutTemp       => O_viol,
         Paths         => (0 => (I_dly'last_event, tpd_I_O,TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     
     wait on O_viol;
  end process prcs_output;


end X_BUFR_V;

