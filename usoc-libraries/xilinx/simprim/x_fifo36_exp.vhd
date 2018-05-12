-- $Header: /devl/xcs/repo/env/Databases/CAEInterfaces/vhdsclibs/data/simprims/rainier/VITAL/Attic/x_fifo36_exp.vhd,v 1.8 2006/08/22 00:10:05 wloo Exp $
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2005 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  36K-Bit FIFO
-- /___/   /\     Filename : X_FIFO36_EXP.vhd
-- \   \  /  \    Timestamp : Tues October 18 16:43:59 PST 2005
--  \___\/\___\
--
-- Revision:
--    10/18/05 - Initial version.
--    08/17/06 - Fixed vital delay for vcs_mx (CR 419867).
-- End Revision

----- CELL X_FIFO36_EXP -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;

library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_FIFO36_EXP is
generic (

    TimingChecksOn : boolean := true;
    InstancePath   : string  := "*";
    Xon            : boolean := true;
    MsgOn          : boolean := true;

----- VITAL input wire delays
    tipd_DI    : VitalDelayArrayType01(31 downto 0) := (others => (0 ps, 0 ps));
    tipd_DIP   : VitalDelayArrayType01(3 downto 0)  := (others => (0 ps, 0 ps));
    tipd_RDCLKL : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_RDRCLKL : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_RDEN  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_RST   : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WRCLKL : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_WREN  : VitalDelayType01                   := ( 0 ps, 0 ps);
    tipd_GSR   : VitalDelayType01                   := ( 0 ps, 0 ps);

----- VITAL pin-to-pin propagation delays

    tpd_RDCLKL_DO          : VitalDelayArrayType01 (31 downto 0) := (others => (100 ps, 100 ps));
    tpd_RDCLKL_DOP         : VitalDelayArrayType01 (3 downto 0)  := (others => (100 ps, 100 ps));
    tpd_RDCLKL_EMPTY       : VitalDelayType01                    := ( 100 ps, 100 ps);
    tpd_RDCLKL_ALMOSTEMPTY : VitalDelayType01                    := ( 100 ps, 100 ps);
    tpd_RDCLKL_RDCOUNT     : VitalDelayArrayType01 (12 downto 0) := (others => (100 ps, 100 ps));
    tpd_RDCLKL_RDERR       : VitalDelayType01                    := ( 100 ps, 100 ps);

    tpd_RDRCLKL_DO          : VitalDelayArrayType01 (31 downto 0) := (others => (100 ps, 100 ps));
    tpd_RDRCLKL_DOP         : VitalDelayArrayType01 (3 downto 0)  := (others => (100 ps, 100 ps));
    tpd_RDRCLKL_EMPTY       : VitalDelayType01                    := ( 100 ps, 100 ps);
    tpd_RDRCLKL_ALMOSTEMPTY : VitalDelayType01                    := ( 100 ps, 100 ps);
    tpd_RDRCLKL_RDCOUNT     : VitalDelayArrayType01 (12 downto 0) := (others => (100 ps, 100 ps));
    tpd_RDRCLKL_RDERR       : VitalDelayType01                    := ( 100 ps, 100 ps);
    
    tpd_WRCLKL_FULL        : VitalDelayType01                    := ( 100 ps, 100 ps);
    tpd_WRCLKL_ALMOSTFULL  : VitalDelayType01                    := ( 100 ps, 100 ps);
    tpd_WRCLKL_WRCOUNT     : VitalDelayArrayType01 (12 downto 0) := (others => (100 ps, 100 ps));
    tpd_WRCLKL_WRERR       : VitalDelayType01                    := ( 100 ps, 100 ps);

    tpd_GSR_DO            : VitalDelayArrayType01 (31 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_DOP           : VitalDelayArrayType01 (3 downto 0)  := (others => (0 ps, 0 ps));
    tpd_GSR_EMPTY         : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_GSR_ALMOSTEMPTY   : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_GSR_FULL          : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_GSR_ALMOSTFULL    : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_GSR_RDCOUNT       : VitalDelayArrayType01 (12 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_RDERR         : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_GSR_WRCOUNT       : VitalDelayArrayType01 (12 downto 0) := (others => (0 ps, 0 ps));
    tpd_GSR_WRERR         : VitalDelayType01                    := ( 0 ps, 0 ps);

    tpd_RST_EMPTY              : VitalDelayType01                    := ( 0 ps, 0 ps);
    tbpd_RST_EMPTY_RDCLKL       : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_RST_ALMOSTEMPTY        : VitalDelayType01                    := ( 0 ps, 0 ps);
    tbpd_RST_ALMOSTEMPTY_RDCLKL : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_RST_FULL               : VitalDelayType01                    := ( 0 ps, 0 ps);
    tbpd_RST_FULL_WRCLKL        : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_RST_ALMOSTFULL         : VitalDelayType01                    := ( 0 ps, 0 ps);
    tbpd_RST_ALMOSTFULL_WRCLKL  : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_RST_RDCOUNT            : VitalDelayArrayType01 (12 downto 0) := (others => (0 ps, 0 ps));
    tbpd_RST_RDCOUNT_RDCLKL     : VitalDelayArrayType01 (12 downto 0) := (others => (0 ps, 0 ps));    
    tpd_RST_RDERR              : VitalDelayType01                    := ( 0 ps, 0 ps);
    tbpd_RST_RDERR_RDCLKL       : VitalDelayType01                    := ( 0 ps, 0 ps);
    tpd_RST_WRCOUNT            : VitalDelayArrayType01 (12 downto 0) := (others => (0 ps, 0 ps));
    tbpd_RST_WRCOUNT_WRCLKL     : VitalDelayArrayType01 (12 downto 0) := (others => (0 ps, 0 ps));
    tpd_RST_WRERR              : VitalDelayType01                    := ( 0 ps, 0 ps);
    tbpd_RST_WRERR_WRCLKL       : VitalDelayType01                    := ( 0 ps, 0 ps);
    
----- VITAL recovery time

    trecovery_GSR_WRCLKL_negedge_posedge : VitalDelayType := 0 ps;
    trecovery_GSR_RDCLKL_negedge_posedge : VitalDelayType := 0 ps;
    trecovery_GSR_RDRCLKL_negedge_posedge : VitalDelayType := 0 ps;

    trecovery_RST_WRCLKL_negedge_posedge : VitalDelayType := 0 ps;
    trecovery_RST_RDCLKL_negedge_posedge : VitalDelayType := 0 ps;
    trecovery_RST_RDRCLKL_negedge_posedge : VitalDelayType := 0 ps;    

----- VITAL removal time

    tremoval_GSR_WRCLKL_negedge_posedge : VitalDelayType  := 0 ps;
    tremoval_GSR_RDCLKL_negedge_posedge : VitalDelayType  := 0 ps;
    tremoval_GSR_RDRCLKL_negedge_posedge : VitalDelayType  := 0 ps;    

    tremoval_RST_WRCLKL_negedge_posedge : VitalDelayType  := 0 ps;
    tremoval_RST_RDCLKL_negedge_posedge : VitalDelayType  := 0 ps;
    tremoval_RST_RDRCLKL_negedge_posedge : VitalDelayType  := 0 ps;    

----- VITAL setup time

    tsetup_DI_WRCLKL_posedge_posedge   : VitalDelayArrayType (31 downto 0) := (others => 0 ps);
    tsetup_DI_WRCLKL_negedge_posedge   : VitalDelayArrayType (31 downto 0) := (others => 0 ps);
    tsetup_DIP_WRCLKL_posedge_posedge  : VitalDelayArrayType (3 downto 0)  := (others => 0 ps);
    tsetup_DIP_WRCLKL_negedge_posedge  : VitalDelayArrayType (3 downto 0)  := (others => 0 ps);
    tsetup_RDEN_RDCLKL_posedge_posedge : VitalDelayType := 0 ps;
    tsetup_RDEN_RDCLKL_negedge_posedge : VitalDelayType := 0 ps;
    tsetup_RDEN_RDRCLKL_posedge_posedge : VitalDelayType := 0 ps;
    tsetup_RDEN_RDRCLKL_negedge_posedge : VitalDelayType := 0 ps;    
    tsetup_WREN_WRCLKL_posedge_posedge : VitalDelayType := 0 ps;
    tsetup_WREN_WRCLKL_negedge_posedge : VitalDelayType := 0 ps;

----- VITAL hold time

    thold_DI_WRCLKL_posedge_posedge    : VitalDelayArrayType (31 downto 0) := (others => 0 ps);
    thold_DI_WRCLKL_negedge_posedge    : VitalDelayArrayType (31 downto 0) := (others => 0 ps);
    thold_DIP_WRCLKL_posedge_posedge   : VitalDelayArrayType (3 downto 0)  := (others => 0 ps);
    thold_DIP_WRCLKL_negedge_posedge   : VitalDelayArrayType (3 downto 0)  := (others => 0 ps);
    thold_RDEN_RDCLKL_posedge_posedge  : VitalDelayType := 0 ps;
    thold_RDEN_RDCLKL_negedge_posedge  : VitalDelayType := 0 ps;
    thold_RDEN_RDRCLKL_posedge_posedge  : VitalDelayType := 0 ps;
    thold_RDEN_RDRCLKL_negedge_posedge  : VitalDelayType := 0 ps;    
    thold_WREN_WRCLKL_posedge_posedge  : VitalDelayType := 0 ps;
    thold_WREN_WRCLKL_negedge_posedge  : VitalDelayType := 0 ps;

----- VITAL 
 
    tisd_DI_WRCLKL    : VitalDelayArrayType(31 downto 0) := (others => 0 ps); 
    tisd_DIP_WRCLKL   : VitalDelayArrayType(3 downto 0)  := (others => 0 ps);
    tisd_GSR_WRCLKL   : VitalDelayType                   := 0 ps;
    tisd_RST_WRCLKL   : VitalDelayType                   := 0 ps;

    tisd_RST_RDCLKL   : VitalDelayType                   := 0 ps;
    tisd_RST_RDRCLKL   : VitalDelayType                   := 0 ps;    
    tisd_RDEN_RDCLKL  : VitalDelayType                   := 0 ps;
    ticd_RDCLKL       : VitalDelayType                   := 0 ps;
    tisd_RDEN_RDRCLKL  : VitalDelayType                   := 0 ps;
    ticd_RDRCLKL       : VitalDelayType                   := 0 ps;
    
    tisd_WREN_WRCLKL  : VitalDelayType                   := 0 ps;
    ticd_WRCLKL       : VitalDelayType                   := 0 ps;

----- VITAL pulse width 
    tpw_RDCLKL_negedge : VitalDelayType := 0 ps;
    tpw_RDCLKL_posedge : VitalDelayType := 0 ps;
    tpw_RDRCLKL_negedge : VitalDelayType := 0 ps;
    tpw_RDRCLKL_posedge : VitalDelayType := 0 ps;
    
    tpw_RST_negedge : VitalDelayType := 0 ps;
    tpw_RST_posedge : VitalDelayType := 0 ps;

    tpw_WRCLKL_negedge : VitalDelayType := 0 ps;
    tpw_WRCLKL_posedge : VitalDelayType := 0 ps;

----- VITAL period
    tperiod_RDCLKL_posedge : VitalDelayType := 0 ps;
    tperiod_RDRCLKL_posedge : VitalDelayType := 0 ps;    

    tperiod_WRCLKL_posedge : VitalDelayType := 0 ps;

    
    ALMOST_EMPTY_OFFSET     : bit_vector := X"0080"; 
    ALMOST_FULL_OFFSET      : bit_vector := X"0080";
    DATA_WIDTH              : integer    := 4;
    DO_REG                  : integer    := 1;
    EN_SYN                  : boolean    := FALSE;
    FIRST_WORD_FALL_THROUGH : boolean    := FALSE;
    LOC                     : string     := "UNPLACED"
    
  );

port (

    ALMOSTEMPTY : out std_ulogic;
    ALMOSTFULL  : out std_ulogic;
    DO          : out std_logic_vector (31 downto 0);
    DOP         : out std_logic_vector (3 downto 0);
    EMPTY       : out std_ulogic;
    FULL        : out std_ulogic;
    RDCOUNT     : out std_logic_vector (12 downto 0);
    RDERR       : out std_ulogic;
    WRCOUNT     : out std_logic_vector (12 downto 0);
    WRERR       : out std_ulogic;

    DI          : in  std_logic_vector (31 downto 0);
    DIP         : in  std_logic_vector (3 downto 0);
    RDCLKL      : in  std_ulogic;
    RDCLKU      : in  std_ulogic;
    RDEN        : in  std_ulogic;
    RDRCLKL     : in  std_ulogic;
    RDRCLKU     : in  std_ulogic;
    RST         : in  std_ulogic;
    WRCLKL      : in  std_ulogic;
    WRCLKU      : in  std_ulogic;
    WREN        : in  std_ulogic    
  );

  attribute VITAL_LEVEL0 of
     X_FIFO36_EXP : entity is true;

end X_FIFO36_EXP;
                                                                        
architecture X_FIFO36_EXP_V of X_FIFO36_EXP is

  attribute VITAL_LEVEL0 of
    X_FIFO36_EXP_V : architecture is true;
  
  component X_AFIFO36_INTERNAL

      generic(
        ALMOST_FULL_OFFSET      : bit_vector := X"0080";
        ALMOST_EMPTY_OFFSET     : bit_vector := X"0080"; 
        DATA_WIDTH              : integer    := 4;
        DO_REG                  : integer    := 1;
        EN_ECC_READ : boolean := FALSE;
        EN_ECC_WRITE : boolean := FALSE;    
        EN_SYN                  : boolean    := FALSE;
        FIFO_SIZE               : integer    := 36;
        FIRST_WORD_FALL_THROUGH : boolean    := FALSE
        );

      port(
        ALMOSTEMPTY : out std_ulogic;
        ALMOSTFULL  : out std_ulogic;
        DBITERR       : out std_ulogic;
        DO          : out std_logic_vector (63 downto 0);
        DOP         : out std_logic_vector (7 downto 0);
        ECCPARITY   : out std_logic_vector (7 downto 0);
        EMPTY       : out std_ulogic;
        FULL        : out std_ulogic;
        RDCOUNT     : out std_logic_vector (12 downto 0);
        RDERR       : out std_ulogic;
        SBITERR     : out std_ulogic;
        WRCOUNT     : out std_logic_vector (12 downto 0);
        WRERR       : out std_ulogic;

        DI          : in  std_logic_vector (63 downto 0);
        DIP         : in  std_logic_vector (7 downto 0);
        RDCLK       : in  std_ulogic;
        RDRCLK       : in  std_ulogic;
        RDEN        : in  std_ulogic;
        RST         : in  std_ulogic;
        WRCLK       : in  std_ulogic;
        WREN        : in  std_ulogic
        );
  end component;

    
  signal GND_4 : std_logic_vector(3 downto 0) := (others => '0');
  signal GND_32 : std_logic_vector(31 downto 0) := (others => '0');
  signal OPEN_4 : std_logic_vector(3 downto 0);
  signal OPEN_32 : std_logic_vector(31 downto 0);
  signal OPEN_8 : std_logic_vector(7 downto 0);
  signal do_dly : std_logic_vector(31 downto 0) :=  (others => '0');
  signal dop_dly : std_logic_vector(3 downto 0) :=  (others => '0');
  signal almostfull_dly : std_ulogic := '0';
  signal almostempty_dly : std_ulogic := '0';
  signal empty_dly : std_ulogic := '0';
  signal full_dly : std_ulogic := '0';
  signal rderr_dly : std_ulogic := '0';
  signal wrerr_dly : std_ulogic := '0';
  signal rdcount_dly : std_logic_vector(12 downto 0) :=  (others => '0');
  signal wrcount_dly : std_logic_vector(12 downto 0) :=  (others => '0');

    constant MSB_MAX_DO  : integer    := 31;
    constant MSB_MAX_DOP : integer    := 3;
    constant MSB_MAX_RDCOUNT : integer    := 12;
    constant MSB_MAX_WRCOUNT : integer    := 12;

    constant MSB_MAX_DI  : integer    := 31;
    constant MSB_MAX_DIP : integer    := 3;

    signal DI_ipd    : std_logic_vector(MSB_MAX_DI downto 0)    := (others => 'X');
    signal DIP_ipd   : std_logic_vector(MSB_MAX_DIP downto 0)   := (others => 'X');
    signal GSR_ipd   : std_ulogic     :=    'X';
    signal RDCLKL_ipd : std_ulogic     :=    'X';
    signal RDRCLKL_ipd : std_ulogic     :=    'X';
    signal RDEN_ipd  : std_ulogic     :=    'X';
    signal RST_ipd   : std_ulogic     :=    'X';
    signal WRCLKL_ipd : std_ulogic     :=    'X';
    signal WREN_ipd  : std_ulogic     :=    'X';

    signal DI_dly    : std_logic_vector(MSB_MAX_DI downto 0)    := (others => 'X');
    signal DIP_dly   : std_logic_vector(MSB_MAX_DIP downto 0)   := (others => 'X');
    signal GSR_dly   : std_ulogic     :=    'X';
    signal RDCLKL_dly : std_ulogic     :=    'X';
    signal RDRCLKL_dly : std_ulogic     :=    'X';  
    signal RDEN_dly  : std_ulogic     :=    'X';
    signal RST_dly   : std_ulogic     :=    'X';
    signal WRCLKL_dly : std_ulogic     :=    'X';
    signal WREN_dly  : std_ulogic     :=    'X';

    signal DO_zd          : std_logic_vector(MSB_MAX_DO  downto 0)    := (others => '0');
    signal DOP_zd         : std_logic_vector(MSB_MAX_DOP downto 0)    := (others => '0');
    signal ALMOSTEMPTY_zd : std_ulogic     :=    '1';
    signal ALMOSTFULL_zd  : std_ulogic     :=    '0';
    signal EMPTY_zd       : std_ulogic     :=    '1';
    signal FULL_zd        : std_ulogic     :=    '0';
    signal RDCOUNT_zd     : std_logic_vector(MSB_MAX_RDCOUNT  downto 0)    := (others => '0');
    signal RDERR_zd       : std_ulogic     :=    '0';
    signal WRCOUNT_zd     : std_logic_vector(MSB_MAX_WRCOUNT  downto 0)    := (others => '0');
    signal WRERR_zd       : std_ulogic     :=    '0';
    signal violation : std_ulogic := '0'; 

begin

  ---------------------
  --  INPUT PATH DELAYs
  ---------------------

  WireDelay     : block
  begin
    DI_WireDelay : for i in MSB_MAX_DI downto 0 generate
        VitalWireDelay (DI_ipd(i),     DI(i),    tipd_DI(i));
    end generate DI_WireDelay;    

    DIP_WireDelay : for i in MSB_MAX_DIP downto 0 generate
        VitalWireDelay (DIP_ipd(i),     DIP(i),    tipd_DIP(i));
    end generate DIP_WireDelay;    

    VitalWireDelay (GSR_ipd,        GSR,        tipd_GSR);
    VitalWireDelay (RDEN_ipd,       RDEN,       tipd_RDEN);
    VitalWireDelay (RDCLKL_ipd,      RDCLKL,      tipd_RDCLKL);
    VitalWireDelay (RDRCLKL_ipd,      RDRCLKL,      tipd_RDRCLKL);
    VitalWireDelay (RST_ipd,        RST,        tipd_RST);
    VitalWireDelay (WREN_ipd,       WREN,       tipd_WREN);
    VitalWireDelay (WRCLKL_ipd,      WRCLKL,      tipd_WRCLKL);

  end block;


  SignalDelay : block
  begin

    DI_Delay : for i in MSB_MAX_DI downto 0 generate
        VitalSignalDelay (DI_dly(i),     DI_ipd(i),    tisd_DI_WRCLKL(i));  -- FP ??
    end generate DI_Delay;    

    DIP_Delay : for i in MSB_MAX_DIP downto 0 generate
        VitalSignalDelay (DIP_dly(i),     DIP_ipd(i),    tisd_DIP_WRCLKL(i));  -- FP ??
    end generate DIP_Delay;    

    VitalSignalDelay (GSR_dly,      GSR_ipd,    tisd_GSR_WRCLKL);           -- FP ??
    VitalSignalDelay (RDEN_dly,     RDEN_ipd,   tisd_RDEN_RDCLKL);          -- FP ??
    VitalSignalDelay (RDCLKL_dly,    RDCLKL_ipd,  ticd_RDCLKL);
    VitalSignalDelay (RDRCLKL_dly,    RDRCLKL_ipd,  ticd_RDRCLKL);    
    VitalSignalDelay (RST_dly,      RST_ipd,    tisd_RST_WRCLKL);           -- FP ??
    VitalSignalDelay (WREN_dly,     WREN_ipd,   tisd_WREN_WRCLKL);          -- FP ??
    VitalSignalDelay (WRCLKL_dly,    WRCLKL_ipd,  ticd_WRCLKL);


  end block;

  
X_FIFO36_EXP_inst : X_AFIFO36_INTERNAL
  generic map (
    ALMOST_FULL_OFFSET => ALMOST_FULL_OFFSET,
    ALMOST_EMPTY_OFFSET => ALMOST_EMPTY_OFFSET, 
    DATA_WIDTH => DATA_WIDTH,
    DO_REG => DO_REG,
    EN_SYN => EN_SYN,
    FIRST_WORD_FALL_THROUGH => FIRST_WORD_FALL_THROUGH
    )

  port map (
    DO(31 downto 0) => do_zd,
    DO(63 downto 32) => OPEN_32,
    DOP(3 downto 0) => dop_zd,
    DOP(7 downto 4) => OPEN_4,
    ALMOSTEMPTY => almostempty_zd,
    ALMOSTFULL => almostfull_zd,
    ECCPARITY => OPEN_8,
    EMPTY => empty_zd,
    FULL => full_zd,
    RDCOUNT => rdcount_zd,
    WRCOUNT => wrcount_zd,
    RDERR => rderr_zd,
    SBITERR => OPEN,
    DBITERR => OPEN,
    WRERR => wrerr_zd,
    DI(31 downto 0) => DI_dly,
    DI(63 downto 32) => GND_32,
    DIP(3 downto 0) => DIP_dly,
    DIP(7 downto 4) => GND_4,
    WREN => WREN_dly,
    RDEN => RDEN_dly,
    RDCLK => RDCLKL_dly,
    RDRCLK => RDRCLKL_dly,
    WRCLK => WRCLKL_dly,
    RST => RST_dly
    );



--####################################################################
--#####                   TIMING CHECKS                          #####
--####################################################################

  prcs_tmngchk:process

--  Pin Timing Violations (all input pins)
     variable Tviol_DI0_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI0_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI1_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI1_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI2_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI2_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI3_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI3_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI4_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI4_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI5_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI5_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI6_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI6_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI7_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI7_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI8_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI8_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI9_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI9_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI10_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI10_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI11_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI11_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI12_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI12_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI13_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI13_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI14_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI14_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI15_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI15_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI16_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI16_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI17_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI17_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI18_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI18_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI19_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI19_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI20_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI20_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI21_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI21_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI22_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI22_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI23_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI23_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI24_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI24_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI25_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI25_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI26_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI26_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI27_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI27_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI28_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI28_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI29_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI29_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI30_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI30_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DI31_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DI31_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DIP0_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DIP0_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DIP1_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DIP1_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DIP2_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DIP2_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DIP3_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DIP3_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RDEN_RDCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_RDEN_RDCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RDEN_RDRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_RDEN_RDRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;     
     variable Tviol_WREN_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_WREN_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_WRCLKL_posedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_WRCLKL_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_WRCLKL_negedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_WRCLKL_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_RDCLKL_negedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_RDCLKL_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_RDRCLKL_negedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_RDRCLKL_negedge : VitalTimingDataType := VitalTimingDataInit;
     
    variable PInfo_RDCLKL : VitalPeriodDataType := VitalPeriodDataInit;
    variable Pviol_RDCLKL : std_ulogic := '0';
    variable PInfo_RDRCLKL : VitalPeriodDataType := VitalPeriodDataInit;
    variable Pviol_RDRCLKL : std_ulogic := '0';
     
    variable PInfo_WRCLKL : VitalPeriodDataType := VitalPeriodDataInit;
    variable Pviol_WRCLKL : std_ulogic := '0';

    variable PInfo_RST : VitalPeriodDataType := VitalPeriodDataInit;
    variable Pviol_RST : std_ulogic := '0';

begin

--  Setup/Hold Check Violations (all input pins)

     if (TimingChecksOn) then
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI0_WRCLKL_posedge,
         TimingData     => Tmkr_DI0_WRCLKL_posedge,
         TestSignal     => DI_dly(0),
         TestSignalName => "DI(0)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(0),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(0),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(0),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(0),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI1_WRCLKL_posedge,
         TimingData     => Tmkr_DI1_WRCLKL_posedge,
         TestSignal     => DI_dly(1),
         TestSignalName => "DI(1)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(1),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(1),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(1),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(1),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI2_WRCLKL_posedge,
         TimingData     => Tmkr_DI2_WRCLKL_posedge,
         TestSignal     => DI_dly(2),
         TestSignalName => "DI(2)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(2),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(2),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(2),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(2),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI3_WRCLKL_posedge,
         TimingData     => Tmkr_DI3_WRCLKL_posedge,
         TestSignal     => DI_dly(3),
         TestSignalName => "DI(3)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(3),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(3),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(3),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(3),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI4_WRCLKL_posedge,
         TimingData     => Tmkr_DI4_WRCLKL_posedge,
         TestSignal     => DI_dly(4),
         TestSignalName => "DI(4)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(4),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(4),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(4),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(4),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI5_WRCLKL_posedge,
         TimingData     => Tmkr_DI5_WRCLKL_posedge,
         TestSignal     => DI_dly(5),
         TestSignalName => "DI(5)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(5),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(5),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(5),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(5),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI6_WRCLKL_posedge,
         TimingData     => Tmkr_DI6_WRCLKL_posedge,
         TestSignal     => DI_dly(6),
         TestSignalName => "DI(6)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(6),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(6),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(6),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(6),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI7_WRCLKL_posedge,
         TimingData     => Tmkr_DI7_WRCLKL_posedge,
         TestSignal     => DI_dly(7),
         TestSignalName => "DI(7)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(7),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(7),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(7),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(7),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI8_WRCLKL_posedge,
         TimingData     => Tmkr_DI8_WRCLKL_posedge,
         TestSignal     => DI_dly(8),
         TestSignalName => "DI(8)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(8),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(8),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(8),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(8),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI9_WRCLKL_posedge,
         TimingData     => Tmkr_DI9_WRCLKL_posedge,
         TestSignal     => DI_dly(9),
         TestSignalName => "DI(9)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(9),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(9),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(9),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(9),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI10_WRCLKL_posedge,
         TimingData     => Tmkr_DI10_WRCLKL_posedge,
         TestSignal     => DI_dly(10),
         TestSignalName => "DI(10)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(10),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(10),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(10),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(10),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI11_WRCLKL_posedge,
         TimingData     => Tmkr_DI11_WRCLKL_posedge,
         TestSignal     => DI_dly(11),
         TestSignalName => "DI(11)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(11),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(11),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(11),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(11),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI12_WRCLKL_posedge,
         TimingData     => Tmkr_DI12_WRCLKL_posedge,
         TestSignal     => DI_dly(12),
         TestSignalName => "DI(12)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(12),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(12),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(12),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(12),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI13_WRCLKL_posedge,
         TimingData     => Tmkr_DI13_WRCLKL_posedge,
         TestSignal     => DI_dly(13),
         TestSignalName => "DI(13)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(13),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(13),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(13),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(13),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI14_WRCLKL_posedge,
         TimingData     => Tmkr_DI14_WRCLKL_posedge,
         TestSignal     => DI_dly(14),
         TestSignalName => "DI(14)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(14),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(14),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(14),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(14),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI15_WRCLKL_posedge,
         TimingData     => Tmkr_DI15_WRCLKL_posedge,
         TestSignal     => DI_dly(15),
         TestSignalName => "DI(15)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(15),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(15),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(15),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(15),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI16_WRCLKL_posedge,
         TimingData     => Tmkr_DI16_WRCLKL_posedge,
         TestSignal     => DI_dly(16),
         TestSignalName => "DI(16)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(16),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(16),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(16),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(16),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI17_WRCLKL_posedge,
         TimingData     => Tmkr_DI17_WRCLKL_posedge,
         TestSignal     => DI_dly(17),
         TestSignalName => "DI(17)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(17),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(17),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(17),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(17),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI18_WRCLKL_posedge,
         TimingData     => Tmkr_DI18_WRCLKL_posedge,
         TestSignal     => DI_dly(18),
         TestSignalName => "DI(18)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(18),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(18),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(18),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(18),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI19_WRCLKL_posedge,
         TimingData     => Tmkr_DI19_WRCLKL_posedge,
         TestSignal     => DI_dly(19),
         TestSignalName => "DI(19)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(19),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(19),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(19),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(19),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI20_WRCLKL_posedge,
         TimingData     => Tmkr_DI20_WRCLKL_posedge,
         TestSignal     => DI_dly(20),
         TestSignalName => "DI(20)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(20),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(20),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(20),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(20),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI21_WRCLKL_posedge,
         TimingData     => Tmkr_DI21_WRCLKL_posedge,
         TestSignal     => DI_dly(21),
         TestSignalName => "DI(21)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(21),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(21),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(21),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(21),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI22_WRCLKL_posedge,
         TimingData     => Tmkr_DI22_WRCLKL_posedge,
         TestSignal     => DI_dly(22),
         TestSignalName => "DI(22)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(22),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(22),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(22),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(22),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI23_WRCLKL_posedge,
         TimingData     => Tmkr_DI23_WRCLKL_posedge,
         TestSignal     => DI_dly(23),
         TestSignalName => "DI(23)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(23),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(23),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(23),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(23),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI24_WRCLKL_posedge,
         TimingData     => Tmkr_DI24_WRCLKL_posedge,
         TestSignal     => DI_dly(24),
         TestSignalName => "DI(24)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(24),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(24),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(24),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(24),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI25_WRCLKL_posedge,
         TimingData     => Tmkr_DI25_WRCLKL_posedge,
         TestSignal     => DI_dly(25),
         TestSignalName => "DI(25)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(25),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(25),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(25),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(25),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI26_WRCLKL_posedge,
         TimingData     => Tmkr_DI26_WRCLKL_posedge,
         TestSignal     => DI_dly(26),
         TestSignalName => "DI(26)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(26),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(26),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(26),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(26),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI27_WRCLKL_posedge,
         TimingData     => Tmkr_DI27_WRCLKL_posedge,
         TestSignal     => DI_dly(27),
         TestSignalName => "DI(27)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(27),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(27),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(27),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(27),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI28_WRCLKL_posedge,
         TimingData     => Tmkr_DI28_WRCLKL_posedge,
         TestSignal     => DI_dly(28),
         TestSignalName => "DI(28)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(28),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(28),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(28),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(28),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI29_WRCLKL_posedge,
         TimingData     => Tmkr_DI29_WRCLKL_posedge,
         TestSignal     => DI_dly(29),
         TestSignalName => "DI(29)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(29),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(29),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(29),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(29),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI30_WRCLKL_posedge,
         TimingData     => Tmkr_DI30_WRCLKL_posedge,
         TestSignal     => DI_dly(30),
         TestSignalName => "DI(30)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(30),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(30),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(30),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(30),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DI31_WRCLKL_posedge,
         TimingData     => Tmkr_DI31_WRCLKL_posedge,
         TestSignal     => DI_dly(31),
         TestSignalName => "DI(31)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DI_WRCLKL_posedge_posedge(31),
         SetupLow       => tsetup_DI_WRCLKL_negedge_posedge(31),
         HoldLow        => thold_DI_WRCLKL_posedge_posedge(31),
         HoldHigh       => thold_DI_WRCLKL_negedge_posedge(31),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DIP0_WRCLKL_posedge,
         TimingData     => Tmkr_DIP0_WRCLKL_posedge,
         TestSignal     => DIP_dly(0),
         TestSignalName => "DIP(0)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DIP_WRCLKL_posedge_posedge(0),
         SetupLow       => tsetup_DIP_WRCLKL_negedge_posedge(0),
         HoldLow        => thold_DIP_WRCLKL_posedge_posedge(0),
         HoldHigh       => thold_DIP_WRCLKL_negedge_posedge(0),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DIP1_WRCLKL_posedge,
         TimingData     => Tmkr_DIP1_WRCLKL_posedge,
         TestSignal     => DIP_dly(1),
         TestSignalName => "DIP(1)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DIP_WRCLKL_posedge_posedge(1),
         SetupLow       => tsetup_DIP_WRCLKL_negedge_posedge(1),
         HoldLow        => thold_DIP_WRCLKL_posedge_posedge(1),
         HoldHigh       => thold_DIP_WRCLKL_negedge_posedge(1),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DIP2_WRCLKL_posedge,
         TimingData     => Tmkr_DIP2_WRCLKL_posedge,
         TestSignal     => DIP_dly(2),
         TestSignalName => "DIP(2)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DIP_WRCLKL_posedge_posedge(2),
         SetupLow       => tsetup_DIP_WRCLKL_negedge_posedge(2),
         HoldLow        => thold_DIP_WRCLKL_posedge_posedge(2),
         HoldHigh       => thold_DIP_WRCLKL_negedge_posedge(2),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DIP3_WRCLKL_posedge,
         TimingData     => Tmkr_DIP3_WRCLKL_posedge,
         TestSignal     => DIP_dly(3),
         TestSignalName => "DIP(3)",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_DIP_WRCLKL_posedge_posedge(3),
         SetupLow       => tsetup_DIP_WRCLKL_negedge_posedge(3),
         HoldLow        => thold_DIP_WRCLKL_posedge_posedge(3),
         HoldHigh       => thold_DIP_WRCLKL_negedge_posedge(3),
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_RDEN_RDCLKL_posedge,
         TimingData     => Tmkr_RDEN_RDCLKL_posedge,
         TestSignal     => RDEN_dly,
         TestSignalName => "RDEN",
         TestDelay      => 0 ns,
         RefSignal      => RDCLKL_dly,
         RefSignalName  => "RDCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_RDEN_RDCLKL_posedge_posedge,
         SetupLow       => tsetup_RDEN_RDCLKL_negedge_posedge,
         HoldLow        => thold_RDEN_RDCLKL_posedge_posedge,
         HoldHigh       => thold_RDEN_RDCLKL_negedge_posedge,
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_RDEN_RDRCLKL_posedge,
         TimingData     => Tmkr_RDEN_RDRCLKL_posedge,
         TestSignal     => RDEN_dly,
         TestSignalName => "RDEN",
         TestDelay      => 0 ns,
         RefSignal      => RDRCLKL_dly,
         RefSignalName  => "RDRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_RDEN_RDRCLKL_posedge_posedge,
         SetupLow       => tsetup_RDEN_RDRCLKL_negedge_posedge,
         HoldLow        => thold_RDEN_RDRCLKL_posedge_posedge,
         HoldHigh       => thold_RDEN_RDRCLKL_negedge_posedge,
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );     
     VitalSetupHoldCheck
       (
         Violation      => Tviol_WREN_WRCLKL_posedge,
         TimingData     => Tmkr_WREN_WRCLKL_posedge,
         TestSignal     => WREN_dly,
         TestSignalName => "WREN",
         TestDelay      => 0 ns,
         RefSignal      => WRCLKL_dly,
         RefSignalName  => "WRCLKL",
         RefDelay       => 0 ns,
         SetupHigh      => tsetup_WREN_WRCLKL_posedge_posedge,
         SetupLow       => tsetup_WREN_WRCLKL_negedge_posedge,
         HoldLow        => thold_WREN_WRCLKL_posedge_posedge,
         HoldHigh       => thold_WREN_WRCLKL_negedge_posedge,
         CheckEnabled   => (TO_X01(GSR_dly) = '0'),
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_FIFO36_EXP",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalRecoveryRemovalCheck (
        Violation            => Tviol_RST_WRCLKL_negedge,
        TimingData           => Tmkr_RST_WRCLKL_negedge,
        TestSignal           => RST_dly,
        TestSignalName       => "RST",
        TestDelay            => tisd_RST_WRCLKL,
        RefSignal            => WRCLKL_dly,
        RefSignalName        => "WRCLKL",
        RefDelay             => ticd_WRCLKL,
        Recovery             => trecovery_RST_WRCLKL_negedge_posedge,
        Removal              => tremoval_RST_WRCLKL_negedge_posedge,
        ActiveLow            => false,
        CheckEnabled         => (TO_X01(GSR_dly) = '0'),
        RefTransition        => 'R',
        HeaderMsg            => "/X_FIFO36_EXP",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
      VitalRecoveryRemovalCheck (
        Violation            => Tviol_RST_RDCLKL_negedge,
        TimingData           => Tmkr_RST_RDCLKL_negedge,
        TestSignal           => RST_dly,
        TestSignalName       => "RST",
        TestDelay            => tisd_RST_RDCLKL,
        RefSignal            => RDCLKL_dly,
        RefSignalName        => "RDCLKL",
        RefDelay             => ticd_RDCLKL,
        Recovery             => trecovery_RST_RDCLKL_negedge_posedge,
        Removal              => tremoval_RST_RDCLKL_negedge_posedge,
        ActiveLow            => false,
        CheckEnabled         => (TO_X01(GSR_dly) = '0'),
        RefTransition        => 'R',
        HeaderMsg            => "/X_FIFO36_EXP",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
      VitalRecoveryRemovalCheck (
        Violation            => Tviol_RST_RDRCLKL_negedge,
        TimingData           => Tmkr_RST_RDRCLKL_negedge,
        TestSignal           => RST_dly,
        TestSignalName       => "RST",
        TestDelay            => tisd_RST_RDRCLKL,
        RefSignal            => RDRCLKL_dly,
        RefSignalName        => "RDRCLKL",
        RefDelay             => ticd_RDRCLKL,
        Recovery             => trecovery_RST_RDRCLKL_negedge_posedge,
        Removal              => tremoval_RST_RDRCLKL_negedge_posedge,
        ActiveLow            => false,
        CheckEnabled         => (TO_X01(GSR_dly) = '0'),
        RefTransition        => 'R',
        HeaderMsg            => "/X_FIFO36_EXP",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
     VitalPeriodPulseCheck (
        Violation            => Pviol_RDCLKL,
        PeriodData           => PInfo_RDCLKL,
        TestSignal           => RDCLKL_dly,
        TestSignalName       => "RDCLKL",
        TestDelay            => 0 ps,
        Period               => tperiod_RDCLKL_posedge,
        PulseWidthHigh       => tpw_RDCLKL_posedge,
        PulseWidthLow        => tpw_RDCLKL_negedge,
        CheckEnabled         => (TO_X01(GSR_dly) = '0'),
        HeaderMsg            => "/X_FIFO36_EXP",
        Xon                  => Xon,
        MsgOn                => MsgOn,
        MsgSeverity          => Warning
      );
     VitalPeriodPulseCheck (
        Violation            => Pviol_RDRCLKL,
        PeriodData           => PInfo_RDRCLKL,
        TestSignal           => RDRCLKL_dly,
        TestSignalName       => "RDRCLKL",
        TestDelay            => 0 ps,
        Period               => tperiod_RDRCLKL_posedge,
        PulseWidthHigh       => tpw_RDRCLKL_posedge,
        PulseWidthLow        => tpw_RDRCLKL_negedge,
        CheckEnabled         => (TO_X01(GSR_dly) = '0'),
        HeaderMsg            => "/X_FIFO36_EXP",
        Xon                  => Xon,
        MsgOn                => MsgOn,
        MsgSeverity          => Warning
      );     
      VitalPeriodPulseCheck (
        Violation            => Pviol_WRCLKL,
        PeriodData           => PInfo_WRCLKL,
        TestSignal           => WRCLKL_dly,
        TestSignalName       => "WRCLKL",
        TestDelay            => 0 ps,
        Period               => tperiod_WRCLKL_posedge,
        PulseWidthHigh       => tpw_WRCLKL_posedge,
        PulseWidthLow        => tpw_WRCLKL_negedge,
        CheckEnabled         => (TO_X01(GSR_dly) = '0'),
        HeaderMsg            => "/X_FIFO36_EXP",
        Xon                  => Xon,
        MsgOn                => MsgOn,
        MsgSeverity          => Warning
      );
      VitalPeriodPulseCheck (
        Violation            => Pviol_RST,
        PeriodData           => PInfo_RST,
        TestSignal           => RST_dly,
        TestSignalName       => "RST",
        TestDelay            => 0 ps,
        Period               => 0 ps,
        PulseWidthHigh       => tpw_RST_posedge,
        PulseWidthLow        => tpw_RST_negedge,
        CheckEnabled         => (TO_X01(GSR_dly) = '0'),
        HeaderMsg            => "/X_FIFO36_EXP",
        Xon                  => Xon,
        MsgOn                => MsgOn,
        MsgSeverity          => Warning
      );

     end if;

     Violation         <=
       Pviol_RDCLKL or Pviol_RDRCLKL or
       Pviol_RST or Pviol_WRCLKL;
       
     --  Wait signal (input/output pins)
   wait on
     DI_dly,
     DIP_dly,
     RDCLKL_dly,
     RDRCLKL_dly,
     RDEN_dly,
     RST_dly,
     WRCLKL_dly,
     WREN_dly;
     
-- End of (TimingChecksOn)

end process prcs_tmngchk;
     
-------------------------------------------------------------------------------
-- Path delay
-------------------------------------------------------------------------------
   prcs_output:process (DO_zd, DOP_zd, EMPTY_zd, FULL_zd, ALMOSTEMPTY_zd, ALMOSTFULL_zd, RDCOUNT_zd, WRCOUNT_zd, RDERR_zd, WRERR_zd)
--  Output Pin glitch declaration
     variable  ALMOSTEMPTY_GlitchData : VitalGlitchDataType;
     variable  ALMOSTFULL_GlitchData : VitalGlitchDataType;
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
     variable  DO16_GlitchData : VitalGlitchDataType;
     variable  DO17_GlitchData : VitalGlitchDataType;
     variable  DO18_GlitchData : VitalGlitchDataType;
     variable  DO19_GlitchData : VitalGlitchDataType;
     variable  DO20_GlitchData : VitalGlitchDataType;
     variable  DO21_GlitchData : VitalGlitchDataType;
     variable  DO22_GlitchData : VitalGlitchDataType;
     variable  DO23_GlitchData : VitalGlitchDataType;
     variable  DO24_GlitchData : VitalGlitchDataType;
     variable  DO25_GlitchData : VitalGlitchDataType;
     variable  DO26_GlitchData : VitalGlitchDataType;
     variable  DO27_GlitchData : VitalGlitchDataType;
     variable  DO28_GlitchData : VitalGlitchDataType;
     variable  DO29_GlitchData : VitalGlitchDataType;
     variable  DO30_GlitchData : VitalGlitchDataType;
     variable  DO31_GlitchData : VitalGlitchDataType;
     variable  DOP0_GlitchData : VitalGlitchDataType;
     variable  DOP1_GlitchData : VitalGlitchDataType;
     variable  DOP2_GlitchData : VitalGlitchDataType;
     variable  DOP3_GlitchData : VitalGlitchDataType;
     variable  EMPTY_GlitchData : VitalGlitchDataType;
     variable  FULL_GlitchData : VitalGlitchDataType;
     variable  RDERR_GlitchData : VitalGlitchDataType;
     variable  WRERR_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT0_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT1_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT2_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT3_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT4_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT5_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT6_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT7_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT8_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT9_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT10_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT11_GlitchData : VitalGlitchDataType;
     variable  RDCOUNT12_GlitchData : VitalGlitchDataType;     
     variable  WRCOUNT0_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT1_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT2_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT3_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT4_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT5_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT6_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT7_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT8_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT9_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT10_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT11_GlitchData : VitalGlitchDataType;
     variable  WRCOUNT12_GlitchData : VitalGlitchDataType;     
     variable  DO_viol     : std_logic_vector(MSB_MAX_DI downto 0);
     variable  DOP_viol    : std_logic_vector(MSB_MAX_DIP downto 0);

     begin
       
    DO_viol(0)  := Violation xor DO_zd(0);
    DO_viol(1)  := Violation xor DO_zd(1);
    DO_viol(2)  := Violation xor DO_zd(2);
    DO_viol(3)  := Violation xor DO_zd(3);
    DO_viol(4)  := Violation xor DO_zd(4);
    DO_viol(5)  := Violation xor DO_zd(5);
    DO_viol(6)  := Violation xor DO_zd(6);
    DO_viol(7)  := Violation xor DO_zd(7);
    DO_viol(8)  := Violation xor DO_zd(8);
    DO_viol(9)  := Violation xor DO_zd(9);
    DO_viol(10) := Violation xor DO_zd(10);
    DO_viol(11) := Violation xor DO_zd(11);
    DO_viol(12) := Violation xor DO_zd(12);
    DO_viol(13) := Violation xor DO_zd(13);
    DO_viol(14) := Violation xor DO_zd(14);
    DO_viol(15) := Violation xor DO_zd(15);
    DO_viol(16) := Violation xor DO_zd(16);
    DO_viol(17) := Violation xor DO_zd(17);
    DO_viol(18) := Violation xor DO_zd(18);
    DO_viol(19) := Violation xor DO_zd(19);
    DO_viol(20) := Violation xor DO_zd(20);
    DO_viol(21) := Violation xor DO_zd(21);
    DO_viol(22) := Violation xor DO_zd(22);
    DO_viol(23) := Violation xor DO_zd(23);
    DO_viol(24) := Violation xor DO_zd(24);
    DO_viol(25) := Violation xor DO_zd(25);
    DO_viol(26) := Violation xor DO_zd(26);
    DO_viol(27) := Violation xor DO_zd(27);
    DO_viol(28) := Violation xor DO_zd(28);
    DO_viol(29) := Violation xor DO_zd(29);
    DO_viol(30) := Violation xor DO_zd(30);
    DO_viol(31) := Violation xor DO_zd(31);
    
    DOP_viol(0) := Violation xor DOP_zd(0);
    DOP_viol(1) := Violation xor DOP_zd(1);
    DOP_viol(2) := Violation xor DOP_zd(2);
    DOP_viol(3) := Violation xor DOP_zd(3);

     
--  Output-to-Clock path delay
     VitalPathDelay01
       (
         OutSignal     => ALMOSTEMPTY,
         GlitchData    => ALMOSTEMPTY_GlitchData,
         OutSignalName => "ALMOSTEMPTY",
         OutTemp       => ALMOSTEMPTY_zd,
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_ALMOSTEMPTY,TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_ALMOSTEMPTY,TRUE),
                           2 => (RST_dly'last_event, tpd_RST_ALMOSTEMPTY,TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => ALMOSTFULL,
         GlitchData    => ALMOSTFULL_GlitchData,
         OutSignalName => "ALMOSTFULL",
         OutTemp       => ALMOSTFULL_zd,
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_ALMOSTFULL,TRUE),
                           1 => (RST_dly'last_event, tpd_RST_ALMOSTFULL,TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(0),
         GlitchData    => DO0_GlitchData,
         OutSignalName => "DO(0)",
         OutTemp       => DO_viol(0),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(0),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(0),TRUE)),
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
         OutTemp       => DO_viol(1),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(1),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(1),TRUE)),
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
         OutTemp       => DO_viol(2),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(2),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(2),TRUE)),
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
         OutTemp       => DO_viol(3),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(3),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(3),TRUE)),
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
         OutTemp       => DO_viol(4),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(4),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(4),TRUE)),
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
         OutTemp       => DO_viol(5),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(5),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(5),TRUE)),
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
         OutTemp       => DO_viol(6),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(6),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(6),TRUE)),
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
         OutTemp       => DO_viol(7),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(7),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(7),TRUE)),
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
         OutTemp       => DO_viol(8),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(8),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(8),TRUE)),
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
         OutTemp       => DO_viol(9),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(9),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(9),TRUE)),
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
         OutTemp       => DO_viol(10),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(10),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(10),TRUE)),
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
         OutTemp       => DO_viol(11),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(11),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(11),TRUE)),
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
         OutTemp       => DO_viol(12),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(12),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(12),TRUE)),
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
         OutTemp       => DO_viol(13),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(13),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(13),TRUE)),
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
         OutTemp       => DO_viol(14),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(14),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(14),TRUE)),
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
         OutTemp       => DO_viol(15),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(15),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(15),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(16),
         GlitchData    => DO16_GlitchData,
         OutSignalName => "DO(16)",
         OutTemp       => DO_viol(16),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(16),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(16),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(17),
         GlitchData    => DO17_GlitchData,
         OutSignalName => "DO(17)",
         OutTemp       => DO_viol(17),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(17),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(17),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(18),
         GlitchData    => DO18_GlitchData,
         OutSignalName => "DO(18)",
         OutTemp       => DO_viol(18),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(18),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(18),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(19),
         GlitchData    => DO19_GlitchData,
         OutSignalName => "DO(19)",
         OutTemp       => DO_viol(19),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(19),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(19),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(20),
         GlitchData    => DO20_GlitchData,
         OutSignalName => "DO(20)",
         OutTemp       => DO_viol(20),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(20),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(20),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(21),
         GlitchData    => DO21_GlitchData,
         OutSignalName => "DO(21)",
         OutTemp       => DO_viol(21),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(21),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(21),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(22),
         GlitchData    => DO22_GlitchData,
         OutSignalName => "DO(22)",
         OutTemp       => DO_viol(22),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(22),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(22),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(23),
         GlitchData    => DO23_GlitchData,
         OutSignalName => "DO(23)",
         OutTemp       => DO_viol(23),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(23),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(23),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(24),
         GlitchData    => DO24_GlitchData,
         OutSignalName => "DO(24)",
         OutTemp       => DO_viol(24),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(24),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(24),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(25),
         GlitchData    => DO25_GlitchData,
         OutSignalName => "DO(25)",
         OutTemp       => DO_viol(25),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(25),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(25),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(26),
         GlitchData    => DO26_GlitchData,
         OutSignalName => "DO(26)",
         OutTemp       => DO_viol(26),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(26),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(26),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(27),
         GlitchData    => DO27_GlitchData,
         OutSignalName => "DO(27)",
         OutTemp       => DO_viol(27),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(27),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(27),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(28),
         GlitchData    => DO28_GlitchData,
         OutSignalName => "DO(28)",
         OutTemp       => DO_viol(28),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(28),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(28),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(29),
         GlitchData    => DO29_GlitchData,
         OutSignalName => "DO(29)",
         OutTemp       => DO_viol(29),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(29),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(29),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(30),
         GlitchData    => DO30_GlitchData,
         OutSignalName => "DO(30)",
         OutTemp       => DO_viol(30),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(30),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(30),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DO(31),
         GlitchData    => DO31_GlitchData,
         OutSignalName => "DO(31)",
         OutTemp       => DO_viol(31),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DO(31),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DO(31),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DOP(0),
         GlitchData    => DOP0_GlitchData,
         OutSignalName => "DOP(0)",
         OutTemp       => DOP_viol(0),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DOP(0),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DOP(0),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DOP(1),
         GlitchData    => DOP1_GlitchData,
         OutSignalName => "DOP(1)",
         OutTemp       => DOP_viol(1),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DOP(1),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DOP(0),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DOP(2),
         GlitchData    => DOP2_GlitchData,
         OutSignalName => "DOP(2)",
         OutTemp       => DOP_viol(2),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DOP(2),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DOP(0),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => DOP(3),
         GlitchData    => DOP3_GlitchData,
         OutSignalName => "DOP(3)",
         OutTemp       => DOP_viol(3),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_DOP(3),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_DOP(0),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => EMPTY,
         GlitchData    => EMPTY_GlitchData,
         OutSignalName => "EMPTY",
         OutTemp       => EMPTY_zd,
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_EMPTY,TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_EMPTY,TRUE),
                           2 => (RST_dly'last_event, tpd_RST_EMPTY,TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
         );
     VitalPathDelay01
       (
         OutSignal     => FULL,
         GlitchData    => FULL_GlitchData,
         OutSignalName => "FULL",
         OutTemp       => FULL_zd,
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_FULL,TRUE),
                           1 => (RST_dly'last_event, tpd_RST_FULL,TRUE)),         
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDERR,
         GlitchData    => RDERR_GlitchData,
         OutSignalName => "RDERR",
         OutTemp       => RDERR_zd,
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDERR,TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDERR,TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDERR,TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRERR,
         GlitchData    => WRERR_GlitchData,
         OutSignalName => "WRERR",
         OutTemp       => WRERR_zd,
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRERR,TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRERR,TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(0),
         GlitchData    => RDCOUNT0_GlitchData,
         OutSignalName => "RDCOUNT(0)",
         OutTemp       => RDCOUNT_zd(0),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(0),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(0),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(0),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(1),
         GlitchData    => RDCOUNT1_GlitchData,
         OutSignalName => "RDCOUNT(1)",
         OutTemp       => RDCOUNT_zd(1),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(1),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(1),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(1),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(2),
         GlitchData    => RDCOUNT2_GlitchData,
         OutSignalName => "RDCOUNT(2)",
         OutTemp       => RDCOUNT_zd(2),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(2),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(2),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(2),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(3),
         GlitchData    => RDCOUNT3_GlitchData,
         OutSignalName => "RDCOUNT(3)",
         OutTemp       => RDCOUNT_zd(3),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(3),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(3),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(3),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(4),
         GlitchData    => RDCOUNT4_GlitchData,
         OutSignalName => "RDCOUNT(4)",
         OutTemp       => RDCOUNT_zd(4),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(4),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(4),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(4),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(5),
         GlitchData    => RDCOUNT5_GlitchData,
         OutSignalName => "RDCOUNT(5)",
         OutTemp       => RDCOUNT_zd(5),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(5),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(5),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(5),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(6),
         GlitchData    => RDCOUNT6_GlitchData,
         OutSignalName => "RDCOUNT(6)",
         OutTemp       => RDCOUNT_zd(6),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(6),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(6),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(6),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(7),
         GlitchData    => RDCOUNT7_GlitchData,
         OutSignalName => "RDCOUNT(7)",
         OutTemp       => RDCOUNT_zd(7),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(7),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(7),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(7),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(8),
         GlitchData    => RDCOUNT8_GlitchData,
         OutSignalName => "RDCOUNT(8)",
         OutTemp       => RDCOUNT_zd(8),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(8),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(8),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(8),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(9),
         GlitchData    => RDCOUNT9_GlitchData,
         OutSignalName => "RDCOUNT(9)",
         OutTemp       => RDCOUNT_zd(9),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(9),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(9),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(9),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(10),
         GlitchData    => RDCOUNT10_GlitchData,
         OutSignalName => "RDCOUNT(10)",
         OutTemp       => RDCOUNT_zd(10),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(10),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(10),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(10),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(11),
         GlitchData    => RDCOUNT11_GlitchData,
         OutSignalName => "RDCOUNT(11)",
         OutTemp       => RDCOUNT_zd(11),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(11),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(11),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(11),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => RDCOUNT(12),
         GlitchData    => RDCOUNT12_GlitchData,
         OutSignalName => "RDCOUNT(12)",
         OutTemp       => RDCOUNT_zd(12),
         Paths         => (0 => (RDCLKL_dly'last_event, tpd_RDCLKL_RDCOUNT(12),TRUE),
                           1 => (RDRCLKL_dly'last_event, tpd_RDRCLKL_RDCOUNT(12),TRUE),
                           2 => (RST_dly'last_event, tpd_RST_RDCOUNT(12),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(0),
         GlitchData    => WRCOUNT0_GlitchData,
         OutSignalName => "WRCOUNT(0)",
         OutTemp       => WRCOUNT_zd(0),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(0),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(0),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(1),
         GlitchData    => WRCOUNT1_GlitchData,
         OutSignalName => "WRCOUNT(1)",
         OutTemp       => WRCOUNT_zd(1),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(1),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(1),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(2),
         GlitchData    => WRCOUNT2_GlitchData,
         OutSignalName => "WRCOUNT(2)",
         OutTemp       => WRCOUNT_zd(2),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(2),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(2),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(3),
         GlitchData    => WRCOUNT3_GlitchData,
         OutSignalName => "WRCOUNT(3)",
         OutTemp       => WRCOUNT_zd(3),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(3),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(3),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(4),
         GlitchData    => WRCOUNT4_GlitchData,
         OutSignalName => "WRCOUNT(4)",
         OutTemp       => WRCOUNT_zd(4),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(4),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(4),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(5),
         GlitchData    => WRCOUNT5_GlitchData,
         OutSignalName => "WRCOUNT(5)",
         OutTemp       => WRCOUNT_zd(5),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(5),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(5),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(6),
         GlitchData    => WRCOUNT6_GlitchData,
         OutSignalName => "WRCOUNT(6)",
         OutTemp       => WRCOUNT_zd(6),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(6),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(6),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(7),
         GlitchData    => WRCOUNT7_GlitchData,
         OutSignalName => "WRCOUNT(7)",
         OutTemp       => WRCOUNT_zd(7),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(7),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(7),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(8),
         GlitchData    => WRCOUNT8_GlitchData,
         OutSignalName => "WRCOUNT(8)",
         OutTemp       => WRCOUNT_zd(8),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(8),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(8),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(9),
         GlitchData    => WRCOUNT9_GlitchData,
         OutSignalName => "WRCOUNT(9)",
         OutTemp       => WRCOUNT_zd(9),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(9),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(9),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(10),
         GlitchData    => WRCOUNT10_GlitchData,
         OutSignalName => "WRCOUNT(10)",
         OutTemp       => WRCOUNT_zd(10),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(10),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(10),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(11),
         GlitchData    => WRCOUNT11_GlitchData,
         OutSignalName => "WRCOUNT(11)",
         OutTemp       => WRCOUNT_zd(11),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(11),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(11),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     VitalPathDelay01
       (
         OutSignal     => WRCOUNT(12),
         GlitchData    => WRCOUNT12_GlitchData,
         OutSignalName => "WRCOUNT(12)",
         OutTemp       => WRCOUNT_zd(12),
         Paths         => (0 => (WRCLKL_dly'last_event, tpd_WRCLKL_WRCOUNT(12),TRUE),
                           1 => (RST_dly'last_event, tpd_RST_WRCOUNT(12),TRUE)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );
     
  end process prcs_output;

  
end X_FIFO36_EXP_V;
-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Input Dual Data-Rate Register with Dual Clock inputs.
-- /___/   /\     Filename : X_IDDR_2CLK.vhd
-- \   \  /  \    Timestamp : Mon Jun 26 08:18:20 PST 2006
--  \___\/\___\
--
-- Revision:
--    06/26/06 - Initial version.
--    05/15/07 - CR 438883 fix
-- End Revision


----- CELL X_IDDR_2CLK -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_IDDR_2CLK is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";

--  VITAL input Pin path delay variables
      tipd_C    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CB    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_CE   : VitalDelayType01 := (0 ps, 0 ps);
      tipd_D    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR  : VitalDelayType01 := (0 ps, 0 ps);
      tipd_R    : VitalDelayType01 := (0 ps, 0 ps);
      tipd_S    : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_C_Q1  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_C_Q2  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CB_Q1  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_CB_Q2  : VitalDelayType01 := (100 ps, 100 ps);

--  VITAL async rest-to-output path delay variables
      tpd_R_Q1 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_R_Q2 : VitalDelayType01 := (0 ps, 0 ps);

      tbpd_R_Q1_C : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_R_Q1_CB : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_R_Q2_C : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_R_Q2_CB : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL async set-to-output path delay variables
      tpd_S_Q1 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_S_Q2 : VitalDelayType01 := (0 ps, 0 ps);

      tbpd_S_Q1_C : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_S_Q1_CB : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_S_Q2_C : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_S_Q2_CB : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_Q1 : VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q2 : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL ticd & tisd variables
      ticd_C     : VitalDelayType   := 0 ps;
      ticd_CB    : VitalDelayType   := 0 ps;
      tisd_D_C   : VitalDelayType   := 0 ps;
      tisd_D_CB  : VitalDelayType   := 0 ps;
      tisd_CE_C  : VitalDelayType   := 0 ps;
      tisd_CE_CB : VitalDelayType   := 0 ps;
      tisd_GSR_C : VitalDelayType   := 0 ps;
      tisd_R_C   : VitalDelayType   := 0 ps;
      tisd_R_CB  : VitalDelayType   := 0 ps;
      tisd_S_C   : VitalDelayType   := 0 ps;
      tisd_S_CB  : VitalDelayType   := 0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_CE_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_CE_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_CE_C_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_CE_CB_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_CB_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_CB_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_CE_CB_negedge_negedge : VitalDelayType := 0 ps;
      thold_CE_CB_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_CB_negedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_CB_posedge_negedge : VitalDelayType := 0 ps;
      thold_CE_CB_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_D_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_D_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_D_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_D_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_D_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_D_C_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_D_CB_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_CB_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_D_CB_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_D_CB_negedge_negedge : VitalDelayType := 0 ps;
      thold_D_CB_posedge_posedge  : VitalDelayType := 0 ps;
      thold_D_CB_negedge_posedge  : VitalDelayType := 0 ps;
      thold_D_CB_posedge_negedge : VitalDelayType := 0 ps;
      thold_D_CB_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_R_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_R_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_R_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_R_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_R_C_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_R_CB_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_CB_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_R_CB_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_R_CB_negedge_negedge : VitalDelayType := 0 ps;
      thold_R_CB_posedge_posedge  : VitalDelayType := 0 ps;
      thold_R_CB_negedge_posedge  : VitalDelayType := 0 ps;
      thold_R_CB_posedge_negedge : VitalDelayType := 0 ps;
      thold_R_CB_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_S_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_C_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_S_C_negedge_negedge : VitalDelayType := 0 ps;
      thold_S_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S_C_posedge_negedge : VitalDelayType := 0 ps;
      thold_S_C_negedge_negedge : VitalDelayType := 0 ps;

      tsetup_S_CB_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_CB_negedge_posedge : VitalDelayType := 0 ps;
      tsetup_S_CB_posedge_negedge : VitalDelayType := 0 ps;
      tsetup_S_CB_negedge_negedge : VitalDelayType := 0 ps;
      thold_S_CB_posedge_posedge  : VitalDelayType := 0 ps;
      thold_S_CB_negedge_posedge  : VitalDelayType := 0 ps;
      thold_S_CB_posedge_negedge : VitalDelayType := 0 ps;
      thold_S_CB_negedge_negedge : VitalDelayType := 0 ps;

-- VITAL pulse width variables
      tpw_C_posedge              : VitalDelayType := 0 ps;
      tpw_C_negedge              : VitalDelayType := 0 ps;
      tpw_CB_posedge              : VitalDelayType := 0 ps;
      tpw_CB_negedge              : VitalDelayType := 0 ps;
      tpw_GSR_posedge            : VitalDelayType := 0 ps;
      tpw_R_posedge              : VitalDelayType := 0 ps;
      tpw_S_posedge              : VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_C_posedge          : VitalDelayType := 0 ps;
      tperiod_CB_posedge          : VitalDelayType := 0 ps;

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

      trecovery_GSR_CB_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_R_CB_posedge_posedge   : VitalDelayType := 0 ps;
      trecovery_R_CB_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_R_CB_posedge_negedge   : VitalDelayType := 0 ps;
      trecovery_R_CB_negedge_negedge   : VitalDelayType := 0 ps;
      trecovery_S_CB_posedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_CB_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_S_CB_posedge_negedge   : VitalDelayType := 0 ps;
      trecovery_S_CB_negedge_negedge   : VitalDelayType := 0 ps;

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

      tremoval_GSR_CB_negedge_posedge  : VitalDelayType := 0 ps;
      tremoval_R_CB_posedge_posedge    : VitalDelayType := 0 ps;
      tremoval_R_CB_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_R_CB_posedge_negedge    : VitalDelayType := 0 ps;
      tremoval_R_CB_negedge_negedge    : VitalDelayType := 0 ps;
      tremoval_S_CB_posedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_CB_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_S_CB_posedge_negedge    : VitalDelayType := 0 ps;
      tremoval_S_CB_negedge_negedge    : VitalDelayType := 0 ps;

      DDR_CLK_EDGE : string := "OPPOSITE_EDGE";
      INIT_Q1      : bit    := '0';
      INIT_Q2      : bit    := '0';
      SRTYPE       : string := "SYNC"
      );

  port(
      Q1          : out std_ulogic;
      Q2          : out std_ulogic;

      C           : in  std_ulogic;
      CB          : in  std_ulogic;
      CE          : in  std_ulogic;
      D           : in  std_ulogic;
      R           : in  std_ulogic;
      S           : in  std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_IDDR_2CLK : entity is true;

end X_IDDR_2CLK;

architecture X_IDDR_2CLK_V OF X_IDDR_2CLK is

  attribute VITAL_LEVEL0 of
    X_IDDR_2CLK_V : architecture is true;


  constant SYNC_PATH_DELAY : time := 100 ps;

  signal C_ipd	        : std_ulogic := 'X';
  signal CB_ipd	        : std_ulogic := 'X';
  signal CE_ipd	        : std_ulogic := 'X';
  signal D_ipd	        : std_ulogic := 'X';
  signal GSR_ipd	: std_ulogic := '0';
  signal R_ipd		: std_ulogic := 'X';
  signal S_ipd		: std_ulogic := 'X';

  signal C_dly	        : std_ulogic := 'X';
  signal CB_dly	        : std_ulogic := 'X';
  signal CE_C_dly       : std_ulogic := 'X';
  signal CE_CB_dly      : std_ulogic := 'X';
  signal D_C_dly        : std_ulogic := 'X';
  signal D_CB_dly       : std_ulogic := 'X';
  signal GSR_dly	: std_ulogic := '0';
  signal R_dly		: std_ulogic := 'X';
  signal S_dly		: std_ulogic := 'X';
  signal R_C_dly	: std_ulogic := 'X';
  signal R_CB_dly	: std_ulogic := 'X';
  signal S_C_dly	: std_ulogic := 'X';
  signal S_CB_dly	: std_ulogic := 'X';

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
    VitalWireDelay (CB_ipd,  CB,  tipd_CB);
    VitalWireDelay (CE_ipd,  CE,  tipd_CE);
    VitalWireDelay (D_ipd,   D,   tipd_D);
    VitalWireDelay (GSR_ipd, GSR, tipd_GSR);
    VitalWireDelay (R_ipd,   R,   tipd_R);
    VitalWireDelay (S_ipd,   S,   tipd_S);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C_dly,     C_ipd,   ticd_C);
    VitalSignalDelay (CB_dly,    CB_ipd,  ticd_CB);
    VitalSignalDelay (CE_C_dly,  CE_ipd,  tisd_CE_C);
    VitalSignalDelay (CE_CB_dly, CE_ipd,  tisd_CE_CB);
    VitalSignalDelay (D_C_dly,   D_ipd,   tisd_D_C);
    VitalSignalDelay (D_CB_dly,  D_ipd,   tisd_D_CB);
    VitalSignalDelay (GSR_dly,   GSR_ipd, tisd_GSR_C);
    VitalSignalDelay (R_C_dly,   R_ipd,   tisd_R_C);
    VitalSignalDelay (R_CB_dly,  R_ipd,   tisd_R_CB);
    VitalSignalDelay (S_C_dly,   S_ipd,   tisd_S_C);
    VitalSignalDelay (S_CB_dly,  S_ipd,   tisd_S_CB);
  end block;

  R_dly <= R_ipd;
  S_dly <= S_ipd;


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
             EntityName => "/X_IDDR_2CLK",
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
             EntityName => "/X_IDDR_2CLK",
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
  prcs_q1q2q3q4_reg:process(C_dly, CB_dly, GSR_dly, R_dly, S_dly)
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
                      if(rising_edge(C_dly)) then
                         if(CE_C_dly = '1') then
                            Q3_var := Q1_var;
                            Q1_var := D_C_dly;
                            Q4_var := Q2_var;
                         end if;
                      end if;
                      if(rising_edge(CB_dly)) then
                        if(CE_CB_dly = '1') then
                            Q2_var := D_CB_dly;
                        end if;
                      end if;
                   end if;

           when 2 => 
                   if(rising_edge(C_dly)) then
                      if(R_C_dly = '1') then
                         Q1_var := '0';
                         Q3_var := '0';
                         Q4_var := '0';
                      elsif((R_C_dly = '0') and (S_C_dly = '1')) then
                         Q1_var := '1';
                         Q3_var := '1';
                         Q4_var := '1';
                      elsif((R_C_dly = '0') and (S_C_dly = '0')) then
                         if(CE_C_dly = '1') then
                               Q3_var := Q1_var;
                               Q1_var := D_C_dly;
                               Q4_var := Q2_var;
                         end if;
                      end if;
                   end if;
                        
                   if(rising_edge(CB_dly)) then
                      if(R_CB_dly = '1') then
                         Q2_var := '0';
                      elsif((R_CB_dly = '0') and (S_CB_dly = '1')) then
                         Q2_var := '1';
                      elsif((R_CB_dly = '0') and (S_CB_dly = '0')) then
                         if(CE_CB_dly = '1') then
                               Q2_var := D_CB_dly;
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

  variable PInfo_CB           : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_CB           : std_ulogic          := '0';

  variable PInfo_R            : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_R            : std_ulogic          := '0';

  variable PInfo_S            : VitalPeriodDataType := VitalPeriodDataInit;
  variable Pviol_S            : std_ulogic          := '0';

  variable Tmkr_D_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D_C_posedge  : std_ulogic          := '0';

  variable Tmkr_D_CB_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_D_CB_posedge  : std_ulogic          := '0';

  variable Tmkr_CE_C_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_C_posedge : std_ulogic          := '0';

  variable Tmkr_CE_CB_posedge  : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_CE_CB_posedge : std_ulogic          := '0';

  variable Tmkr_R_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C_posedge  : std_ulogic          := '0';
  variable Tmkr_R_C_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_C_negedge  : std_ulogic          := '0';

  variable Tmkr_R_CB_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_CB_posedge  : std_ulogic          := '0';
  variable Tmkr_R_CB_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_R_CB_negedge  : std_ulogic          := '0';

  variable Tmkr_S_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C_posedge  : std_ulogic          := '0';
  variable Tmkr_S_C_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_C_negedge  : std_ulogic          := '0';

  variable Tmkr_S_CB_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_CB_posedge  : std_ulogic          := '0';
  variable Tmkr_S_CB_negedge   : VitalTimingDataType := VitalTimingDataInit;
  variable Tviol_S_CB_negedge  : std_ulogic          := '0';

  variable Violation          : std_ulogic          := '0';
  begin
    if (TimingChecksOn) then
      VitalPeriodPulseCheck (
        Violation            => Pviol_C,
        PeriodData           => PInfo_C,
        TestSignal           => C_dly,
        TestSignalName       => "C",
        TestDelay            => 0 ps,
        Period               => tperiod_C_posedge,
        PulseWidthHigh       => tpw_C_posedge,
        PulseWidthLow        => tpw_C_posedge,
        CheckEnabled         => TO_X01(CE_C_dly) /= '0',
        HeaderMsg            => "/X_IDDR_2CLK",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);
      VitalPeriodPulseCheck (
        Violation            => Pviol_CB,
        PeriodData           => PInfo_CB,
        TestSignal           => CB_dly,
        TestSignalName       => "CB",
        TestDelay            => 0 ps,
        Period               => tperiod_CB_posedge,
        PulseWidthHigh       => tpw_CB_posedge,
        PulseWidthLow        => tpw_CB_posedge,
        CheckEnabled         => TO_X01(CE_CB_dly) /= '0',
        HeaderMsg            => "/X_IDDR_2CLK",
        Xon                  => Xon,
        MsgOn                => true,
        MsgSeverity          => warning);        


      if (SRTYPE = "ASYNC" ) then 
        VitalSetupHoldCheck (
          Violation            => Tviol_D_C_posedge,
          TimingData           => Tmkr_D_C_posedge,
          TestSignal           => D_C_dly,
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
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);
        VitalSetupHoldCheck (
          Violation            => Tviol_D_CB_posedge,
          TimingData           => Tmkr_D_CB_posedge,
          TestSignal           => D_CB_dly,
          TestSignalName       => "D",
          TestDelay            => tisd_D_CB,
          RefSignal            => CB_dly,
          RefSignalName        => "CB",
          RefDelay             => ticd_CB,
          SetupHigh            => tsetup_D_CB_posedge_posedge,
          SetupLow             => tsetup_D_CB_negedge_posedge,
          HoldLow              => thold_D_CB_posedge_posedge,
          HoldHigh             => thold_D_CB_negedge_posedge,
          CheckEnabled         => TO_X01(((not R_dly)) and (CB_dly)
                                         and ((not S_dly))) /= '0',
          RefTransition        => 'R',
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);
        VitalSetupHoldCheck (
          Violation            => Tviol_CE_C_posedge,
          TimingData           => Tmkr_CE_C_posedge,
          TestSignal           => CE_C_dly,
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
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);
        VitalSetupHoldCheck (
          Violation            => Tviol_CE_CB_posedge,
          TimingData           => Tmkr_CE_CB_posedge,
          TestSignal           => CE_CB_dly,
          TestSignalName       => "CE",
          TestDelay            => tisd_CE_CB,
          RefSignal            => CB_dly,
          RefSignalName        => "CB",
          RefDelay             => ticd_CB,
          SetupHigh            => tsetup_CE_CB_posedge_posedge,
          SetupLow             => tsetup_CE_CB_negedge_posedge,
          HoldLow              => thold_CE_CB_posedge_posedge,
          HoldHigh             => thold_CE_CB_negedge_posedge,
          CheckEnabled         => TO_X01(((not R_dly)) and ((not S_dly))) /= '0',
          RefTransition        => 'R',
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);         
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_R_C_posedge,
           TimingData           => Tmkr_R_C_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => 0 ps,
           RefSignal            => C_dly,
           RefSignalName        => "C",
           RefDelay             => 0 ps,
           Recovery             => trecovery_R_C_negedge_posedge,
           Removal              => tremoval_R_C_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => TO_X01(CE_C_dly) /= '0' and (D_C_dly /= '0' or Q1_zd /= '0'),
           RefTransition        => 'R',
           HeaderMsg            => "/X_IDDR_2CLK",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => warning);
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_R_CB_posedge,
           TimingData           => Tmkr_R_CB_posedge,
           TestSignal           => R_dly,
           TestSignalName       => "R",
           TestDelay            => 0 ps,
           RefSignal            => CB_dly,
           RefSignalName        => "CB",
           RefDelay             => 0 ps,
           Recovery             => trecovery_R_CB_negedge_posedge,
           Removal              => tremoval_R_CB_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => TO_X01(CE_CB_dly) /= '0' and (D_CB_dly /= '0' or Q1_zd /= '0'),
           RefTransition        => 'R',
           HeaderMsg            => "/X_IDDR_2CLK",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => warning);
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_S_C_posedge,
           TimingData           => Tmkr_S_C_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => 0 ps,
           RefSignal            => C_dly,
           RefSignalName        => "C",
           RefDelay             => 0 ps,
           Recovery             => trecovery_S_C_negedge_posedge,
           Removal              => thold_S_C_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => TO_X01((not R_dly) and CE_C_dly) /= '0' and D_C_dly /= '1' and Q2_zd /= '1',
           RefTransition        => 'R',
           HeaderMsg            => "/X_IDDR_2CLK",
           Xon                  => Xon,
           MsgOn                => true,
           MsgSeverity          => warning);
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_S_CB_posedge,
           TimingData           => Tmkr_S_CB_posedge,
           TestSignal           => S_dly,
           TestSignalName       => "S",
           TestDelay            => 0 ps,
           RefSignal            => CB_dly,
           RefSignalName        => "C",
           RefDelay             => 0 ps,
           Recovery             => trecovery_S_CB_negedge_posedge,
           Removal              => thold_S_CB_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => TO_X01((not R_dly) and CE_CB_dly) /= '0' and D_CB_dly /= '1' and Q2_zd /= '1',
           RefTransition        => 'R',
           HeaderMsg            => "/X_IDDR_2CLK",
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
             HeaderMsg            => "/X_IDDR_2CLK",
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
             HeaderMsg            => "/X_IDDR_2CLK",
             Xon                  => Xon,
             MsgOn                => true,
             MsgSeverity          => warning);                           
        if (DDR_CLK_EDGE = "OPPOSITE_EDGE" ) then
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_R_C_negedge,
              TimingData           => Tmkr_R_C_negedge,
              TestSignal           => R_dly,
              TestSignalName       => "R",
              TestDelay            => 0 ps,
              RefSignal            => C_dly,
              RefSignalName        => "C",
              RefDelay             => 0 ps,
              Recovery             => trecovery_R_C_negedge_negedge,
              Removal              => tremoval_R_C_negedge_negedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01(CE_C_dly) /= '0' and (D_C_dly /= '0' or Q1_zd /= '0'),
              RefTransition        => 'F',
              HeaderMsg            => "/X_IDDR_2CLK",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_R_CB_negedge,
              TimingData           => Tmkr_R_CB_negedge,
              TestSignal           => R_dly,
              TestSignalName       => "R",
              TestDelay            => 0 ps,
              RefSignal            => CB_dly,
              RefSignalName        => "CB",
              RefDelay             => 0 ps,
              Recovery             => trecovery_R_CB_negedge_negedge,
              Removal              => tremoval_R_CB_negedge_negedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01(CE_CB_dly) /= '0' and (D_CB_dly /= '0' or Q1_zd /= '0'),
              RefTransition        => 'F',
              HeaderMsg            => "/X_IDDR_2CLK",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);

        end if;


        if (DDR_CLK_EDGE = "OPPOSITE_EDGE" ) then
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_S_C_negedge,
              TimingData           => Tmkr_S_C_negedge,
              TestSignal           => S_dly,
              TestSignalName       => "S",
              TestDelay            => 0 ps,
              RefSignal            => C_dly,
              RefSignalName        => "C",
              RefDelay             => 0 ps,
              Recovery             => trecovery_S_C_negedge_negedge,
              Removal              => thold_S_C_negedge_negedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01((not R_dly) and CE_C_dly) /= '0' and D_C_dly /= '1' and Q2_zd /= '1',
              RefTransition        => 'F',
              HeaderMsg            => "/X_IDDR_2CLK",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);
           VitalRecoveryRemovalCheck (
              Violation            => Tviol_S_CB_negedge,
              TimingData           => Tmkr_S_CB_negedge,
              TestSignal           => S_dly,
              TestSignalName       => "S",
              TestDelay            => 0 ps,
              RefSignal            => CB_dly,
              RefSignalName        => "CB",
              RefDelay             => 0 ps,
              Recovery             => trecovery_S_CB_negedge_negedge,
              Removal              => thold_S_CB_negedge_negedge,
              ActiveLow            => false,
              CheckEnabled         => TO_X01((not R_dly) and CE_CB_dly) /= '0' and D_CB_dly /= '1' and Q2_zd /= '1',
              RefTransition        => 'F',
              HeaderMsg            => "/X_IDDR_2CLK",
              Xon                  => Xon,
              MsgOn                => true,
              MsgSeverity          => warning);
        end if;

      elsif (SRTYPE = "SYNC" ) then
        VitalSetupHoldCheck (
          Violation            => Tviol_D_C_posedge,
          TimingData           => Tmkr_D_C_posedge,
          TestSignal           => D_C_dly,
          TestSignalName       => "D",
          TestDelay            => tisd_D_C,
          RefSignal            => C_dly,
          RefSignalName        => "C",
          RefDelay             => ticd_C,
          SetupHigh            => tsetup_D_C_posedge_posedge,
          SetupLow             => tsetup_D_C_negedge_posedge,
          HoldLow              => thold_D_C_posedge_posedge,
          HoldHigh             => thold_D_C_negedge_posedge,
          CheckEnabled         => TO_X01(((not R_C_dly)) and (C_dly)
                                         and ((not S_C_dly))) /= '0',
          RefTransition        => 'R',
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);
        VitalSetupHoldCheck (
          Violation            => Tviol_D_CB_posedge,
          TimingData           => Tmkr_D_CB_posedge,
          TestSignal           => D_CB_dly,
          TestSignalName       => "D",
          TestDelay            => tisd_D_CB,
          RefSignal            => CB_dly,
          RefSignalName        => "CB",
          RefDelay             => ticd_CB,
          SetupHigh            => tsetup_D_CB_posedge_posedge,
          SetupLow             => tsetup_D_CB_negedge_posedge,
          HoldLow              => thold_D_CB_posedge_posedge,
          HoldHigh             => thold_D_CB_negedge_posedge,
          CheckEnabled         => TO_X01(((not R_CB_dly)) and (CB_dly)
                                         and ((not S_CB_dly))) /= '0',
          RefTransition        => 'R',
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);
        VitalSetupHoldCheck (
          Violation            => Tviol_CE_C_posedge,
          TimingData           => Tmkr_CE_C_posedge,
          TestSignal           => CE_C_dly,
          TestSignalName       => "CE",
          TestDelay            => tisd_CE_C,
          RefSignal            => C_dly,
          RefSignalName        => "C",
          RefDelay             => ticd_C,
          SetupHigh            => tsetup_CE_C_posedge_posedge,
          SetupLow             => tsetup_CE_C_negedge_posedge,
          HoldLow              => thold_CE_C_posedge_posedge,
          HoldHigh             => thold_CE_C_negedge_posedge,
          CheckEnabled         => TO_X01(((not R_C_dly)) and ((not S_C_dly))) /= '0',
          RefTransition        => 'R',
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);
        VitalSetupHoldCheck (
          Violation            => Tviol_CE_CB_posedge,
          TimingData           => Tmkr_CE_CB_posedge,
          TestSignal           => CE_CB_dly,
          TestSignalName       => "CE",
          TestDelay            => tisd_CE_CB,
          RefSignal            => CB_dly,
          RefSignalName        => "CB",
          RefDelay             => ticd_CB,
          SetupHigh            => tsetup_CE_CB_posedge_posedge,
          SetupLow             => tsetup_CE_CB_negedge_posedge,
          HoldLow              => thold_CE_CB_posedge_posedge,
          HoldHigh             => thold_CE_CB_negedge_posedge,
          CheckEnabled         => TO_X01(((not R_CB_dly)) and ((not S_CB_dly))) /= '0',
          RefTransition        => 'R',
          HeaderMsg            => "/X_IDDR_2CLK",
          Xon                  => Xon,
          MsgOn                => true,
          MsgSeverity          => warning);                   
        VitalSetupHoldCheck (
          Violation      => Tviol_R_C_posedge,
          TimingData     => Tmkr_R_C_posedge,
          TestSignal     => R_C_dly,
          TestSignalName => "R",
          TestDelay      => tisd_R_C,
          RefSignal      => C_dly,
          RefSignalName  => "C",
          RefDelay       => ticd_C,
          SetupHigh      => tsetup_R_C_posedge_posedge,
          SetupLow       => tsetup_R_C_negedge_posedge,
          HoldLow        => thold_R_C_posedge_posedge,
          HoldHigh       => thold_R_C_negedge_posedge,
          CheckEnabled   => TO_X01(((not S_C_dly)) and ((not R_C_dly))) /= '0',
          RefTransition  => 'R',
          HeaderMsg      => "/X_IDDR_2CLK",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => warning);
        VitalSetupHoldCheck (
          Violation      => Tviol_R_CB_posedge,
          TimingData     => Tmkr_R_CB_posedge,
          TestSignal     => R_CB_dly,
          TestSignalName => "R",
          TestDelay      => tisd_R_CB,
          RefSignal      => CB_dly,
          RefSignalName  => "CB",
          RefDelay       => ticd_CB,
          SetupHigh      => tsetup_R_CB_posedge_posedge,
          SetupLow       => tsetup_R_CB_negedge_posedge,
          HoldLow        => thold_R_CB_posedge_posedge,
          HoldHigh       => thold_R_CB_negedge_posedge,
          CheckEnabled   => TO_X01(((not S_CB_dly)) and ((not R_CB_dly))) /= '0',
          RefTransition  => 'R',
          HeaderMsg      => "/X_IDDR_2CLK",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => warning);
        VitalSetupHoldCheck (
          Violation      => Tviol_R_C_negedge,
          TimingData     => Tmkr_R_C_negedge,
          TestSignal     => R_C_dly,
          TestSignalName => "R",
          TestDelay      => tisd_R_C,
          RefSignal      => C_dly,
          RefSignalName  => "C",
          RefDelay       => ticd_C,
          SetupHigh      => tsetup_R_C_posedge_negedge,
          SetupLow       => tsetup_R_C_negedge_negedge,
          HoldLow        => thold_R_C_posedge_negedge,
          HoldHigh       => thold_R_C_negedge_negedge,
          CheckEnabled   => TO_X01(((not S_C_dly)) and ((not R_C_dly))) /= '0',
          RefTransition  => 'F',
          HeaderMsg      => "/X_IDDR_2CLK",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => warning);
        VitalSetupHoldCheck (
          Violation      => Tviol_R_CB_negedge,
          TimingData     => Tmkr_R_CB_negedge,
          TestSignal     => R_CB_dly,
          TestSignalName => "R",
          TestDelay      => tisd_R_CB,
          RefSignal      => CB_dly,
          RefSignalName  => "CB",
          RefDelay       => ticd_CB,
          SetupHigh      => tsetup_R_CB_posedge_negedge,
          SetupLow       => tsetup_R_CB_negedge_negedge,
          HoldLow        => thold_R_CB_posedge_negedge,
          HoldHigh       => thold_R_CB_negedge_negedge,
          CheckEnabled   => TO_X01(((not S_CB_dly)) and ((not R_CB_dly))) /= '0',
          RefTransition  => 'F',
          HeaderMsg      => "/X_IDDR_2CLK",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => warning);
        VitalSetupHoldCheck (
          Violation      => Tviol_S_C_posedge,
          TimingData     => Tmkr_S_C_posedge,
          TestSignal     => S_C_dly,
          TestSignalName => "S",
          TestDelay      => tisd_S_C,
          RefSignal      => C_dly,
          RefSignalName  => "C",
          RefDelay       => ticd_C,
          SetupHigh      => tsetup_S_C_posedge_posedge,
          SetupLow       => tsetup_S_C_negedge_posedge,
          HoldLow        => thold_S_C_posedge_posedge,
          HoldHigh       => thold_S_C_negedge_posedge,
          CheckEnabled   => TO_X01(not R_C_dly) /= '0',
          RefTransition  => 'R',
          HeaderMsg      => "/X_IDDR_2CLK",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => warning);
        VitalSetupHoldCheck (
          Violation      => Tviol_S_CB_posedge,
          TimingData     => Tmkr_S_CB_posedge,
          TestSignal     => S_CB_dly,
          TestSignalName => "S",
          TestDelay      => tisd_S_CB,
          RefSignal      => CB_dly,
          RefSignalName  => "CB",
          RefDelay       => ticd_CB,
          SetupHigh      => tsetup_S_CB_posedge_posedge,
          SetupLow       => tsetup_S_CB_negedge_posedge,
          HoldLow        => thold_S_CB_posedge_posedge,
          HoldHigh       => thold_S_CB_negedge_posedge,
          CheckEnabled   => TO_X01(not R_CB_dly) /= '0',
          RefTransition  => 'R',
          HeaderMsg      => "/X_IDDR_2CLK",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => warning);
        VitalSetupHoldCheck (
          Violation      => Tviol_S_C_negedge,
          TimingData     => Tmkr_S_C_negedge,
          TestSignal     => S_C_dly,
          TestSignalName => "S",
          TestDelay      => tisd_S_C,
          RefSignal      => C_dly,
          RefSignalName  => "C",
          RefDelay       => ticd_C,
          SetupHigh      => tsetup_S_C_posedge_negedge,
          SetupLow       => tsetup_S_C_negedge_negedge,
          HoldLow        => thold_S_C_posedge_negedge,
          HoldHigh       => thold_S_C_negedge_negedge,
          CheckEnabled   => TO_X01(not R_C_dly) /= '0',
          RefTransition  => 'F',
          HeaderMsg      => "/X_IDDR_2CLK",
          Xon            => Xon,
          MsgOn          => true,
          MsgSeverity    => warning);
        VitalSetupHoldCheck (
          Violation      => Tviol_S_CB_negedge,
          TimingData     => Tmkr_S_CB_negedge,
          TestSignal     => S_CB_dly,
          TestSignalName => "S",
          TestDelay      => tisd_S_CB,
          RefSignal      => CB_dly,
          RefSignalName  => "CB",
          RefDelay       => ticd_CB,
          SetupHigh      => tsetup_S_CB_posedge_negedge,
          SetupLow       => tsetup_S_CB_negedge_negedge,
          HoldLow        => thold_S_CB_posedge_negedge,
          HoldHigh       => thold_S_CB_negedge_negedge,
          CheckEnabled   => TO_X01(not R_CB_dly) /= '0',
          RefTransition  => 'F',
          HeaderMsg      => "/X_IDDR_2CLK",
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

-- CR 438883 fix
    wait on C_dly, CB_dly, CE_C_dly, CE_CB_dly, D_C_dly, D_CB_dly, GSR_dly, R_dly, R_C_dly, R_CB_dly, S_dly, S_C_dly, S_CB_dly, Q1_zd, Q2_zd;
 
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
         Paths         => (0 => (C_dly'last_event, tpd_C_Q1,TRUE),
                           1 => (CB_dly'last_event,tpd_CB_Q1,TRUE),
                           2 => (S_dly'last_event, tpd_S_Q1, (R_dly /= '1')),
                           3 => (R_dly'last_event, tpd_R_Q1, true)),
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
         Paths         => (0 => (C_dly'last_event, tpd_C_Q2,TRUE),
                           1 => (CB_dly'last_event,tpd_CB_Q1,TRUE),
                           2 => (S_dly'last_event, tpd_S_Q2, (R_dly /= '1')),
                           3 => (R_dly'last_event, tpd_R_Q2, true)),
         Mode          => OnEvent,
         Xon           => Xon,
         MsgOn         => MsgOn,
         MsgSeverity   => WARNING
       );

    wait on Q1_viol, Q2_viol;
  end process prcs_output;


end X_IDDR_2CLK_V;

-------------------------------------------------------------------------------
-- Copyright (c) 1995/2004 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Input and/or Output Fixed or Variable Delay Element
-- /___/   /\     Filename : X_IODELAY.vhd
-- \   \  /  \    Timestamp : Wed Aug 10 16:51:05 PDT 2005
--  \___\/\___\
--
-- Revision:
--    08/10/05 - Initial version.
--    01/11/06 - Changed Equation for CALC_TAPDELAY -- FP
--    03/10/06 - CR 227041 -- Added path delays -- FP
--    06/04/06 - Made the model independent of T pin (except in DELAY_SRC=IO mode) -- FP
--    07/21/06 - CR 234556 fix. Added SIM_DELAY_D to Simprims -- FP
--    01/03/07 - For simprims, the fixed Delay value is taken from the sdf.
--    03/26/07 - CR 436199 HIGH_PERFORMANCE_MODE default change -- FP
--    05/03/07 - CR 438921 SIGNAL_PATTERN addition  -- FP
--    06/11/07 - CR 437230 -- added delay buffer chain
--    08/29/07 - CR 445561 -- Replaced D_IOBDELAY_OFFSET with D_IODELAY_OFFSET
-- End Revision

----- CELL X_IODELAY -----

library IEEE;
use IEEE.STD_LOGIC_1164.all;


library IEEE;
use IEEE.VITAL_Timing.all;

library simprim;
use simprim.Vcomponents.all;
use simprim.VPACKAGE.all;

entity X_IODELAY is

  generic(

      TimingChecksOn : boolean := true;
      InstancePath   : string  := "*";
      Xon            : boolean := true;
      MsgOn          : boolean := true;
      LOC            : string  := "UNPLACED";
      ILEAK_ADJUST	: real := 1.0;
      D_IODELAY_OFFSET	: real := 0.0;
      SIM_DELAY_D	: integer	:= 0;

--  VITAL input Pin path delay variables
      tipd_CE		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_C		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_DATAIN	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_IDATAIN	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_INC		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_ODATAIN	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_RST		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_T		: VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_DATAIN_DATAOUT  : VitalDelayType01 := (0 ps, 0 ps);
      tpd_IDATAIN_DATAOUT : VitalDelayType01 := (0 ps, 0 ps);
      tpd_ODATAIN_DATAOUT : VitalDelayType01 := (0 ps, 0 ps);
      tpd_C_DATAOUT   	  : VitalDelayType01 := (100 ps, 100 ps);
      tpd_T_DATAOUT   	  : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL GSR-to-output path delay variable
      tpd_GSR_DATAOUT : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL tisd & tisd variables
      tisd_CE_C  : VitalDelayType := 0.0 ps;
      tisd_INC_C : VitalDelayType := 0.0 ps;
      tisd_RST_C : VitalDelayType := 0.0 ps;
      tisd_GSR_C : VitalDelayType := 0.0 ps;
      ticd_C     : VitalDelayType := 0.0 ps;

--  VITAL Setup/Hold delay variables
      tsetup_CE_C_posedge_posedge : VitalDelayType := 0 ps;
      tsetup_CE_C_negedge_posedge : VitalDelayType := 0 ps;
      thold_CE_C_posedge_posedge  : VitalDelayType := 0 ps;
      thold_CE_C_negedge_posedge  : VitalDelayType := 0 ps;
      tsetup_DATAIN_C_posedge_posedge  : VitalDelayType := 0 ps;
      tsetup_DATAIN_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_DATAIN_C_posedge_posedge   : VitalDelayType := 0 ps;
      thold_DATAIN_C_negedge_posedge   : VitalDelayType := 0 ps;
      tsetup_IDATAIN_C_posedge_posedge  : VitalDelayType := 0 ps;
      tsetup_IDATAIN_C_negedge_posedge  : VitalDelayType := 0 ps;
      thold_IDATAIN_C_posedge_posedge   : VitalDelayType := 0 ps;
      thold_IDATAIN_C_negedge_posedge   : VitalDelayType := 0 ps;
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

      DELAY_SRC		: string	:= "I";
      HIGH_PERFORMANCE_MODE		: boolean	:= true;
      IDELAY_TYPE	: string	:= "DEFAULT";
      IDELAY_VALUE	: integer	:= 0;
      ODELAY_VALUE	: integer	:= 0;
      REFCLK_FREQUENCY	: real		:= 200.0;
      SIGNAL_PATTERN	: string	:= "DATA"
      );

  port(
      DATAOUT	: out std_ulogic;

      C		: in  std_ulogic;
      CE	: in  std_ulogic;
      DATAIN	: in  std_ulogic;
      IDATAIN	: in  std_ulogic;
      INC	: in  std_ulogic;
      ODATAIN	: in  std_ulogic;
      RST	: in  std_ulogic;
      T		: in  std_ulogic
      );

  attribute VITAL_LEVEL0 of
    X_IODELAY : entity is true;

end X_IODELAY;

architecture X_IODELAY_V OF X_IODELAY is

  attribute VITAL_LEVEL0 of
    X_IODELAY_V : architecture is true;

-----------------------------------------------------------

  constant	MAX_IDELAY_COUNT	: integer := 63;
  constant	MIN_IDELAY_COUNT	: integer := 0;
  constant	MAX_ODELAY_COUNT	: integer := 63;
  constant	MIN_ODELAY_COUNT	: integer := 0;

  constant	MAX_REFCLK_FREQUENCY	: real := 225.0;
  constant	MIN_REFCLK_FREQUENCY	: real := 175.0;


  signal	C_ipd		: std_ulogic := 'X';
  signal	CE_ipd		: std_ulogic := 'X';
  signal	GSR_ipd		: std_ulogic := 'X';
  signal	DATAIN_ipd	: std_ulogic := 'X';
  signal	IDATAIN_ipd	: std_ulogic := 'X';
  signal	INC_ipd		: std_ulogic := 'X';
  signal	ODATAIN_ipd	: std_ulogic := 'X';
  signal	RST_ipd		: std_ulogic := 'X';
  signal	T_ipd		: std_ulogic := 'X';

  signal	C_dly		: std_ulogic := 'X';
  signal	CE_dly		: std_ulogic := 'X';
  signal	GSR_dly		: std_ulogic := '0';
  signal	DATAIN_dly	: std_ulogic := 'X';
  signal	IDATAIN_dly	: std_ulogic := 'X';
  signal	INC_dly		: std_ulogic := 'X';
  signal	ODATAIN_dly	: std_ulogic := 'X';
  signal	RST_dly		: std_ulogic := 'X';
  signal	T_dly		: std_ulogic := 'X';

  signal	IDATAOUT_delayed	: std_ulogic := 'X';
--  signal	IDATAOUT_zd		: std_ulogic := 'X';
--  signal	IDATAOUT_viol		: std_ulogic := 'X';

  signal	ODATAOUT_delayed	: std_ulogic := 'X';
--  signal	ODATAOUT_zd		: std_ulogic := 'X';
--  signal	ODATAOUT_viol		: std_ulogic := 'X';

  signal	DATAOUT_zd		: std_ulogic := 'X';
--  signal	DATAOUT_viol		: std_ulogic := 'X';

  signal	iDelay		: time := 0.0 ps; 
  signal	oDelay		: time := 0.0 ps; 

  signal	data_mux	: std_ulogic := 'X';
  signal	Violation	: std_ulogic := '0';

  signal	OneTapDelay	: time := 0.0 ps; 
  signal	idelay_count	: integer := IDELAY_VALUE;
  signal	odelay_count	: integer := 0;
  signal	tap_out		: std_ulogic := 'X';

  signal   delay_chain_0,  delay_chain_1,  delay_chain_2,  delay_chain_3,
           delay_chain_4,  delay_chain_5,  delay_chain_6,  delay_chain_7,
           delay_chain_8,  delay_chain_9,  delay_chain_10, delay_chain_11,
           delay_chain_12, delay_chain_13, delay_chain_14, delay_chain_15,
           delay_chain_16, delay_chain_17, delay_chain_18, delay_chain_19,
           delay_chain_20, delay_chain_21, delay_chain_22, delay_chain_23,
           delay_chain_24, delay_chain_25, delay_chain_26, delay_chain_27,
           delay_chain_28, delay_chain_29, delay_chain_30, delay_chain_31,
           delay_chain_32, delay_chain_33, delay_chain_34, delay_chain_35,
           delay_chain_36, delay_chain_37, delay_chain_38, delay_chain_39,
           delay_chain_40, delay_chain_41, delay_chain_42, delay_chain_43,
           delay_chain_44, delay_chain_45, delay_chain_46, delay_chain_47,
           delay_chain_48, delay_chain_49, delay_chain_50, delay_chain_51,
           delay_chain_52, delay_chain_53, delay_chain_54, delay_chain_55,
           delay_chain_56, delay_chain_57, delay_chain_58, delay_chain_59,
           delay_chain_60, delay_chain_61, delay_chain_62, delay_chain_63 : std_ulogic;

begin

  ---------------------
  --  INPUT PATH DELAYs
  --------------------

  WireDelay : block
  begin
    VitalWireDelay (C_ipd,		C,		tipd_C);
    VitalWireDelay (CE_ipd,		CE,		tipd_CE);
    VitalWireDelay (GSR_ipd,		GSR,		tipd_GSR);
    VitalWireDelay (DATAIN_ipd,		DATAIN,		tipd_DATAIN);
    VitalWireDelay (IDATAIN_ipd,	IDATAIN,	tipd_IDATAIN);
    VitalWireDelay (INC_ipd,		INC,		tipd_INC);
    VitalWireDelay (ODATAIN_ipd,	ODATAIN,	tipd_ODATAIN);
    VitalWireDelay (RST_ipd,		RST,		tipd_RST);
    VitalWireDelay (T_ipd,		T,		tipd_T);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (C_dly,		C_ipd,		ticd_C);
    VitalSignalDelay (CE_dly,		CE_ipd,		ticd_C);
    VitalSignalDelay (GSR_dly,		GSR_ipd,	tisd_GSR_C);
    VitalSignalDelay (DATAIN_dly,	DATAIN_ipd,	ticd_C);
    VitalSignalDelay (IDATAIN_dly,	IDATAIN_ipd,	ticd_C);
    VitalSignalDelay (INC_dly,		INC_ipd,	ticd_C);
    VitalSignalDelay (ODATAIN_dly,	ODATAIN_ipd,	ticd_C);
    VitalSignalDelay (RST_dly,		RST_ipd,	ticd_C);
    VitalSignalDelay (T_dly,		T_ipd,		ticd_C);
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
  variable idelaytypefixed_var  : boolean := false; 
  variable idelaytypedefault_var : boolean := false; 
  variable CALC_TAPDELAY : real := 0.0;
  begin
     -------- SIGNAL_PATTERN check
     if((SIGNAL_PATTERN /= "CLOCK") and (SIGNAL_PATTERN /= "DATA"))then
         assert false
         report "Attribute Syntax Error: Legal values for SIGNAL_PATTERN are DATA or CLOCK"
         severity Failure;
     end if;

     -------- HIGH_PERFORMANCE_MODE check

     case HIGH_PERFORMANCE_MODE is
       when true | false => null;
       when others =>
          assert false
          report "Attribute Syntax Error: The attribute HIGH_PERFORMANCE_MODE on X_IODELAY must be set to either true or false."
          severity Failure;
     end case;

     -------- IDELAY_TYPE check

     if(IDELAY_TYPE = "FIXED") then
        idelaytypefixed_var := true;
     elsif(IDELAY_TYPE = "VARIABLE") then
        idelaytypefixed_var := false;
     elsif(IDELAY_TYPE = "DEFAULT") then
        idelaytypedefault_var := true;
        idelaytypefixed_var := false;
     else
       GenericValueCheckMessage
       (  HeaderMsg  => " Attribute Syntax Warning ",
          GenericName => " IDELAY_TYPE ",
          EntityName => "/X_IODELAY",
          GenericValue => IDELAY_TYPE,
          Unit => "",
          ExpectedValueMsg => " The Legal values for this attribute are ",
          ExpectedGenericValue => " DEFAULT, FIXED or VARIABLE ",
          TailMsg => "",
          MsgSeverity => failure 
       );
     end if;

     -------- IDELAY_VALUE check

     if((IDELAY_VALUE < MIN_IDELAY_COUNT) or (ODELAY_VALUE > MAX_IDELAY_COUNT)) then 
        GenericValueCheckMessage
        (  HeaderMsg  => " Attribute Syntax Warning ",
           GenericName => " IDELAY_VALUE ",
           EntityName => "/X_IODELAY",
           GenericValue => IDELAY_VALUE,
           Unit => "",
           ExpectedValueMsg => " The Legal values for this attribute are ",
           ExpectedGenericValue => " 0, 1, 2, ..., 62, 63 ",
           TailMsg => "",
           MsgSeverity => failure 
        );
     end if;

     -------- ODELAY_VALUE check

     if((ODELAY_VALUE < MIN_ODELAY_COUNT) or (ODELAY_VALUE > MAX_ODELAY_COUNT)) then 
        GenericValueCheckMessage
        (  HeaderMsg  => " Attribute Syntax Warning ",
           GenericName => " ODELAY_VALUE ",
           EntityName => "/X_IODELAY",
           GenericValue => ODELAY_VALUE,
           Unit => "",
           ExpectedValueMsg => " The Legal values for this attribute are ",
           ExpectedGenericValue => " 0, 1, 2, ..., 62, 63 ",
           TailMsg => "",
           MsgSeverity => failure 
        );
     end if;

     -------- REFCLK_FREQUENCY check

     if((REFCLK_FREQUENCY < MIN_REFCLK_FREQUENCY) or (REFCLK_FREQUENCY > MAX_REFCLK_FREQUENCY)) then 
         assert false
         report "Attribute Syntax Error: Legal values for REFCLK_FREQUENCY are 175.0 to 225.0"
         severity Failure;
     end if;

     odelay_count <= ODELAY_VALUE;
     CALC_TAPDELAY := ((1.0/REFCLK_FREQUENCY) * (1.0/64.0) * ILEAK_ADJUST * 1000000.0) + D_IODELAY_OFFSET ;
     OneTapDelay   <= CALC_TAPDELAY * 1.0 ps; 
     wait;
  end process prcs_init;
--####################################################################
--#####                  CALCULATE iDelay                        #####
--####################################################################
  prcs_calc_idelay:process(C_dly, GSR_dly, RST_dly)
  variable idelay_count_var : integer :=0;
  variable FIRST_TIME   : boolean :=true;
  variable BaseTime_var : time    := 1 ps ;
--  variable CALC_TAPDELAY : real := 0.0;
  begin
     if(IDELAY_TYPE = "VARIABLE") then
       if((GSR_dly = '1') or (FIRST_TIME))then
          idelay_count_var := IDELAY_VALUE; 
--          CALC_TAPDELAY := ((1.0/REFCLK_FREQUENCY) * (1.0/64.0) * ILEAK_ADJUST * 1000000.0) + D_IODELAY_OFFSET ;
--          iDelay        <= real(idelay_count_var) * CALC_TAPDELAY * BaseTime_var; 
          FIRST_TIME   := false;
       elsif(GSR_dly = '0') then
          if(rising_edge(C_dly)) then
             if(RST_dly = '1') then
               idelay_count_var := IDELAY_VALUE; 
             elsif((RST_dly = '0') and (CE_dly = '1')) then
                  if(INC_dly = '1') then
                     if (idelay_count_var < MAX_IDELAY_COUNT) then
                        idelay_count_var := idelay_count_var + 1;
                     else 
                        idelay_count_var := MIN_IDELAY_COUNT;
                     end if;
                  elsif(INC_dly = '0') then
                     if (idelay_count_var > MIN_IDELAY_COUNT) then
                         idelay_count_var := idelay_count_var - 1;
                     else
                         idelay_count_var := MAX_IDELAY_COUNT;
                     end if;
                         
                  end if; -- INC_dly
             end if; -- RST_dly
--             iDelay <= real(idelay_count_var) *  CALC_TAPDELAY * BaseTime_var;
             idelay_count  <= idelay_count_var;
          end if; -- C_dly
       end if; -- GSR_dly

     end if; -- IDELAY_TYPE 
  end process prcs_calc_idelay;
--####################################################################
--#####                      SELECT IDATA_MUX                    #####
--####################################################################
  prcs_data_mux:process(DATAIN_dly, IDATAIN_dly, ODATAIN_dly, T_dly)
  begin
      if(DELAY_SRC = "I") then 
            data_mux <= IDATAIN_dly;
      elsif(DELAY_SRC = "O") then
            data_mux <= ODATAIN_dly;
      elsif(DELAY_SRC = "IO") then
            data_mux <= (IDATAIN_dly and T_dly) or (ODATAIN_dly and (not T_dly));
      elsif(DELAY_SRC = "DATAIN") then
            data_mux <= DATAIN_dly;
      else
         assert false
         report "Attribute Syntax Error : Legal values for DELAY_SRC on X_IODELAY instance are I, O, IO or DATAIN."
         severity Failure;
      end if;
  end process prcs_data_mux;
--####################################################################
--#####                      DELAY BUFFERS                       #####
--####################################################################
delay_chain_0  <= transport data_mux;
delay_chain_1  <= transport delay_chain_0  after OneTapDelay;
delay_chain_2  <= transport delay_chain_1  after OneTapDelay;
delay_chain_3  <= transport delay_chain_2  after OneTapDelay;
delay_chain_4  <= transport delay_chain_3  after OneTapDelay;
delay_chain_5  <= transport delay_chain_4  after OneTapDelay;
delay_chain_6  <= transport delay_chain_5  after OneTapDelay;
delay_chain_7  <= transport delay_chain_6  after OneTapDelay;
delay_chain_8  <= transport delay_chain_7  after OneTapDelay;
delay_chain_9  <= transport delay_chain_8  after OneTapDelay;
delay_chain_10 <= transport delay_chain_9  after OneTapDelay;
delay_chain_11 <= transport delay_chain_10  after OneTapDelay;
delay_chain_12 <= transport delay_chain_11  after OneTapDelay;
delay_chain_13 <= transport delay_chain_12  after OneTapDelay;
delay_chain_14 <= transport delay_chain_13  after OneTapDelay;
delay_chain_15 <= transport delay_chain_14  after OneTapDelay;
delay_chain_16 <= transport delay_chain_15  after OneTapDelay;
delay_chain_17 <= transport delay_chain_16  after OneTapDelay;
delay_chain_18 <= transport delay_chain_17  after OneTapDelay;
delay_chain_19 <= transport delay_chain_18  after OneTapDelay;
delay_chain_20 <= transport delay_chain_19  after OneTapDelay;
delay_chain_21 <= transport delay_chain_20  after OneTapDelay;
delay_chain_22 <= transport delay_chain_21  after OneTapDelay;
delay_chain_23 <= transport delay_chain_22  after OneTapDelay;
delay_chain_24 <= transport delay_chain_23  after OneTapDelay;
delay_chain_25 <= transport delay_chain_24  after OneTapDelay;
delay_chain_26 <= transport delay_chain_25  after OneTapDelay;
delay_chain_27 <= transport delay_chain_26  after OneTapDelay;
delay_chain_28 <= transport delay_chain_27  after OneTapDelay;
delay_chain_29 <= transport delay_chain_28  after OneTapDelay;
delay_chain_30 <= transport delay_chain_29  after OneTapDelay;
delay_chain_31 <= transport delay_chain_30  after OneTapDelay;
delay_chain_32 <= transport delay_chain_31  after OneTapDelay;
delay_chain_33 <= transport delay_chain_32  after OneTapDelay;
delay_chain_34 <= transport delay_chain_33  after OneTapDelay;
delay_chain_35 <= transport delay_chain_34  after OneTapDelay;
delay_chain_36 <= transport delay_chain_35  after OneTapDelay;
delay_chain_37 <= transport delay_chain_36  after OneTapDelay;
delay_chain_38 <= transport delay_chain_37  after OneTapDelay;
delay_chain_39 <= transport delay_chain_38  after OneTapDelay;
delay_chain_40 <= transport delay_chain_39  after OneTapDelay;
delay_chain_41 <= transport delay_chain_40  after OneTapDelay;
delay_chain_42 <= transport delay_chain_41  after OneTapDelay;
delay_chain_43 <= transport delay_chain_42  after OneTapDelay;
delay_chain_44 <= transport delay_chain_43  after OneTapDelay;
delay_chain_45 <= transport delay_chain_44  after OneTapDelay;
delay_chain_46 <= transport delay_chain_45  after OneTapDelay;
delay_chain_47 <= transport delay_chain_46  after OneTapDelay;
delay_chain_48 <= transport delay_chain_47  after OneTapDelay;
delay_chain_49 <= transport delay_chain_48  after OneTapDelay;
delay_chain_50 <= transport delay_chain_49  after OneTapDelay;
delay_chain_51 <= transport delay_chain_50  after OneTapDelay;
delay_chain_52 <= transport delay_chain_51  after OneTapDelay;
delay_chain_53 <= transport delay_chain_52  after OneTapDelay;
delay_chain_54 <= transport delay_chain_53  after OneTapDelay;
delay_chain_55 <= transport delay_chain_54  after OneTapDelay;
delay_chain_56 <= transport delay_chain_55  after OneTapDelay;
delay_chain_57 <= transport delay_chain_56  after OneTapDelay;
delay_chain_58 <= transport delay_chain_57  after OneTapDelay;
delay_chain_59 <= transport delay_chain_58  after OneTapDelay;
delay_chain_60 <= transport delay_chain_59  after OneTapDelay;
delay_chain_61 <= transport delay_chain_60  after OneTapDelay;
delay_chain_62 <= transport delay_chain_61  after OneTapDelay;
delay_chain_63 <= transport delay_chain_62  after OneTapDelay;

--####################################################################
--#####                Assign Tap Delays                         #####
--####################################################################
  prcs_AssignDelays:process
  begin
        if(((DELAY_SRC = "IO") and (T_dly = '1')) or (DELAY_SRC = "I")  or  (DELAY_SRC = "DATAIN")) then
             case idelay_count is
                when 0 =>    tap_out <= delay_chain_0;
                when 1 =>    tap_out <= delay_chain_1;
                when 2 =>    tap_out <= delay_chain_2;
                when 3 =>    tap_out <= delay_chain_3;
                when 4 =>    tap_out <= delay_chain_4;
                when 5 =>    tap_out <= delay_chain_5;
                when 6 =>    tap_out <= delay_chain_6;
                when 7 =>    tap_out <= delay_chain_7;
                when 8 =>    tap_out <= delay_chain_8;
                when 9 =>    tap_out <= delay_chain_9;
                when 10 =>   tap_out <= delay_chain_10;
                when 11 =>   tap_out <= delay_chain_11;
                when 12 =>   tap_out <= delay_chain_12;
                when 13 =>   tap_out <= delay_chain_13;
                when 14 =>   tap_out <= delay_chain_14;
                when 15 =>   tap_out <= delay_chain_15;
                when 16 =>   tap_out <= delay_chain_16;
                when 17 =>   tap_out <= delay_chain_17;
                when 18 =>   tap_out <= delay_chain_18;
                when 19 =>   tap_out <= delay_chain_19;
                when 20 =>   tap_out <= delay_chain_20;
                when 21 =>   tap_out <= delay_chain_21;
                when 22 =>   tap_out <= delay_chain_22;
                when 23 =>   tap_out <= delay_chain_23;
                when 24 =>   tap_out <= delay_chain_24;
                when 25 =>   tap_out <= delay_chain_25;
                when 26 =>   tap_out <= delay_chain_26;
                when 27 =>   tap_out <= delay_chain_27;
                when 28 =>   tap_out <= delay_chain_28;
                when 29 =>   tap_out <= delay_chain_29;
                when 30 =>   tap_out <= delay_chain_30;
                when 31 =>   tap_out <= delay_chain_31;
                when 32 =>   tap_out <= delay_chain_32;
                when 33 =>   tap_out <= delay_chain_33;
                when 34 =>   tap_out <= delay_chain_34;
                when 35 =>   tap_out <= delay_chain_35;
                when 36 =>   tap_out <= delay_chain_36;
                when 37 =>   tap_out <= delay_chain_37;
                when 38 =>   tap_out <= delay_chain_38;
                when 39 =>   tap_out <= delay_chain_39;
                when 40 =>   tap_out <= delay_chain_40;
                when 41 =>   tap_out <= delay_chain_41;
                when 42 =>   tap_out <= delay_chain_42;
                when 43 =>   tap_out <= delay_chain_43;
                when 44 =>   tap_out <= delay_chain_44;
                when 45 =>   tap_out <= delay_chain_45;
                when 46 =>   tap_out <= delay_chain_46;
                when 47 =>   tap_out <= delay_chain_47;
                when 48 =>   tap_out <= delay_chain_48;
                when 49 =>   tap_out <= delay_chain_49;
                when 50 =>   tap_out <= delay_chain_50;
                when 51 =>   tap_out <= delay_chain_51;
                when 52 =>   tap_out <= delay_chain_52;
                when 53 =>   tap_out <= delay_chain_53;
                when 54 =>   tap_out <= delay_chain_54;
                when 55 =>   tap_out <= delay_chain_55;
                when 56 =>   tap_out <= delay_chain_56;
                when 57 =>   tap_out <= delay_chain_57;
                when 58 =>   tap_out <= delay_chain_58;
                when 59 =>   tap_out <= delay_chain_59;
                when 60 =>   tap_out <= delay_chain_60;
                when 61 =>   tap_out <= delay_chain_61;
                when 62 =>   tap_out <= delay_chain_62;
                when 63 =>   tap_out <= delay_chain_63;
                when others =>
                    tap_out <= delay_chain_0;
             end case;
        elsif(((DELAY_SRC = "IO") and (T_dly = '0')) or (DELAY_SRC = "O")) then
             case odelay_count is
                when 0 =>    tap_out <= delay_chain_0;
                when 1 =>    tap_out <= delay_chain_1;
                when 2 =>    tap_out <= delay_chain_2;
                when 3 =>    tap_out <= delay_chain_3;
                when 4 =>    tap_out <= delay_chain_4;
                when 5 =>    tap_out <= delay_chain_5;
                when 6 =>    tap_out <= delay_chain_6;
                when 7 =>    tap_out <= delay_chain_7;
                when 8 =>    tap_out <= delay_chain_8;
                when 9 =>    tap_out <= delay_chain_9;
                when 10 =>   tap_out <= delay_chain_10;
                when 11 =>   tap_out <= delay_chain_11;
                when 12 =>   tap_out <= delay_chain_12;
                when 13 =>   tap_out <= delay_chain_13;
                when 14 =>   tap_out <= delay_chain_14;
                when 15 =>   tap_out <= delay_chain_15;
                when 16 =>   tap_out <= delay_chain_16;
                when 17 =>   tap_out <= delay_chain_17;
                when 18 =>   tap_out <= delay_chain_18;
                when 19 =>   tap_out <= delay_chain_19;
                when 20 =>   tap_out <= delay_chain_20;
                when 21 =>   tap_out <= delay_chain_21;
                when 22 =>   tap_out <= delay_chain_22;
                when 23 =>   tap_out <= delay_chain_23;
                when 24 =>   tap_out <= delay_chain_24;
                when 25 =>   tap_out <= delay_chain_25;
                when 26 =>   tap_out <= delay_chain_26;
                when 27 =>   tap_out <= delay_chain_27;
                when 28 =>   tap_out <= delay_chain_28;
                when 29 =>   tap_out <= delay_chain_29;
                when 30 =>   tap_out <= delay_chain_30;
                when 31 =>   tap_out <= delay_chain_31;
                when 32 =>   tap_out <= delay_chain_32;
                when 33 =>   tap_out <= delay_chain_33;
                when 34 =>   tap_out <= delay_chain_34;
                when 35 =>   tap_out <= delay_chain_35;
                when 36 =>   tap_out <= delay_chain_36;
                when 37 =>   tap_out <= delay_chain_37;
                when 38 =>   tap_out <= delay_chain_38;
                when 39 =>   tap_out <= delay_chain_39;
                when 40 =>   tap_out <= delay_chain_40;
                when 41 =>   tap_out <= delay_chain_41;
                when 42 =>   tap_out <= delay_chain_42;
                when 43 =>   tap_out <= delay_chain_43;
                when 44 =>   tap_out <= delay_chain_44;
                when 45 =>   tap_out <= delay_chain_45;
                when 46 =>   tap_out <= delay_chain_46;
                when 47 =>   tap_out <= delay_chain_47;
                when 48 =>   tap_out <= delay_chain_48;
                when 49 =>   tap_out <= delay_chain_49;
                when 50 =>   tap_out <= delay_chain_50;
                when 51 =>   tap_out <= delay_chain_51;
                when 52 =>   tap_out <= delay_chain_52;
                when 53 =>   tap_out <= delay_chain_53;
                when 54 =>   tap_out <= delay_chain_54;
                when 55 =>   tap_out <= delay_chain_55;
                when 56 =>   tap_out <= delay_chain_56;
                when 57 =>   tap_out <= delay_chain_57;
                when 58 =>   tap_out <= delay_chain_58;
                when 59 =>   tap_out <= delay_chain_59;
                when 60 =>   tap_out <= delay_chain_60;
                when 61 =>   tap_out <= delay_chain_61;
                when 62 =>   tap_out <= delay_chain_62;
                when 63 =>   tap_out <= delay_chain_63;
                when others =>
                    tap_out <= delay_chain_0;
             end case;
        end if;
  wait on  T_dly, idelay_count, odelay_count, delay_chain_0,  delay_chain_1,  delay_chain_2,  delay_chain_3,
           delay_chain_4,  delay_chain_5,  delay_chain_6,  delay_chain_7,
           delay_chain_8,  delay_chain_9,  delay_chain_10, delay_chain_11,
           delay_chain_12, delay_chain_13, delay_chain_14, delay_chain_15,
           delay_chain_16, delay_chain_17, delay_chain_18, delay_chain_19,
           delay_chain_20, delay_chain_21, delay_chain_22, delay_chain_23,
           delay_chain_24, delay_chain_25, delay_chain_26, delay_chain_27,
           delay_chain_28, delay_chain_29, delay_chain_30, delay_chain_31,
           delay_chain_32, delay_chain_33, delay_chain_34, delay_chain_35,
           delay_chain_36, delay_chain_37, delay_chain_38, delay_chain_39,
           delay_chain_40, delay_chain_41, delay_chain_42, delay_chain_43,
           delay_chain_44, delay_chain_45, delay_chain_46, delay_chain_47,
           delay_chain_48, delay_chain_49, delay_chain_50, delay_chain_51,
           delay_chain_52, delay_chain_53, delay_chain_54, delay_chain_55,
           delay_chain_56, delay_chain_57, delay_chain_58, delay_chain_59,
           delay_chain_60, delay_chain_61, delay_chain_62, delay_chain_63;

  end process prcs_AssignDelays;

--####################################################################
--#####                  CALCULATE oDelay                         #####
--####################################################################
  prcs_calc_odelay:process(C_dly, GSR_dly, RST_dly)
  variable odelay_count_var : integer :=0;
  variable FIRST_TIME   : boolean :=true;
  variable BaseTime_var : time    := 1 ps ;
  variable CALC_TAPDELAY : real := 0.0;
  begin
     if((GSR_dly = '1') or (FIRST_TIME))then
        odelay_count_var := ODELAY_VALUE; 
        CALC_TAPDELAY := ((1.0/REFCLK_FREQUENCY) * (1.0/64.0) * ILEAK_ADJUST * 1000000.0) + D_IODELAY_OFFSET ;
        oDelay        <= real(odelay_count_var) * CALC_TAPDELAY * BaseTime_var; 
        FIRST_TIME   := false;
     end if;

  end process prcs_calc_odelay;

--####################################################################
--#####                      OUTPUT  TAP                         #####
--####################################################################
  prcs_tapout:process(tap_out)
  begin
      DATAOUT_zd <= tap_out ;
  end process prcs_tapout;

--####################################################################
--#####                         OUTPUT                           #####
--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_tmngchk:process
  variable   Tviol_CE_C_posedge  : std_ulogic          := '0';
  variable   Tmkr_CE_C_posedge   : VitalTimingDataType := VitalTimingDataInit;
  variable   Tviol_INC_C_posedge : std_ulogic          := '0';
  variable   Tmkr_INC_C_posedge : VitalTimingDataType  := VitalTimingDataInit;
  variable   Tviol_RST_C_posedge : std_ulogic          := '0';
  variable   Tmkr_RST_C_posedge : VitalTimingDataType  := VitalTimingDataInit;
--  variable   Violation           : std_ulogic          := '0';

  begin
--  Setup/Hold Check Violations (all input pins)

     if (TimingChecksOn) then
       VitalSetupHoldCheck
         (
           Violation      => Tviol_CE_C_posedge,
           TimingData     => Tmkr_CE_C_posedge,
           TestSignal     => CE_dly,
           TestSignalName => "CE",
           TestDelay      => tisd_CE_C,
           RefSignal      => C_dly,
           RefSignalName  => "C",
           RefDelay       => ticd_C,
           SetupHigh      => tsetup_CE_C_posedge_posedge,
           SetupLow       => tsetup_CE_C_negedge_posedge,
           HoldLow        => thold_CE_C_posedge_posedge,
           HoldHigh       => thold_CE_C_negedge_posedge,
           CheckEnabled   => (TO_X01(GSR_dly) = '0'),
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_IODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => WARNING
        );

       VitalSetupHoldCheck
         (
           Violation      => Tviol_INC_C_posedge,
           TimingData     => Tmkr_INC_C_posedge,
           TestSignal     => INC_dly,
           TestSignalName => "INC",
           TestDelay      => tisd_INC_C,
           RefSignal      => C_dly,
           RefSignalName  => "C",
           RefDelay       => ticd_C,
           SetupHigh      => tsetup_INC_C_posedge_posedge,
           SetupLow       => tsetup_INC_C_negedge_posedge,
           HoldLow        => thold_INC_C_posedge_posedge,
           HoldHigh       => thold_INC_C_negedge_posedge,
           CheckEnabled   => (TO_X01(GSR_dly) = '0'),
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_IODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => WARNING
        );

       VitalSetupHoldCheck
         (
           Violation      => Tviol_RST_C_posedge,
           TimingData     => Tmkr_RST_C_posedge,
           TestSignal     => RST_dly,
           TestSignalName => "RST",
           TestDelay      => tisd_RST_C,
           RefSignal      => C_dly,
           RefSignalName  => "C",
           RefDelay       => ticd_C,
           SetupHigh      => tsetup_RST_C_posedge_posedge,
           SetupLow       => tsetup_RST_C_negedge_posedge,
           HoldLow        => thold_RST_C_posedge_posedge,
           HoldHigh       => thold_RST_C_negedge_posedge,
           CheckEnabled   => (TO_X01(GSR_dly) = '0'),
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_IODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => WARNING
        );

     end if;


     Violation <=  Tviol_CE_C_posedge xor 
                   Tviol_INC_C_posedge xor
                   Tviol_RST_C_posedge;


     wait on C_dly, GSR_dly, CE_dly, INC_dly, RST_dly;

  end process prcs_tmngchk;
--####################################################################
--#####                           OUTPUT                         #####
--####################################################################
  prcs_output:process
  variable  DATAOUT_GlitchData : VitalGlitchDataType;
  variable  DATAOUT_viol       : std_ulogic;
  
  variable tpd_IN_OUT_var  : VitalDelayType01 := (SIM_DELAY_D * 1.0 ps, SIM_DELAY_D * 1.0 ps);

  begin

        DATAOUT_viol := Violation xor DATAOUT_zd;

        if((IDELAY_TYPE = "VARIABLE") or (IDELAY_TYPE = "variable")) then
          VitalPathDelay01
            (
              OutSignal     => DATAOUT,
              GlitchData    => DATAOUT_GlitchData,
              OutSignalName => "DATAOUT",
              OutTemp       => DATAOUT_viol,
              Paths         => (0 => (DATAOUT_zd'last_event,  tpd_IN_OUT_var,TRUE),
                                1 => (T_dly'last_event, tpd_T_DATAOUT,TRUE)),
              Mode          => VitalTransport,
              Xon           => Xon,
              MsgOn         => MsgOn,
              MsgSeverity   => WARNING
            );
        else
           VitalPathDelay01
             (
               OutSignal     => DATAOUT,
               GlitchData    => DATAOUT_GlitchData,
               OutSignalName => "DATAOUT",
               OutTemp       => DATAOUT_viol,
               Paths         => (0 => (DATAIN_dly'last_event, tpd_DATAIN_DATAOUT,TRUE),
                                 1 => (IDATAIN_dly'last_event, tpd_IDATAIN_DATAOUT,TRUE),
                                 2 => (ODATAIN_dly'last_event, tpd_ODATAIN_DATAOUT,TRUE),
                                 3 => (T_dly'last_event, tpd_T_DATAOUT,TRUE)),
               Mode          => VitalTransport,
               Xon           => Xon,
               MsgOn         => MsgOn,
               MsgSeverity   => WARNING
             );
        end if;
     wait on DATAOUT_zd, T_dly, Violation;
  end process prcs_output;


end X_IODELAY_V;

-------------------------------------------------------------------------------
-- Copyright (c) 2005 Xilinx, Inc.
-- All Right Reserved.
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor : Xilinx
-- \   \   \/     Version : 10.1i
--  \   \         Description : Xilinx Timing Simulation Library Component
--  /   /                  Source Synchronous Input Deserializer without delay element
-- /___/   /\     Filename : X_ISERDES_NODELAY.vhd
-- \   \  /  \    Timestamp : Fri Oct 21 16:11:37 PDT 2005
--  \___\/\___\
--
-- Revision:
--    10/21/05 - Initial version.
--    05/29/06 - CR 232324 -- Added Rec/Rem RST wrt negedge CLKDIV.
--    06/16/06 - Added new port CLKB.
--    07/24/06 - Fixed VCS VITAL compile issues.
--    08/26/06 - CR 422392 -- OFB, TFB ports added. 
--    09/14/06 - CR 423526 -- Removed TFB port. 
--    09/26/06 - Added Async Vitral Path for RST
--    10/13/06 - CR 426606
--    03/02/07 - CR 435001 changed module names to bscntrl_nodelay and ice_module_nodelay
--    08/29/07 - CR 447556 Fixed attribute INTERFACE_TYPE to be case insensitive 
--    09/10/07 - CR 447760 Added Strict DRC for BITSLIP and INTERFACE_TYPE combinations
--    12/03/07 - CR 454107 Added DRC warnings for INTERFACE_TYPE, DATA_RATE and DATA_WIDTH combinations
-- End Revision

----- CELL X_ISERDES_NODELAY -----

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
--////////////////// BSCNTRL_NODELAY /////////////////////////
--//////////////////////////////////////////////////////////// 
entity bscntrl_nodelay is
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
           
end bscntrl_nodelay;

architecture bscntrl_nodelay_V of bscntrl_nodelay is
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
end bscntrl_nodelay_V;

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
--/////////////////// ICE_MODULE_NODELAY /////////////////////
--//////////////////////////////////////////////////////////// 

entity ice_module_nodelay is
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
end ice_module_nodelay;

architecture ice_module_nodelay_V of ice_module_nodelay is
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
end ice_module_nodelay_V;

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

library STD;
use STD.TEXTIO.all;


----- CELL X_ISERDES_NODELAY -----
--//////////////////////////////////////////////////////////// 
--////////////////////////// ISERDES /////////////////////////
--//////////////////////////////////////////////////////////// 

entity X_ISERDES_NODELAY is

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
      tipd_CLKB		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_CLKDIV	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_D		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_DDLY		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_DIN		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_GSR		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_OCLK		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_OFB		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_RST		: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SHIFTIN1	: VitalDelayType01 := (0 ps, 0 ps);
      tipd_SHIFTIN2	: VitalDelayType01 := (0 ps, 0 ps);

--  VITAL clk-to-output path delay variables
      tpd_D_O		: VitalDelayType01 := (0 ps, 0 ps);
      tpd_DDLY_O	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_CLKDIV_Q1	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q2	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q3	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q4	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q5	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_CLKDIV_Q6	: VitalDelayType01 := (100 ps, 100 ps);
      tpd_OFB_O		: VitalDelayType01 := (0 ps, 0 ps);

      tbpd_D_O_CLK      : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_D_O_CLKB     : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_DDLY_O_CLK   : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_DDLY_O_CLKB  : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_OFB_O_CLK      : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_OFB_O_CLKB     : VitalDelayType01 := (0 ps, 0 ps);


--  VITAL async set-to-output path delay variables
      tpd_RST_Q1	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_Q2	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_Q3	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_Q4	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_Q5	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_RST_Q6	: VitalDelayType01 := (0 ps, 0 ps);

      tbpd_RST_Q1_CLKDIV : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_RST_Q2_CLKDIV : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_RST_Q3_CLKDIV : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_RST_Q4_CLKDIV : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_RST_Q5_CLKDIV : VitalDelayType01 := (0 ps, 0 ps);
      tbpd_RST_Q6_CLKDIV : VitalDelayType01 := (0 ps, 0 ps);

--  VITAL GSR-to-output path delay variable
      tpd_GSR_Q1	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q2	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q3	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q4	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q5	: VitalDelayType01 := (0 ps, 0 ps);
      tpd_GSR_Q6	: VitalDelayType01 := (0 ps, 0 ps);


--  VITAL ticd & tisd variables
      ticd_CLK			: VitalDelayType := 0.0 ps;
      ticd_CLKB			: VitalDelayType := 0.0 ps;
      ticd_CLKDIV		: VitalDelayType := 0.0 ps;
      ticd_OCLK			: VitalDelayType := 0.0 ps;

      tisd_BITSLIP_CLKDIV	: VitalDelayType := 0.0 ps;
      tisd_CE1_CLK		: VitalDelayType := 0.0 ps;
      tisd_CE1_CLKB		: VitalDelayType := 0.0 ps;
      tisd_CE2_CLK		: VitalDelayType := 0.0 ps;
      tisd_CE2_CLKB		: VitalDelayType := 0.0 ps;
      tisd_CE1_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_CE2_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_D_CLK		: VitalDelayType := 0.0 ps;
      tisd_D_CLKB		: VitalDelayType := 0.0 ps;
      tisd_DDLY_CLK		: VitalDelayType := 0.0 ps;
      tisd_DDLY_CLKB		: VitalDelayType := 0.0 ps;
      tisd_GSR			: VitalDelayType := 0.0 ps;
      tisd_OFB_CLK		: VitalDelayType := 0.0 ps;
      tisd_OFB_CLKB		: VitalDelayType := 0.0 ps;
      tisd_RST_CLK		: VitalDelayType := 0.0 ps;
      tisd_RST_CLKB		: VitalDelayType := 0.0 ps;
      tisd_RST_CLKDIV		: VitalDelayType := 0.0 ps;
      tisd_RST_OCLK		: VitalDelayType := 0.0 ps;
      tisd_SHIFTIN1		: VitalDelayType := 0.0 ps;
      tisd_SHIFTIN2		: VitalDelayType := 0.0 ps;

--  VITAL Setup/Hold delay variables

     tsetup_D_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_D_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_D_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_D_CLK_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_D_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_D_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_D_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_D_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_DDLY_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_DDLY_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_DDLY_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_DDLY_CLK_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_DDLY_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_DDLY_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_DDLY_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_DDLY_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_OFB_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_OFB_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_OFB_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_OFB_CLK_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_OFB_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_OFB_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_OFB_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_OFB_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;


     tsetup_CE1_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE1_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_CE1_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_CE1_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE1_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLK_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_CE1_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE1_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE1_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_CE2_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE2_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE2_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_CE2_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;

     tsetup_CE2_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE2_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE2_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE2_CLK_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_CE2_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_CE2_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE2_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     thold_CE2_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;

     tsetup_RST_CLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_RST_CLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_RST_CLK_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_RST_CLK_negedge_posedge  : VitalDelayType := 0.0 ps;
     tsetup_RST_CLK_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_RST_CLK_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_RST_CLK_posedge_negedge  : VitalDelayType := 0.0 ps;
     thold_RST_CLK_negedge_negedge  : VitalDelayType := 0.0 ps;

     tsetup_RST_CLKB_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_RST_CLKB_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_RST_CLKB_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_RST_CLKB_negedge_posedge  : VitalDelayType := 0.0 ps;
     tsetup_RST_CLKB_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_RST_CLKB_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_RST_CLKB_posedge_negedge  : VitalDelayType := 0.0 ps;
     thold_RST_CLKB_negedge_negedge  : VitalDelayType := 0.0 ps;

     tsetup_RST_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_RST_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_RST_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_RST_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;
     tsetup_RST_CLKDIV_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_RST_CLKDIV_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_RST_CLKDIV_posedge_negedge  : VitalDelayType := 0.0 ps;
     thold_RST_CLKDIV_negedge_negedge  : VitalDelayType := 0.0 ps;

     tsetup_RST_OCLK_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_RST_OCLK_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_RST_OCLK_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_RST_OCLK_negedge_posedge  : VitalDelayType := 0.0 ps;
     tsetup_RST_OCLK_posedge_negedge : VitalDelayType := 0.0 ps;
     tsetup_RST_OCLK_negedge_negedge : VitalDelayType := 0.0 ps;
     thold_RST_OCLK_posedge_negedge  : VitalDelayType := 0.0 ps;
     thold_RST_OCLK_negedge_negedge  : VitalDelayType := 0.0 ps;

     tsetup_BITSLIP_CLKDIV_posedge_posedge : VitalDelayType := 0.0 ps;
     tsetup_BITSLIP_CLKDIV_negedge_posedge : VitalDelayType := 0.0 ps;
     thold_BITSLIP_CLKDIV_posedge_posedge  : VitalDelayType := 0.0 ps;
     thold_BITSLIP_CLKDIV_negedge_posedge  : VitalDelayType := 0.0 ps;


-- VITAL pulse width variables
      tpw_CLK_posedge	: VitalDelayType := 0 ps;
      tpw_CLK_negedge	: VitalDelayType := 0 ps;
      tpw_CLKDIV_posedge: VitalDelayType := 0 ps;
      tpw_CLKDIV_negedge: VitalDelayType := 0 ps;
      tpw_OCLK_posedge	: VitalDelayType := 0 ps;
      tpw_OCLK_negedge	: VitalDelayType := 0 ps;
      tpw_GSR_posedge	: VitalDelayType := 0 ps;
      tpw_RST_posedge	: VitalDelayType := 0 ps;

-- VITAL period variables
      tperiod_CLK_posedge	: VitalDelayType := 0 ps;

-- VITAL recovery time variables
      trecovery_GSR_CLK_negedge_posedge    : VitalDelayType := 0 ps;
      trecovery_RST_CLK_negedge_posedge    : VitalDelayType := 0 ps;
      trecovery_RST_CLKB_negedge_posedge   : VitalDelayType := 0 ps;
      trecovery_RST_CLKDIV_negedge_posedge : VitalDelayType := 0 ps;
      trecovery_RST_OCLK_negedge_posedge   : VitalDelayType := 0 ps;

-- VITAL removal time variables
      tremoval_GSR_CLK_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_RST_CLK_negedge_posedge    : VitalDelayType := 0 ps;
      tremoval_RST_CLKB_negedge_posedge   : VitalDelayType := 0 ps;
      tremoval_RST_CLKDIV_negedge_posedge : VitalDelayType := 0 ps;
      tremoval_RST_OCLK_negedge_posedge   : VitalDelayType := 0 ps;


      BITSLIP_ENABLE	: boolean	:= false;
      DATA_RATE		: string	:= "DDR";
      DATA_WIDTH	: integer	:= 4;
      INIT_Q1		: bit		:= '0';
      INIT_Q2		: bit		:= '0';
      INIT_Q3		: bit		:= '0';
      INIT_Q4		: bit		:= '0';
      INTERFACE_TYPE	: string	:= "MEMORY";
      IOBDELAY		: string	:= "NONE";
      NUM_CE		: integer	:= 2;
      OFB_USED		: boolean	:= false;
      SERDES_MODE	: string	:= "MASTER"
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
      CLKB		: in std_ulogic;
      CLKDIV		: in std_ulogic;
      D			: in std_ulogic;
      DDLY		: in std_ulogic;
      OCLK		: in std_ulogic;
      OFB		: in std_ulogic;
      RST		: in std_ulogic;
      SHIFTIN1		: in std_ulogic;
      SHIFTIN2		: in std_ulogic
    );

  attribute VITAL_LEVEL0 of
    X_ISERDES_NODELAY : entity is true;

end X_ISERDES_NODELAY;

architecture X_ISERDES_NODELAY_V OF X_ISERDES_NODELAY is

--  attribute VITAL_LEVEL0 of
--    X_ISERDES_NODELAY_V : architecture is true;

component bscntrl_nodelay
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

component ice_module_nodelay
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

  constant SRVAL_Q1             : bit := '0';
  constant SRVAL_Q2             : bit := '0';
  constant SRVAL_Q3             : bit := '0';
  constant SRVAL_Q4             : bit := '0';

  constant DDR_CLK_EDGE         : string        := "SAME_EDGE_PIPELINED";
  constant INIT_BITSLIPCNT      : bit_vector(3 downto 0) := "0000";
  constant INIT_CE              : bit_vector(1 downto 0) := "00";
  constant INIT_RANK1_PARTIAL   : bit_vector(4 downto 0) := "00000";
  constant INIT_RANK2           : bit_vector(5 downto 0) := "000000";
  constant INIT_RANK3           : bit_vector(5 downto 0) := "000000";
  constant SERDES               : boolean       := TRUE;
  constant SRTYPE               : string        := "ASYNC";

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
  signal CLKB_ipd	        : std_ulogic := 'X';
  signal CLKDIV_ipd		: std_ulogic := 'X';
  signal D_ipd			: std_ulogic := 'X';
  signal DDLY_ipd		: std_ulogic := 'X';
  signal GSR_ipd		: std_ulogic := 'X';
  signal OCLK_ipd		: std_ulogic := 'X';
  signal OFB_ipd		: std_ulogic := 'X';
  signal RST_ipd		: std_ulogic := 'X';
  signal SHIFTIN1_ipd		: std_ulogic := 'X';
  signal SHIFTIN2_ipd		: std_ulogic := 'X';
  signal TFB_ipd		: std_ulogic := '0';

  signal BITSLIP_dly	        : std_ulogic := 'X';
  signal CE1_dly	        : std_ulogic := 'X';
  signal CE2_dly	        : std_ulogic := 'X';
  signal CLK_dly	        : std_ulogic := 'X';
  signal CLKB_dly	        : std_ulogic := 'X';
  signal CLKDIV_dly		: std_ulogic := 'X';
  signal D_CLK_dly		: std_ulogic := 'X';
  signal D_CLKB_dly		: std_ulogic := 'X';
  signal DDLY_CLK_dly		: std_ulogic := 'X';
  signal DDLY_CLKB_dly		: std_ulogic := 'X';
  signal GSR_dly		: std_ulogic := 'X';
  signal OCLK_dly		: std_ulogic := 'X';
  signal OFB_CLK_dly		: std_ulogic := 'X';
  signal OFB_CLKB_dly		: std_ulogic := 'X';
  signal REV_dly		: std_ulogic := '0';
  signal RST_dly		: std_ulogic := 'X';
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
  signal AttrOFB_USED		: std_ulogic := '0';
  signal AttrTFB_USED		: std_ulogic := '0';

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
  signal datain_CLK		: std_ulogic := 'X';
  signal datain_CLKB		: std_ulogic := 'X';
  signal idelay_out		: std_ulogic := 'X';

  signal CLKN_dly		: std_ulogic := '0';

  signal pre_fdbk_O_zd		: std_ulogic := 'X';
  signal pre_fdbk_datain_CLK	: std_ulogic := 'X';
  signal pre_fdbk_datain_CLKB	: std_ulogic := 'X';
  signal feedback	        : std_logic_vector(2 downto 0) := (others => 'X');


procedure CR454107_msg(INTERFACE_TYPE : IN string;
                         DATA_RATE  : IN string;
                         DATA_WIDTH : IN integer) is

  variable Message : line;
  begin
        Write (Message, string'("DRC  Warning : The combination of INTERFACE_TYPE, DATA_RATE and DATA_WIDTH values on X_ISERDES_NODELAY component is not recommended."));
        Write (Message, LF);
        Write (Message, string'("The current settings are: INTERFACE_TYPE = "));
        Write (Message, INTERFACE_TYPE);
        Write (Message, string'(", DATA_RATE = "));
        Write (Message, DATA_RATE );
        Write (Message, string'(" and DATA_WIDTH = "));
        Write (Message, DATA_WIDTH );
        Write (Message, LF);
        Write (Message, string'("The recommended combinations of values are :"));
        Write (Message, LF);
        Write (Message, string'("NETWORKING SDR 2, 3, 4, 5, 6, 7, 8"));
        Write (Message, LF);
        Write (Message, string'("NETWORKING DDR 4, 6, 8, 10"));
        Write (Message, LF);
        Write (Message, string'("MEMORY SDR None"));
        Write (Message, LF);
        Write (Message, string'("MEMORY DDR 4"));
        assert false report Message.all severity Warning;
        DEALLOCATE (Message);
   end CR454107_msg;

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
    VitalWireDelay (CLKB_ipd,     CLKB,      tipd_CLKB);
    VitalWireDelay (CLKDIV_ipd,   CLKDIV,   tipd_CLKDIV);
    VitalWireDelay (D_ipd,        D,        tipd_D);
    VitalWireDelay (DDLY_ipd,     DDLY,     tipd_DDLY);
    VitalWireDelay (GSR_ipd,      GSR,      tipd_GSR);
    VitalWireDelay (OCLK_ipd,     OCLK,     tipd_OCLK);
    VitalWireDelay (OFB_ipd,      OFB,      tipd_OFB);
    VitalWireDelay (RST_ipd,      RST,      tipd_RST);
    VitalWireDelay (SHIFTIN1_ipd, SHIFTIN1, tipd_SHIFTIN1);
    VitalWireDelay (SHIFTIN2_ipd, SHIFTIN2, tipd_SHIFTIN2);
  end block;

  SignalDelay : block
  begin
    VitalSignalDelay (BITSLIP_dly,  BITSLIP_ipd,  tisd_BITSLIP_CLKDIV);
    VitalSignalDelay (CE1_dly,      CE1_ipd,      tisd_CE1_CLKDIV);
    VitalSignalDelay (CE2_dly,      CE2_ipd,      tisd_CE2_CLKDIV);
    VitalSignalDelay (CLK_dly,      CLK_ipd,      ticd_CLK);
    VitalSignalDelay (CLKB_dly,     CLKB_ipd,     ticd_CLKB);
    VitalSignalDelay (CLKDIV_dly,   CLKDIV_ipd,   ticd_CLKDIV);
    VitalSignalDelay (D_CLK_dly,    D_ipd,        tisd_D_CLK);
    VitalSignalDelay (D_CLKB_dly,   D_ipd,        tisd_D_CLKB);
    VitalSignalDelay (DDLY_CLK_dly,   DDLY_ipd,   tisd_DDLY_CLK);
    VitalSignalDelay (DDLY_CLKB_dly,  DDLY_ipd,   tisd_DDLY_CLKB);
    VitalSignalDelay (GSR_dly,      GSR_ipd,      tisd_GSR);
    VitalSignalDelay (OCLK_dly,     OCLK_ipd,     ticd_OCLK);
    VitalSignalDelay (OFB_CLK_dly,  OFB_ipd,      tisd_OFB_CLK);
    VitalSignalDelay (OFB_CLKB_dly, OFB_ipd,      tisd_OFB_CLKB);
    VitalSignalDelay (RST_dly,      RST_ipd,      tisd_RST_CLKDIV);
    VitalSignalDelay (SHIFTIN1_dly, SHIFTIN1_ipd, tisd_SHIFTIN1);
    VitalSignalDelay (SHIFTIN2_dly, SHIFTIN2_ipd, tisd_SHIFTIN2);
  end block;

  --------------------
  --  BEHAVIOR SECTION
  --------------------


  SR_dly <= RST_dly;

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
  variable AttrOFB_USED_var		: std_ulogic := 'X';
  variable AttrTFB_USED_var		: std_ulogic := 'X';

  begin

      --------CR 454107  DRC Warning -- INTERFACE_TYPE / DATA_RATE /  DATA_WIDTH combinations  ------------------
      if (INTERFACE_TYPE = "NETWORKING") then
         if(DATA_RATE = "SDR")then
            case (DATA_WIDTH) is
                when 2|3|4|5|6|7|8  => null;
                when others       => CR454107_msg(INTERFACE_TYPE, DATA_RATE, DATA_WIDTH);
            end case;
         elsif(DATA_RATE = "DDR")then
            case (DATA_WIDTH) is
                when 4|6|8|10 => null;
                when others       => CR454107_msg(INTERFACE_TYPE, DATA_RATE, DATA_WIDTH);
            end case;
         end if;
      elsif (INTERFACE_TYPE = "MEMORY") then
         if(DATA_RATE = "DDR")then
            case (DATA_WIDTH) is
                when 4  => null;
                when others       => CR454107_msg(INTERFACE_TYPE, DATA_RATE, DATA_WIDTH);
            end case;
         elsif(DATA_RATE = "SDR")then
                CR454107_msg(INTERFACE_TYPE, DATA_RATE, DATA_WIDTH);
         end if;
      end if;


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
             EntityName => "/X_ISERDES_NODELAY",
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
             EntityName => "/X_ISERDES_NODELAY",
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
             EntityName => "/X_ISERDES_NODELAY",
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
                   EntityName => "/X_ISERDES_NODELAY",
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
                   EntityName => "/X_ISERDES_NODELAY",
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
             EntityName => "/X_ISERDES_NODELAY",
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
             EntityName => "/X_ISERDES_NODELAY",
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
                     EntityName => "/X_ISERDES_NODELAY",
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
             EntityName => "/X_ISERDES_NODELAY",
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
         AttrDdrClkEdge_var := "00";

--      if((DDR_CLK_EDGE = "SAME_EDGE_PIPELINED") or (DDR_CLK_EDGE = "same_edge_pipelined")) then
--         AttrDdrClkEdge_var := "00";
--      elsif((DDR_CLK_EDGE = "SAME_EDGE") or (DDR_CLK_EDGE = "same_edge")) then
--         AttrDdrClkEdge_var := "01";
--      elsif((DDR_CLK_EDGE = "OPPOSITE_EDGE") or (DDR_CLK_EDGE = "opposite_edge")) then
--         AttrDdrClkEdge_var := "10";
--      else
--        GenericValueCheckMessage
--          (  HeaderMsg  => " Attribute Syntax Warning ",
--             GenericName => " DDR_CLK_EDGE ",
--             EntityName => "/X_ISERDES_NODELAY",
--             GenericValue => DDR_CLK_EDGE,
--            Unit => "",
--             ExpectedValueMsg => " The Legal values for this attribute are ",
--             ExpectedGenericValue => " SAME_EDGE_PIPELINED or SAME_EDGE or OPPOSITE_EDGE ",
--             TailMsg => "",
--             MsgSeverity => Failure
--         );
--      end if;
      ------------------ DATA_RATE validity check ------------------
         AttrSrtype <= 0;

--      if((SRTYPE = "ASYNC") or (SRTYPE = "async")) then
--         AttrSrtype <= 0;
--      elsif((SRTYPE = "SYNC") or (SRTYPE = "sync")) then
--         AttrSrtype <= 1;
--      else
--        GenericValueCheckMessage
--          (  HeaderMsg  => " Attribute Syntax Warning ",
--             GenericName => " SRTYPE ",
--             EntityName => "/X_ISERDES_NODELAY",
--             GenericValue => SRTYPE,
--             Unit => "",
--             ExpectedValueMsg => " The Legal values for this attribute are ",
--             ExpectedGenericValue => " ASYNC or SYNC. ",
--             TailMsg => "",
--             MsgSeverity => ERROR
--         );
--      end if;
      ---------------- OFB_USED validity check -------------------
      if(OFB_USED = false) then
         AttrOFB_USED_var := '0';
      elsif(OFB_USED = true) then
         AttrOFB_USED_var := '1';
      else
        GenericValueCheckMessage
          (  HeaderMsg  => " Attribute Syntax Warning ",
             GenericName => " OFB_USED ",
             EntityName => "/X_ISERDES_NODELAY",
             GenericValue => OFB_USED,
             Unit => "",
             ExpectedValueMsg => " The Legal values for this attribute are ",
             ExpectedGenericValue => " TRUE or FALSE ",
             TailMsg => "",
             MsgSeverity => Failure
         );
      end if;

      ---------------- TFB_USED validity check -------------------
--      if(TFB_USED = false) then
--         AttrTFB_USED_var := '0';
--      elsif(TFB_USED = true) then
--         AttrTFB_USED_var := '1';
--      else
--        GenericValueCheckMessage
--          (  HeaderMsg  => " Attribute Syntax Warning ",
--             GenericName => " TFB_USED ",
--             EntityName => "/X_ISERDES_NODELAY",
--             GenericValue => TFB_USED,
--             Unit => "",
--             ExpectedValueMsg => " The Legal values for this attribute are ",
--             ExpectedGenericValue => " TRUE or FALSE ",
--             TailMsg => "",
--             MsgSeverity => Failure
--         );
--      end if;

---------------------------------------------------------------------

     AttrSerdes		<= AttrSerdes_var;
     AttrMode		<= AttrMode_var;
     AttrDataRate	<= AttrDataRate_var;
     AttrDataWidth	<= AttrDataWidth_var;
     AttrInterfaceType	<= AttrInterfaceType_var;
     AttrBitslipEnable	<= AttrBitslipEnable_var;
     AttrDdrClkEdge	<= AttrDdrClkEdge_var;
     AttrIobDelay	<= AttrIobDelay_var;
     AttrOFB_USED	<= AttrOFB_USED_var;

     sel1     <= AttrMode_var & AttrDataRate_var; 
     selrnk3  <= AttrSerdes_var & AttrBitslipEnable_var & AttrDdrClkEdge_var; 
     cntr     <= AttrDataRate_var & AttrDataWidth_var;

     wait;
  end process prcs_init;

  feedback <= TFB_ipd & AttrOFB_USED & AttrTFB_USED;
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
                            q1rnk1_var := datain_CLK;
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
                            q1rnk1_var := datain_CLK;
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
  prcs_Q2_rnk1:process(CLKB_dly, GSR_dly, SR_dly, REV_dly)
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
                         if(rising_edge(CLKB_dly)) then
                            q2nrnk1_var     := datain_CLKB;
                         end if;
                      end if;
                   end if;

           when 1 => 
           --------------- // sync SET/RESET
                   if(rising_edge(CLKB_dly)) then
                      if((SR_dly = '1') and (not ((REV_dly = '1') and (TO_X01(SRVAL_Q2) = '1')))) then
                         q2nrnk1_var  := TO_X01(SRVAL_Q2);
                      elsif(REV_dly = '1') then
                         q2nrnk1_var  := not TO_X01(SRVAL_Q2);
                      elsif((SR_dly = '0') and (REV_dly = '0')) then
                         if(ice = '1') then
                            q2nrnk1_var := datain_CLKB;
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
-----------    Instant BSCNTRL_NODELAY  ------------------------------
----------------------------------------------------------------------
  INST_BSCNTRL_NODELAY : BSCNTRL_NODELAY
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
--#####   Set value of the counter in BSCNTRL_NODELAY           ##### 
--###################################################################
  prcs_bscntrl_nodelay_cntr:process
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

  end process prcs_bscntrl_nodelay_cntr;
         
----------------------------------------------------------------------
-----------    Instant Clock Enable Circuit  ------------------------- 
----------------------------------------------------------------------
  INST_ICE : ICE_MODULE_NODELAY 
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
--  INST_IDELAY : X_IDELAY 
--  generic map (
--      IOBDELAY_VALUE => IOBDELAY_VALUE,
--      IOBDELAY_TYPE  => IOBDELAY_TYPE,
--      SIM_TAPDELAY_VALUE => SIM_TAPDELAY_VALUE
--     )
--  port map (
--      O		=> idelay_out,
--
--      C		=> CLKDIV_dly,
--      CE	=> DLYCE_dly,
--      I		=> D_dly,
--      INC	=> DLYINC_dly,
--      RST	=> DLYRST_dly
--      );

--###################################################################
--#####           IOBDELAY -- Delay input Data                  ##### 
--###################################################################
  prcs_pre_fdbk_d_delay:process(D_ipd, DDLY_ipd, D_CLK_dly, D_CLKB_dly, DDLY_CLK_dly, DDLY_CLKB_dly)
  begin
     case AttrIobDelay is
        when 0 =>
               pre_fdbk_O_zd        <= D_ipd;
               pre_fdbk_datain_CLK  <= D_CLK_dly;
               pre_fdbk_datain_CLKB <= D_CLKB_dly;
        when 1 =>
               pre_fdbk_O_zd   <= DDLY_ipd; 
               pre_fdbk_datain_CLK  <= D_CLK_dly;
               pre_fdbk_datain_CLKB <= D_CLKB_dly;
        when 2 =>
               pre_fdbk_O_zd   <= D_ipd; 
               pre_fdbk_datain_CLK  <= DDLY_CLK_dly;
               pre_fdbk_datain_CLKB <= DDLY_CLKB_dly;
        when 3 =>
               pre_fdbk_O_zd   <= DDLY_ipd; 
               pre_fdbk_datain_CLK  <= DDLY_CLK_dly;
               pre_fdbk_datain_CLKB <= DDLY_CLKB_dly;
        when others =>
               null;
     end case;
  end process prcs_pre_fdbk_d_delay;

--CR 422392 
--###################################################################
--#####           Muxing of D, OFB and TFB  -- FEEDBACK         ##### 
--###################################################################
  prcs_d_delay:process(pre_fdbk_O_zd, pre_fdbk_datain_CLK, pre_fdbk_datain_CLKB, feedback )
  begin
     case feedback is
        when "000" | "100" | "X00" =>
                 O_zd        <= pre_fdbk_O_zd;
                 datain_CLK  <= pre_fdbk_datain_CLK;
                 datain_CLKB <= pre_fdbk_datain_CLKB;
        when "001" | "101" | "X01" =>
                 O_zd        <= pre_fdbk_O_zd;
                 datain_CLK  <= pre_fdbk_datain_CLK;
                 datain_CLKB <= pre_fdbk_datain_CLKB;
        when "010"  =>
                 O_zd        <= OFB_ipd;
                 datain_CLK  <= OFB_CLK_dly;
                 datain_CLKB <= OFB_CLKB_dly;
        when "110"  =>
                 O_zd        <= pre_fdbk_O_zd;
                 datain_CLK  <= pre_fdbk_datain_CLK;
                 datain_CLKB <= pre_fdbk_datain_CLKB;
        when "011" | "111" | "X11" =>
                 O_zd        <= OFB_ipd;
                 datain_CLK  <= OFB_CLK_dly;
                 datain_CLKB <= OFB_CLKB_dly;
        when others =>
                 O_zd        <= pre_fdbk_O_zd;
                 datain_CLK  <= pre_fdbk_datain_CLK;
                 datain_CLKB <= pre_fdbk_datain_CLKB;
     end case;
  end process prcs_d_delay;

--####################################################################

--####################################################################
--#####                   TIMING CHECKS & OUTPUT                 #####
--####################################################################
  prcs_output:process

--  Pin Timing Violations (all input pins)
     variable Tviol_D_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_D_CLKB_posedge : STD_ULOGIC := '0';
     variable  Tmkr_D_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DDLY_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DDLY_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_DDLY_CLKB_posedge : STD_ULOGIC := '0';
     variable  Tmkr_DDLY_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_OFB_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_OFB_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_OFB_CLKB_posedge : STD_ULOGIC := '0';
     variable  Tmkr_OFB_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE1_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE1_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE1_CLKB_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE1_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE1_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE1_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE2_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE2_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE2_CLKB_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE2_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_CE2_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_CE2_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_CLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_CLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_CLK_negedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_CLK_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_CLKB_posedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_CLKB_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_CLKB_negedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_CLKB_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_CLKDIV_negedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_CLKDIV_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_OCLK_posedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_OCLK_posedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_RST_OCLK_negedge : STD_ULOGIC := '0';
     variable  Tmkr_RST_OCLK_negedge : VitalTimingDataType := VitalTimingDataInit;
     variable Tviol_BITSLIP_CLKDIV_posedge : STD_ULOGIC := '0';
     variable  Tmkr_BITSLIP_CLKDIV_posedge : VitalTimingDataType := VitalTimingDataInit;

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
--------------------------------------------------------
--   D  Setup/Hold 
--------------------------------------------------------
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D_CLK_posedge,
         TimingData     => Tmkr_D_CLK_posedge,
         TestSignal     => D_CLK_dly,
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
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_D_CLKB_posedge,
         TimingData     => Tmkr_D_CLKB_posedge,
         TestSignal     => D_CLKB_dly,
         TestSignalName => "D",
         TestDelay      => tisd_D_CLKB,
         RefSignal      => CLKB_dly,
         RefSignalName  => "CLKB",
         RefDelay       => ticd_CLKB,
         SetupHigh      => tsetup_D_CLKB_posedge_posedge,
         SetupLow       => tsetup_D_CLKB_negedge_posedge,
         HoldLow        => thold_D_CLKB_posedge_posedge,
         HoldHigh       => thold_D_CLKB_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
--------------------------------------------------------
--   DDLY  Setup/Hold 
--------------------------------------------------------
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DDLY_CLK_posedge,
         TimingData     => Tmkr_DDLY_CLK_posedge,
         TestSignal     => DDLY_CLK_dly,
         TestSignalName => "DDLY",
         TestDelay      => tisd_DDLY_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_DDLY_CLK_posedge_posedge,
         SetupLow       => tsetup_DDLY_CLK_negedge_posedge,
         HoldLow        => thold_DDLY_CLK_posedge_posedge,
         HoldHigh       => thold_DDLY_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_DDLY_CLKB_posedge,
         TimingData     => Tmkr_DDLY_CLKB_posedge,
         TestSignal     => DDLY_CLKB_dly,
         TestSignalName => "DDLY",
         TestDelay      => tisd_DDLY_CLKB,
         RefSignal      => CLKB_dly,
         RefSignalName  => "CLKB",
         RefDelay       => ticd_CLKB,
         SetupHigh      => tsetup_DDLY_CLKB_posedge_posedge,
         SetupLow       => tsetup_DDLY_CLKB_negedge_posedge,
         HoldLow        => thold_DDLY_CLKB_posedge_posedge,
         HoldHigh       => thold_DDLY_CLKB_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
--------------------------------------------------------
--   OFB  Setup/Hold 
--------------------------------------------------------
     VitalSetupHoldCheck
       (
         Violation      => Tviol_OFB_CLK_posedge,
         TimingData     => Tmkr_OFB_CLK_posedge,
         TestSignal     => OFB_CLK_dly,
         TestSignalName => "OFB",
         TestDelay      => tisd_OFB_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_OFB_CLK_posedge_posedge,
         SetupLow       => tsetup_OFB_CLK_negedge_posedge,
         HoldLow        => thold_OFB_CLK_posedge_posedge,
         HoldHigh       => thold_OFB_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_OFB_CLKB_posedge,
         TimingData     => Tmkr_OFB_CLKB_posedge,
         TestSignal     => OFB_CLKB_dly,
         TestSignalName => "OFB",
         TestDelay      => tisd_OFB_CLKB,
         RefSignal      => CLKB_dly,
         RefSignalName  => "CLKB",
         RefDelay       => ticd_CLKB,
         SetupHigh      => tsetup_OFB_CLKB_posedge_posedge,
         SetupLow       => tsetup_OFB_CLKB_negedge_posedge,
         HoldLow        => thold_OFB_CLKB_posedge_posedge,
         HoldHigh       => thold_OFB_CLKB_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
--------------------------------------------------------
--   CE1  Setup/Hold 
--------------------------------------------------------
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
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE1_CLKB_posedge,
         TimingData     => Tmkr_CE1_CLKB_posedge,
         TestSignal     => CE1_dly,
         TestSignalName => "CE1",
         TestDelay      => tisd_CE1_CLKB,
         RefSignal      => CLKB_dly,
         RefSignalName  => "CLKB",
         RefDelay       => ticd_CLKB,
         SetupHigh      => tsetup_CE1_CLKB_posedge_posedge,
         SetupLow       => tsetup_CE1_CLKB_negedge_posedge,
         HoldLow        => thold_CE1_CLKB_posedge_posedge,
         HoldHigh       => thold_CE1_CLKB_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
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
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
--------------------------------------------------------
--   CE2  Setup/Hold 
--------------------------------------------------------
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE2_CLK_posedge,
         TimingData     => Tmkr_CE2_CLK_posedge,
         TestSignal     => CE2_dly,
         TestSignalName => "CE2",
         TestDelay      => tisd_CE2_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_CE2_CLK_posedge_posedge,
         SetupLow       => tsetup_CE2_CLK_negedge_posedge,
         HoldLow        => thold_CE2_CLK_posedge_posedge,
         HoldHigh       => thold_CE2_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE2_CLKB_posedge,
         TimingData     => Tmkr_CE2_CLKB_posedge,
         TestSignal     => CE2_dly,
         TestSignalName => "CE2",
         TestDelay      => tisd_CE2_CLKB,
         RefSignal      => CLKB_dly,
         RefSignalName  => "CLKB",
         RefDelay       => ticd_CLKB,
         SetupHigh      => tsetup_CE2_CLKB_posedge_posedge,
         SetupLow       => tsetup_CE2_CLKB_negedge_posedge,
         HoldLow        => thold_CE2_CLKB_posedge_posedge,
         HoldHigh       => thold_CE2_CLKB_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
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
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
       );
--------------------------------------------------------
--   RST Recovery/Removal 
--------------------------------------------------------
     if(SRTYPE = "ASYNC") then
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_RST_CLK_posedge,
           TimingData           => Tmkr_RST_CLK_posedge,
           TestSignal           => RST_dly,
           TestSignalName       => "RST",
           TestDelay            => 0 ps,
           RefSignal            => CLK_dly,
           RefSignalName        => "CLK",
           RefDelay             => 0 ps,
           Recovery             => trecovery_RST_CLK_negedge_posedge,
           Removal              => tremoval_RST_CLK_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => True,
           RefTransition        => 'R',
           HeaderMsg            => "/X_ISERDES_NODELAY",
           Xon                  => Xon,
           MsgOn                => MsgOn,
           MsgSeverity          => Warning
        );
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_RST_CLKB_posedge,
           TimingData           => Tmkr_RST_CLKB_posedge,
           TestSignal           => RST_dly,
           TestSignalName       => "RST",
           TestDelay            => 0 ps,
           RefSignal            => CLKB_dly,
           RefSignalName        => "CLKB",
           RefDelay             => 0 ps,
           Recovery             => trecovery_RST_CLKB_negedge_posedge,
           Removal              => tremoval_RST_CLKB_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => True,
           RefTransition        => 'R',
           HeaderMsg            => "/X_ISERDES_NODELAY",
           Xon                  => Xon,
           MsgOn                => MsgOn,
           MsgSeverity          => Warning
        );
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_RST_CLKDIV_posedge,
           TimingData           => Tmkr_RST_CLKDIV_posedge,
           TestSignal           => RST_dly,
           TestSignalName       => "RST",
           TestDelay            => 0 ps,
           RefSignal            => CLKDIV_dly,
           RefSignalName        => "CLKDIV",
           RefDelay             => 0 ps,
           Recovery             => trecovery_RST_CLKDIV_negedge_posedge,
           Removal              => tremoval_RST_CLKDIV_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => True,
           RefTransition        => 'R',
           HeaderMsg            => "/X_ISERDES_NODELAY",
           Xon                  => Xon,
           MsgOn                => MsgOn,
           MsgSeverity          => Warning
        );
        VitalRecoveryRemovalCheck (
           Violation            => Tviol_RST_OCLK_posedge,
           TimingData           => Tmkr_RST_OCLK_posedge,
           TestSignal           => RST_dly,
           TestSignalName       => "RST",
           TestDelay            => 0 ps,
           RefSignal            => OCLK_dly,
           RefSignalName        => "OCLK",
           RefDelay             => 0 ps,
           Recovery             => trecovery_RST_OCLK_negedge_posedge,
           Removal              => tremoval_RST_OCLK_negedge_posedge,
           ActiveLow            => false,
           CheckEnabled         => True,
           RefTransition        => 'R',
           HeaderMsg            => "/X_ISERDES_NODELAY",
           Xon                  => Xon,
           MsgOn                => MsgOn,
           MsgSeverity          => Warning
        );
     else
        VitalSetupHoldCheck (
           Violation      => Tviol_RST_CLK_posedge,
           TimingData     => Tmkr_RST_CLK_posedge,
           TestSignal     => RST_dly,
           TestSignalName => "RST",
           TestDelay      => tisd_RST_CLK,
           RefSignal      => CLK_dly,
           RefSignalName  => "CLK",
           RefDelay       => ticd_CLK,
           SetupHigh      => tsetup_RST_CLK_posedge_posedge,
           SetupLow       => tsetup_RST_CLK_negedge_posedge,
           HoldLow        => thold_RST_CLK_posedge_posedge,
           HoldHigh       => thold_RST_CLK_negedge_posedge,
           CheckEnabled   => TRUE,
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => Warning
        );
        VitalSetupHoldCheck (
           Violation      => Tviol_RST_CLKB_posedge,
           TimingData     => Tmkr_RST_CLKB_posedge,
           TestSignal     => RST_dly,
           TestSignalName => "RST",
           TestDelay      => tisd_RST_CLK,
           RefSignal      => CLKB_dly,
           RefSignalName  => "CLKB",
           RefDelay       => ticd_CLKB,
           SetupHigh      => tsetup_RST_CLKB_posedge_posedge,
           SetupLow       => tsetup_RST_CLKB_negedge_posedge,
           HoldLow        => thold_RST_CLKB_posedge_posedge,
           HoldHigh       => thold_RST_CLKB_negedge_posedge,
           CheckEnabled   => TRUE,
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => Warning
        );
        VitalSetupHoldCheck (
           Violation      => Tviol_RST_CLKDIV_posedge,
           TimingData     => Tmkr_RST_CLKDIV_posedge,
           TestSignal     => RST_dly,
           TestSignalName => "RST",
           TestDelay      => tisd_RST_CLKDIV,
           RefSignal      => CLKDIV_dly,
           RefSignalName  => "CLKDIV",
           RefDelay       => ticd_CLKDIV,
           SetupHigh      => tsetup_RST_CLKDIV_posedge_posedge,
           SetupLow       => tsetup_RST_CLKDIV_negedge_posedge,
           HoldLow        => thold_RST_CLKDIV_posedge_posedge,
           HoldHigh       => thold_RST_CLKDIV_negedge_posedge,
           CheckEnabled   => TRUE,
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => Warning
        );
--     VitalSetupHoldCheck
--       (
--         Violation      => Tviol_RST_CLKDIV_negedge,
--         TimingData     => Tmkr_RST_CLKDIV_negedge,
--         TestSignal     => RST_dly,
--         TestSignalName => "RST",
--         TestDelay      => tisd_RST_CLKDIV,
--         RefSignal      => CLKDIV_dly,
--         RefSignalName  => "CLKDIV",
--         RefDelay       => ticd_CLKDIV,
--         SetupHigh      => tsetup_RST_CLKDIV_posedge_negedge,
--         SetupLow       => tsetup_RST_CLKDIV_negedge_negedge,
--         HoldLow        => thold_RST_CLKDIV_posedge_negedge,
--         HoldHigh       => thold_RST_CLKDIV_negedge_negedge,
--         CheckEnabled   => TRUE,
--         RefTransition  => 'F',
--         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
--         Xon            => Xon,
--         MsgOn          => MsgOn,
--         MsgSeverity    => Warning
--       );
        VitalSetupHoldCheck (
           Violation      => Tviol_RST_OCLK_posedge,
           TimingData     => Tmkr_RST_OCLK_posedge,
           TestSignal     => RST_dly,
           TestSignalName => "RST",
           TestDelay      => tisd_RST_OCLK,
           RefSignal      => OCLK_dly,
           RefSignalName  => "OCLK",
           RefDelay       => ticd_OCLK,
           SetupHigh      => tsetup_RST_OCLK_posedge_posedge,
           SetupLow       => tsetup_RST_OCLK_negedge_posedge,
           HoldLow        => thold_RST_OCLK_posedge_posedge,
           HoldHigh       => thold_RST_OCLK_negedge_posedge,
           CheckEnabled   => TRUE,
           RefTransition  => 'R',
           HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => Warning
        );
        VitalSetupHoldCheck (
           Violation      => Tviol_RST_OCLK_negedge,
           TimingData     => Tmkr_RST_OCLK_negedge,
           TestSignal     => RST_dly,
           TestSignalName => "RST",
           TestDelay      => tisd_RST_OCLK,
           RefSignal      => OCLK_dly,
           RefSignalName  => "OCLK",
           RefDelay       => ticd_CLK,
           SetupHigh      => tsetup_RST_OCLK_posedge_negedge,
           SetupLow       => tsetup_RST_OCLK_negedge_negedge,
           HoldLow        => thold_RST_OCLK_posedge_negedge,
           HoldHigh       => thold_RST_OCLK_negedge_negedge,
           CheckEnabled   => TRUE,
           RefTransition  => 'F',
           HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
           Xon            => Xon,
           MsgOn          => MsgOn,
           MsgSeverity    => Warning
        );
     end if;
--------------------------------------------------------
--   BITSLIP  Setup/Hold 
--------------------------------------------------------
     VitalSetupHoldCheck
       (
         Violation      => Tviol_CE2_CLK_posedge,
         TimingData     => Tmkr_CE2_CLK_posedge,
         TestSignal     => CE2_dly,
         TestSignalName => "CE2",
         TestDelay      => tisd_CE2_CLK,
         RefSignal      => CLK_dly,
         RefSignalName  => "CLK",
         RefDelay       => ticd_CLK,
         SetupHigh      => tsetup_CE2_CLK_posedge_posedge,
         SetupLow       => tsetup_CE2_CLK_negedge_posedge,
         HoldLow        => thold_CE2_CLK_posedge_posedge,
         HoldHigh       => thold_CE2_CLK_negedge_posedge,
         CheckEnabled   => TRUE,
         RefTransition  => 'R',
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
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
         HeaderMsg      => InstancePath & "/X_ISERDES_NODELAY",
         Xon            => Xon,
         MsgOn          => MsgOn,
         MsgSeverity    => Warning
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
            Paths         => (0 => (D_ipd'last_event, tpd_D_O,TRUE),
                              1 => (DDLY_ipd'last_event, tpd_DDLY_O,TRUE),
                              2 => (OFB_ipd'last_event, tpd_OFB_O,TRUE)),
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
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q1,TRUE),
                              1 => (SR_dly'last_event, tpd_RST_Q1,TRUE)),
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
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q2,TRUE),
                              1 => (SR_dly'last_event, tpd_RST_Q2,TRUE)),
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
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q3,TRUE),
                              1 => (SR_dly'last_event, tpd_RST_Q3,TRUE)),
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
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q4,TRUE),
                              1 => (SR_dly'last_event, tpd_RST_Q4,TRUE)),
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
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q5,TRUE),
                              1 => (SR_dly'last_event, tpd_RST_Q5,TRUE)),
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
            Paths         => (0 => (CLKDIV_dly'last_event, tpd_CLKDIV_Q6,TRUE),
                              1 => (SR_dly'last_event, tpd_RST_Q6,TRUE)),
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
     D_CLK_dly,
     D_CLKB_dly,
     DDLY_CLK_dly,
     DDLY_CLKB_dly,
     CE1_dly,
     CE2_dly,
     CLK_dly,
     SR_dly,
     REV_dly,
     CLKDIV_dly,
     OCLK_dly,
     BITSLIP_dly,
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
     SHIFTOUT2_zd;
  end process prcs_output;


end X_ISERDES_NODELAY_V;

