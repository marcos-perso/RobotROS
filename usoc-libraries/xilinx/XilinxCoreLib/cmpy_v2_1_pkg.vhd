LIBRARY ieee;
USE ieee.std_logic_1164.all;

Library XilinxCoreLib;                          --XCC
use XilinxCoreLib.family.all;                   --XCC
use XilinxCoreLib.mult_gen_v7_0_services.all;   --XCC

-- Library XilinxCoreLib;                          --SIM
-- use XilinxCoreLib.family.all;                   --SIM
-- use XilinxCoreLib.mult_gen_v7_0_services.all;   --SIM

-- Library work;                                   --XST
-- use work.family.all;                            --XST

PACKAGE cmpy_v2_1_pkg IS

    constant ARCH_cmpy_18x18    : integer := 0;  -- cmpy_18x18
    constant ARCH_cmpy_35x18    : integer := 1;  -- cmpy_35x18
    constant ARCH_cmpy_35x35    : integer := 2;  -- cmpy_35x35
    constant ARCH_cmpy_3        : integer := 3;  -- cmpy_3    
    constant ARCH_complex_mult3 : integer := 4;  -- complex_mult3
    constant ARCH_complex_mult4 : integer := 5;  -- complex_mult4    

    constant SPEED: integer := 0;
    constant DSP48_COUNT: integer := 1;

    function eval(condition: boolean) return integer;
    function eval_std(condition: boolean) return std_logic;
    function max_i(a, b: integer ) return integer;
    function min_i(a, b: integer ) return integer;
    function when_else(condition: boolean; if_true, if_false: integer) return integer;

    -- function to decide what the legacy mode of DSP48 primitives should be
    function legacy_mod(MULT_REG: integer ) return string;

    -- function that informs whether rounding is supported with the current settings
    function round_supported(C_FAMILY: string; OPTIMIZE, A_WIDTH, B_WIDTH, P_WIDTH: INTEGER) RETURN integer;

    -- function that informs the GUI whether the optimize selection should be enabled with the current settings
    function optimize_enabled(C_FAMILY: string; A_WIDTH, B_WIDTH: integer ) RETURN integer;

    -- function to decide whether a logic fabric adder is necessary in the cmpy_mult35x35
    function cascade_mult35x35(MODE, A_WIDTH, B_WIDTH, C_WIDTH, ROUND_BITS: integer ) return boolean;

    -- function to decide whether the 3 or the 4 multiplier complex mult architecture is going to be used
    function cmpy_arch(C_FAMILY: string; OPTIMIZE, LARGE_WIDTH, SMALL_WIDTH: integer) return integer;
    -- possible values of OPTIMIZE are:

    FUNCTION mult_latency(C_FAMILY: string;  A_WIDTH, B_WIDTH, C_HAS_SCLR,                                  PIPE_MID           : INTEGER) RETURN integer;
    function cmpy_mult_add_latency(          A_WIDTH, B_WIDTH, C_WIDTH,          ROUND_BITS, MODE, PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer;
    function cmpy_axb_plus_cxd_latency(                                                            PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer;
    function cmpy_axb_plus_cxd_casc_latency(                                                       PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer;
    function cmpy18x18_latency(                                                                    PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer;
    function cmpy35x18_latency(                                                                    PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer;
    function cmpy35x35_latency(                                                                    PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer;
    function cmpy_3_DSP48_latency(           A_WIDTH, B_WIDTH,          P_WIDTH,             ROUND,PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer;
    function cmpy_latency(C_FAMILY: string; OPTIMIZE, A_WIDTH, B_WIDTH, P_WIDTH, ROUND,PIPE_IN, PIPE_MID, PIPE_OUT, C_HAS_SCLR : integer) return integer;

    constant cmpy_mult18x18_DSP48s           : integer := 1;
    constant cmpy_mult35x18_DSP48s           : integer := 2;
    constant cmpy_mult35x35_DSP48s           : integer := 4;
    function cmpy_mult_add_DSP48s(           A_WIDTH, B_WIDTH                                             : integer) return integer;
    constant cmpy_axb_plus_cxd_DSP48s        : integer:= 2;
    constant cmpy_axb_plus_cxd_casc_DSP48s   : integer:= 2;
    constant cmpy18x18_DSP48s                : integer:= 4;
    constant cmpy35x18_DSP48s                : integer:= 8;
    constant cmpy35x35_DSP48s                : integer:= 16;
    function cmpy_3_DSP48_DSP48s(            A_WIDTH, B_WIDTH                                             : integer ) return integer;  
    function cmpy_nov4_3_mults(              A_WIDTH, B_WIDTH                                             : integer ) return integer;
    function cmpy_nov4_4_mults(              A_WIDTH, B_WIDTH                                             : integer ) return integer;
    function cmpy_DSP48s(C_FAMILY: string;  OPTIMIZE,  A_WIDTH, B_WIDTH, P_WIDTH, ROUND,PIPE_IN, PIPE_MID, PIPE_OUT : integer ) return integer;

end cmpy_v2_1_pkg;


PACKAGE BODY cmpy_v2_1_pkg IS

--------------------------------------------------------------------
-- Evaluates boolean to integer
--------------------------------------------------------------------
  function eval(condition: boolean) return integer IS
  begin
    if condition=TRUE then return 1;
    else                   return 0;
    end if;
  end eval;

--------------------------------------------------------------------
-- Evaluates boolean to std_logic
--------------------------------------------------------------------
  function eval_std(condition: boolean) return std_logic IS
  begin
    if condition=TRUE then return '1';
    else                   return '0';
    end if;
  end eval_std;

--------------------------------------------------------------------
-- returns the larger of two integers
--------------------------------------------------------------------
    function max_i(a, b: integer ) return integer IS
    begin
        if (a>b) then return a;
        else return b;
        end if;
    end;

--------------------------------------------------------------------
-- returns the smaller of two integers
--------------------------------------------------------------------
    function min_i(a, b: integer ) return integer IS
    begin
        if (a>b) then return b;
        else return a;
        end if;
    end;

-------------------------------------------------------------------------------
-- function to evaluate a ( (condition) ? if_true, if_false ) like expression
-------------------------------------------------------------------------------
    function when_else(condition: boolean; if_true, if_false: integer) return integer IS
    begin
        if condition=TRUE then return if_true;
        else                   return if_false;
        end if;
	end when_else;

--------------------------------------------------------------------
-- returns the smaller of two integers
--------------------------------------------------------------------
    function legacy_mod(MULT_REG: integer ) return string IS
        constant registered_mult: string := "MULT18X18S";
        constant async_mult     : string := "MULT18X18";
    begin
        if (mult_reg=1)then return registered_mult;
        else                return async_mult;
        end if;
    end;

----------------------------------------------------------------------------------------
-- function that informs the GUI whether rounding is supported with the current settings
----------------------------------------------------------------------------------------
    function round_supported(C_FAMILY: string; OPTIMIZE, A_WIDTH, B_WIDTH, P_WIDTH: INTEGER) RETURN integer IS
    constant SMALL_WIDTH:   integer := min_i(A_WIDTH,B_WIDTH);
    constant LARGE_WIDTH:    integer := max_i(A_WIDTH,B_WIDTH);
    variable arch: integer := cmpy_arch(C_FAMILY, OPTIMIZE, LARGE_WIDTH, SMALL_WIDTH);
    begin
        case arch is
            when ARCH_cmpy_18x18    => return 1;
            when ARCH_cmpy_35x18    => return 1;
            when ARCH_cmpy_35x35    => return eval(A_WIDTH+B_WIDTH-P_WIDTH<47);
            when ARCH_complex_mult3 => return 0; 
            when ARCH_complex_mult4 => return 0;
            when others             => return 1;
        end case;
    end round_supported;

-----------------------------------------------------------------------------------------------------------
-- function that informs the GUI whether the optimize selection should be enabled with the current settings
-----------------------------------------------------------------------------------------------------------
    function optimize_enabled(C_FAMILY: string; A_WIDTH, B_WIDTH: INTEGER) RETURN integer IS
    constant LARGE_WIDTH:    integer := max_i(A_WIDTH,B_WIDTH);
    begin
        if derived(c_family,virtex4) then   return eval(LARGE_WIDTH<36);
        else                                return 0;
        end if;
    end optimize_enabled;

--------------------------------------------------------------------
-- Decides whether mult35x535 is going to cascade two cmpy_mult35x18s 
-- directly or through a logic fabric adder
--------------------------------------------------------------------
    function cascade_mult35x35(MODE, A_WIDTH, B_WIDTH, C_WIDTH, ROUND_BITS : integer ) return boolean IS
        variable OK : boolean; 
        begin 
            OK :=   (MODE = 0) OR 
                   ((MODE = 1) AND (ROUND_BITS<46)) OR
                   ((MODE = 2) AND (A_WIDTH+B_WIDTH<49)) OR
                   ((MODE = 3) AND (A_WIDTH+B_WIDTH<49) AND (ROUND_BITS<46)) OR 
                   ((MODE = 4) AND (A_WIDTH+B_WIDTH<49) AND (C_WIDTH<49)) OR
                   ((MODE = 5) AND (A_WIDTH+B_WIDTH<49) AND (C_WIDTH<49));
            return OK;
        end cascade_mult35x35;

-------------------------------------------------------------------------
-- Function to select the optimal implementation 
-- only two optimization criterias: speed or multiplier/DSP48 count
-- Return values: 
-- ARCH_cmpy_18x18
-- ARCH_cmpy_35x18
-- ARCH_cmpy_35x35
-- ARCH_cmpy_3    
-- ARCH_complex_mult3
-- ARCH_complex_mult4
-------------------------------------------------------------------------
    function cmpy_arch(C_FAMILY: string; OPTIMIZE, LARGE_WIDTH, SMALL_WIDTH: integer) return integer is
        variable mult_3_DSP48s          : integer;
        variable mult_4_DSP48s          : integer;
        variable mult_3_cost            : integer;
        variable mult_4_cost            : integer;
        begin 
            if derived(c_family,virtex4) then
                if (OPTIMIZE = SPEED) then
                    if    (LARGE_WIDTH<19)                      then return ARCH_cmpy_18x18;
                    elsif (SMALL_WIDTH<19) and (LARGE_WIDTH<36) then return ARCH_cmpy_35x18;
                    elsif (LARGE_WIDTH<36)                      then return ARCH_cmpy_35x35;
                    elsif ( cmpy_nov4_3_mults(LARGE_WIDTH, SMALL_WIDTH)<cmpy_nov4_4_mults(LARGE_WIDTH, SMALL_WIDTH) ) 
                                                                then return ARCH_complex_mult3;
                                                                else return ARCH_complex_mult4;                        
                    end if;
                else
                    mult_3_DSP48s :=  cmpy_3_DSP48_DSP48s(LARGE_WIDTH, SMALL_WIDTH);
                    if    (LARGE_WIDTH<19)                      then return when_else((mult_3_DSP48s < cmpy18x18_DSP48s), ARCH_cmpy_3, ARCH_cmpy_18x18);
                    elsif (SMALL_WIDTH<19) and (LARGE_WIDTH<35) then return when_else((mult_3_DSP48s < cmpy35x18_DSP48s), ARCH_cmpy_3, ARCH_cmpy_35x18);  -- Was (LARGE_WIDTH<36). Broken into two lines
                    elsif (SMALL_WIDTH<19) and (LARGE_WIDTH=35) then return ARCH_cmpy_35x18;                                                              -- gaborz 3/14/2005 Fix CR 204409
                    elsif (LARGE_WIDTH<35)                      then return when_else((mult_3_DSP48s < cmpy35x35_DSP48s), ARCH_cmpy_3, ARCH_cmpy_35x35);
                    elsif (LARGE_WIDTH=35)                      then return ARCH_cmpy_35x35;
                    elsif ( cmpy_nov4_3_mults(LARGE_WIDTH, SMALL_WIDTH)<cmpy_nov4_4_mults(LARGE_WIDTH, SMALL_WIDTH) ) 
                                                                then return ARCH_complex_mult3;
                                                                else return ARCH_complex_mult4;                        
                    end if;
                end if;
            else
                if ( cmpy_nov4_3_mults(LARGE_WIDTH, SMALL_WIDTH)<cmpy_nov4_4_mults(LARGE_WIDTH, SMALL_WIDTH) ) 
                    then return ARCH_complex_mult3;
                    else return ARCH_complex_mult4;
                end if;
            end if;
        end cmpy_arch;


--------------------------------------------------------------------
-- Latency of mult 
--------------------------------------------------------------------
	FUNCTION mult_latency(C_FAMILY: string; A_WIDTH, B_WIDTH, C_HAS_SCLR, PIPE_MID : INTEGER ) RETURN integer IS
        CONSTANT v2:        integer := 1 - eval(derived(c_family,virtex4)); -- Virtex2 part
        CONSTANT mult_type: integer := 5 - 4*v2; -- 1 for Virtex2, 5 for Virtex4
		VARIABLE latency :  INTEGER;
		BEGIN
            latency := get_mult_gen_v7_0_latency(                           --XCC
                a_width,            --XCC           c_a_width 
                b_width,            --XCC           c_b_width 
                0,                  --XCC           c_b_type  
                0,                  --XCC           c_has_a_signed
                0,                  --XCC           c_reg_a_b_inputs
                0,                  --XCC           c_mem_type
                PIPE_MID,           --XCC           c_pipeline
                mult_type,          --XCC           c_mult_type
                0,                  --XCC           c_has_loadb
                a_width,            --XCC           c_baat
                "0000000000000001", --XCC           c_b_value
                0,                  --XCC           c_a_type
                0,                  --XCC           c_has_swapb
                0,                  --XCC           c_sqm_type
                0,                  --XCC           c_has_aclr
                C_HAS_SCLR,         --XCC           c_has_sclr
                1,                  --XCC           c_has_ce
                0,                  --XCC           c_sync_enable
                0,                  --XCC           c_has_nd
                v2,                 --XCC           c_has_q: has extra register stage only if v2
                9);                 --XCC           bram_addr_width

--             latency := get_mult_gen_v7_0_latency(                           --SIM
--                 a_width,            --SIM           c_a_width 
--                 b_width,            --SIM           c_b_width 
--                 0,                  --SIM           c_b_type  
--                 0,                  --SIM           c_has_a_signed
--                 0,                  --SIM           c_reg_a_b_inputs
--                 0,                  --SIM           c_mem_type
--                 PIPE_MID,           --SIM           c_pipeline
--                 mult_type,          --SIM           c_mult_type
--                 0,                  --SIM           c_has_loadb
--                 a_width,            --SIM           c_baat
--                 "0000000000000001", --SIM           c_b_value
--                 0,                  --SIM           c_a_type
--                 0,                  --SIM           c_has_swapb
--                 0,                  --SIM           c_sqm_type
--                 0,                  --SIM           c_has_aclr
--                 C_HAS_SCLR,         --SIM           c_has_sclr
--                 1,                  --SIM           c_has_ce
--                 1,                  --SIM           c_sync_enable
--                 0,                  --SIM           c_has_nd
--                 v2,                 --SIM           c_has_q: has extra register stage only if v2
--                 9);                 --SIM           bram_addr_width

            return latency + v2*PIPE_MID;    -- add latency of extra register stage if used      
	END mult_latency;

--------------------------------------------------------------------
-- Latency of a cmpy_mult_add
--------------------------------------------------------------------
    function cmpy_mult_add_latency(A_WIDTH, B_WIDTH, C_WIDTH, ROUND_BITS, MODE, PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer IS
        variable latency : integer := 0; -- Latency of the cmpy_mult35x35 without any registers
        constant smaller:   integer := min_i(A_WIDTH,B_WIDTH);
        constant larger:    integer := max_i(A_WIDTH,B_WIDTH);
        variable arch:      boolean; 
        begin

        if (larger<19) then         latency := max_i(0,PIPE_IN) + min_i(max_i(0,PIPE_MID),1) + min_i(max_i(0,PIPE_OUT),1);       
        else
            if (smaller<19) then    latency := max_i(0,PIPE_IN) + min_i(max_i(0,PIPE_MID),1) + 2*min_i(max_i(0,PIPE_OUT),1);
            
            else arch := cascade_mult35x35(MODE, A_WIDTH, B_WIDTH, C_WIDTH, ROUND_BITS);
                                    latency := max_i(0,PIPE_IN) + min_i(max_i(0,PIPE_MID),1) + 4*min_i(max_i(0,PIPE_OUT),1);
                if (not arch) then  latency := latency + min_i(max_i(0,PIPE_OUT),1); end if;
            end if;
        end if;

        return latency; 
        end cmpy_mult_add_latency;

--------------------------------------------------------------------
-- Latency of an cmpy_axb_plus_cxd
--------------------------------------------------------------------
    function cmpy_axb_plus_cxd_latency(PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer IS
        variable latency : integer; 
        begin
            latency := min_i(max_i(0,PIPE_IN),1) + min_i(max_i(0,PIPE_MID),1) + 2*min_i(max_i(0,PIPE_OUT),1);
            return latency; 
        end cmpy_axb_plus_cxd_latency;

--------------------------------------------------------------------
-- Latency of a cascaded cmpy_axb_plus_cxd
--------------------------------------------------------------------
    function cmpy_axb_plus_cxd_casc_latency(PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer IS
        variable latency : integer; 
        begin
            latency := max_i(0,PIPE_IN) + min_i(max_i(0,PIPE_MID),1) + 2*min_i(max_i(0,PIPE_OUT),1);
            return latency; 
        end cmpy_axb_plus_cxd_casc_latency;

-------------------------------------------------------------------
-- Latency of a cmpy18x18
--------------------------------------------------------------------
   function cmpy18x18_latency(PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer IS
        variable latency : integer; 
        begin
            latency := min_i(max_i(0,PIPE_IN),1) + min_i(max_i(0,PIPE_MID),1) + 2*min_i(max_i(0,PIPE_OUT),1);
            return latency; 
        end cmpy18x18_latency;

--------------------------------------------------------------------
-- Latency of a cmpy35x18
--------------------------------------------------------------------
   function cmpy35x18_latency(PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer IS
        variable latency : integer; 
        begin
            latency := min_i(max_i(0,PIPE_IN),1) + min_i(max_i(0,PIPE_MID),1) + 4*min_i(max_i(0,PIPE_OUT),1);
            return latency; 
        end cmpy35x18_latency;

--------------------------------------------------------------------
-- Latency of a cmpy35x35
--------------------------------------------------------------------
   function cmpy35x35_latency(PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer IS
        variable latency : integer; 
        begin
            latency := min_i(max_i(0,PIPE_IN),1) + min_i(max_i(0,PIPE_MID),1) + 8*min_i(max_i(0,PIPE_OUT),1);
            return latency; 
        end cmpy35x35_latency;

--------------------------------------------------------------------
-- Latency of a cmpy3
--------------------------------------------------------------------
    function cmpy_3_DSP48_latency(A_WIDTH, B_WIDTH, P_WIDTH, ROUND, PIPE_IN, PIPE_MID, PIPE_OUT : integer) return integer IS
        variable ADDER_DELAY_1_3:   integer;
        variable ADDER_DELAY_2:     integer;
        variable P2_WIDTH :         integer;
        variable POST_MULT2_DELAY:  integer;
        variable MULT_13_PIPE_IN:   integer;
        variable cmpy_3_DSP48_LATENCY:     integer;
        variable ROUND_BITS_2:      integer;
        begin
            ADDER_DELAY_1_3  := PIPE_IN+PIPE_MID*(A_WIDTH/18)+PIPE_OUT;     
            ADDER_DELAY_2    := PIPE_IN+PIPE_MID*(    (B_WIDTH+eval(PIPE_IN=0)*(A_WIDTH-B_WIDTH))/18   )+PIPE_OUT;     
            P2_WIDTH         := A_WIDTH+B_WIDTH+1;
            ROUND_BITS_2     := P2_WIDTH-P_WIDTH-1;
            POST_MULT2_DELAY := ADDER_DELAY_2   + cmpy_mult_add_latency( A_WIDTH, B_WIDTH+1, 0, ROUND_BITS_2, ROUND, PIPE_IN, PIPE_MID, PIPE_OUT);
            MULT_13_PIPE_IN  := max_i(PIPE_IN, POST_MULT2_DELAY - ADDER_DELAY_1_3 - PIPE_MID);
            cmpy_3_DSP48_LATENCY    := ADDER_DELAY_1_3 + cmpy_mult_add_latency(A_WIDTH+1, B_WIDTH, A_WIDTH+1+B_WIDTH, 0, 5, MULT_13_PIPE_IN, PIPE_MID, PIPE_OUT);
            return cmpy_3_DSP48_LATENCY; 
        end cmpy_3_DSP48_latency;


--------------------------------------------------------------------
-- Latency of the complex multiplier
--------------------------------------------------------------------
	function cmpy_latency(C_FAMILY: string;  OPTIMIZE, A_WIDTH, B_WIDTH, P_WIDTH, ROUND, PIPE_IN, PIPE_MID, PIPE_OUT, C_HAS_SCLR  : integer ) return integer IS
        constant LARGE_WIDTH : integer := max_i(A_WIDTH, B_WIDTH);
        constant SMALL_WIDTH : integer := min_i(A_WIDTH, B_WIDTH);
        variable arch: integer := cmpy_arch(C_FAMILY, OPTIMIZE, LARGE_WIDTH, SMALL_WIDTH);
        begin
            case arch is
                when ARCH_cmpy_18x18    => return cmpy18x18_latency(PIPE_IN, PIPE_MID, PIPE_OUT);
                when ARCH_cmpy_35x18    => return cmpy35x18_latency(PIPE_IN, PIPE_MID, PIPE_OUT);
                when ARCH_cmpy_35x35    => return cmpy35x35_latency(PIPE_IN, PIPE_MID, PIPE_OUT);
                when ARCH_complex_mult3 => return max_i( MULT_LATENCY(C_FAMILY,  A_WIDTH+1, B_WIDTH, C_HAS_SCLR, PIPE_MID), 
                                                         MULT_LATENCY(C_FAMILY,  A_WIDTH, B_WIDTH+1, C_HAS_SCLR, PIPE_MID) )+2*PIPE_OUT;  
                when ARCH_complex_mult4 => return MULT_LATENCY(C_FAMILY,  A_WIDTH, B_WIDTH, C_HAS_SCLR,PIPE_MID)+PIPE_OUT;
                when others => return cmpy_3_DSP48_latency(LARGE_WIDTH, SMALL_WIDTH, P_WIDTH, ROUND, PIPE_IN, PIPE_MID, PIPE_OUT);
            end case;
        end cmpy_latency;

--------------------------------------------------------------------
-- Number of DSP48 block used by the cmpy_mult_add instance
--------------------------------------------------------------------
    function cmpy_mult_add_DSP48s(A_WIDTH, B_WIDTH   : integer) return integer IS
        variable blocks: integer:=0;
        constant smaller:   integer := min_i(A_WIDTH,B_WIDTH);
        constant larger:    integer := max_i(A_WIDTH,B_WIDTH);
        begin
            if (larger<19) then         blocks := cmpy_mult18x18_DSP48s;
            else
                if (smaller<19) then    blocks := cmpy_mult35x18_DSP48s;
                else                    blocks := cmpy_mult35x35_DSP48s;
                end if;
            end if;
            return blocks;
        end cmpy_mult_add_DSP48s;

--------------------------------------------------------------------
-- Number of DSP48 block used by the cmpy3 instance
--------------------------------------------------------------------
    function cmpy_3_DSP48_DSP48s(A_WIDTH, B_WIDTH : integer ) return integer IS
        variable blocks: integer :=0;
        begin
            blocks := cmpy_mult_add_DSP48s(B_WIDTH+1, A_WIDTH);
            
            if (A_WIDTH+B_WIDTH+1>48) then -- mult_35x18 can not be used
                    blocks := blocks+8;    
            else 
                    blocks := blocks+2*cmpy_mult_add_DSP48s(A_WIDTH+1, B_WIDTH);
            end if;
            
            return blocks;
        end;

-------------------------------------------------------------------
-- Number of mult18x18s used by a mult_gen instance
-------------------------------------------------------------------
    function mult_gen_mults(A_WIDTH, B_WIDTH: integer ) return integer is
    begin
        return (1+(A_WIDTH-2)/17)*(1+(B_WIDTH-2)/17);
    end mult_gen_mults;

-------------------------------------------------------------------
-- Number of mult18x18s used by the complex_mult3 instance
-------------------------------------------------------------------
    function cmpy_nov4_3_mults(A_WIDTH, B_WIDTH: integer ) return integer is
    variable debug  : integer := 2*mult_gen_mults(A_WIDTH+1, B_WIDTH)+mult_gen_mults(A_WIDTH, B_WIDTH+1);
    begin
        return debug;
    end cmpy_nov4_3_mults;

-------------------------------------------------------------------
-- Number of mult18x18s used by the complex_mult4 instance
-------------------------------------------------------------------
    function cmpy_nov4_4_mults(A_WIDTH, B_WIDTH: integer ) return integer is
    variable debug  : integer := 4*mult_gen_mults(A_WIDTH, B_WIDTH);
    begin
        return debug;
    end cmpy_nov4_4_mults;
    
--------------------------------------------------------------------
-- Number of DSP48 block used by the cmpy instance
--------------------------------------------------------------------
    function cmpy_DSP48s(C_FAMILY: string; OPTIMIZE,  A_WIDTH, B_WIDTH, P_WIDTH, ROUND,PIPE_IN, PIPE_MID, PIPE_OUT : integer ) return integer IS
        constant LARGE_WIDTH : integer := max_i(A_WIDTH, B_WIDTH);
        constant SMALL_WIDTH : integer := min_i(A_WIDTH, B_WIDTH);
        variable arch        : integer := cmpy_arch(C_FAMILY, OPTIMIZE, LARGE_WIDTH, SMALL_WIDTH);
        variable prim_size   : integer := 1;
        variable prim_size_3 : integer := 1;

        begin
            case arch is
                when ARCH_cmpy_18x18    => return cmpy18x18_DSP48s; -- 4
                when ARCH_cmpy_35x18    => return cmpy35x18_DSP48s; -- 8
                when ARCH_cmpy_35x35    => return cmpy35x35_DSP48s; -- 16
                when ARCH_complex_mult3 => return cmpy_nov4_3_mults(A_WIDTH, B_WIDTH);
                when ARCH_complex_mult4 => return cmpy_nov4_4_mults(A_WIDTH, B_WIDTH);
                when others             => return cmpy_3_DSP48_DSP48s(A_WIDTH, B_WIDTH);
            end case;

        end cmpy_DSP48s;


end cmpy_v2_1_pkg;
