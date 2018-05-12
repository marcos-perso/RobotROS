library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

library XilinxCoreLib;
use XilinxCoreLib.cmpy_v2_0_pkg.all;

-- This module is the VHDL behavioral model of a complex multiplier 

entity cmpy_v2_0  is
    generic(
        C_FAMILY        : string  := "virtex4"; -- FAKE parameter !!! - just to maintain consistency with the structural VHDL
        A_WIDTH         : integer := 32;        -- width of multiplicand a and c, 2 to 18 bits
        B_WIDTH         : integer := 32;        -- width of multiplicand b and d, 2 to 18 bits
        M_WIDTH         : integer := 0;               -- FAKE parameter !!! - just to maintain consistency with the structural VHDL
        P_WIDTH         : integer := 32;        -- product width, 3 to 35 bits
        OPTIMIZE        : integer := 1;         -- 0: SPEED; 1: DSP48_COUNT
        ROUND           : integer := 0;         -- 0: Truncate           1: Round
        PIPE_IN         : integer := 1;         -- number of delay stages on input 0 or 1
        PIPE_MID        : integer := 1;         -- 0: unregistered-; 1: registered internal results
        PIPE_OUT        : integer := 1;         -- number of delay stages on output 0 or 1
        C_HAS_SCLR      : integer := 0;         -- Specifies whether the core has SCLR pin
        C_ENABLE_RLOCS  : integer := 1);        -- FAKE parameter !!! - just to maintain consistency with the structural VHDL
    port( 
        ar              : in std_logic_vector(a_width-1 downto 0);
        ai              : in std_logic_vector(a_width-1 downto 0);
        br              : in std_logic_vector(b_width-1 downto 0);
        bi              : in std_logic_vector(b_width-1 downto 0);
        round_cy        : in std_logic := '1';
        pr              : out std_logic_vector(P_WIDTH-1 downto 0) := (others => '0');
        pi              : out std_logic_vector(P_WIDTH-1 downto 0) := (others => '0');
        clk             : in std_logic;
        ce              : in std_logic;
        sclr            : in std_logic := '0');
end cmpy_v2_0 ;

architecture behavioral of cmpy_v2_0  is

    constant ROUND_I : integer := ROUND * round_supported(C_FAMILY, OPTIMIZE, A_WIDTH, B_WIDTH, P_WIDTH);
    constant LATENCY : integer := cmpy_latency( C_FAMILY, OPTIMIZE, A_WIDTH, B_WIDTH, P_WIDTH, ROUND_I,PIPE_IN, PIPE_MID, PIPE_OUT, C_HAS_SCLR);
    constant MSB     : integer := A_WIDTH + B_WIDTH; 
    constant P_TOP   : integer := min_i(P_WIDTH-1, MSB); 
    -- First extra bit for (-1) * (-1) = +1   <= this bit-growth is sucked up by the double sign
    -- Second extra bit to account for possible bit-growth during summing products

    signal reg_r     : std_logic_vector(P_WIDTH*LATENCY-1 downto 0) := (others => '0');
    signal reg_i     : std_logic_vector(P_WIDTH*LATENCY-1 downto 0) := (others => '0');
    signal rnd_const : std_logic_vector(MSB downto 0) := (others => '0');  
    signal c_pr      : std_logic_vector(P_WIDTH-1 downto 0) := (others => '0');
    signal c_pi      : std_logic_vector(P_WIDTH-1 downto 0) := (others => '0');
    signal fake_s    : std_logic := '0';
    begin

        rnd_const_gen: if (ROUND_I=1) AND (MSB - P_WIDTH  >0) generate
            rnd_const(MSB - P_WIDTH -1 downto 0) <= (others => '1');
        end generate;

        calc_res: process (ar, br, ai, bi, round_cy) 
        variable res_r:         std_logic_vector(MSB downto 0); -- two extra bits
        variable res_i:         std_logic_vector(MSB downto 0);
        variable sgn_r:         std_logic;
        variable sgn_i:         std_logic;
        variable arxbr:         std_logic_vector(MSB downto 0);  -- already padded with two
        variable aixbi:         std_logic_vector(MSB downto 0);  -- extra sign bits  
        variable arxbi:         std_logic_vector(MSB downto 0);  
        variable aixbr:         std_logic_vector(MSB downto 0);  
        begin

            arxbr(MSB-1 downto 0) := ar * br; arxbr(MSB) := arxbr(MSB-1);
            aixbi(MSB-1 downto 0) := ai * bi; aixbi(MSB) := aixbi(MSB-1);
            arxbi(MSB-1 downto 0) := ar * bi; arxbi(MSB) := arxbi(MSB-1);
            aixbr(MSB-1 downto 0) := ai * br; aixbr(MSB) := aixbr(MSB-1);
            res_r := arxbr - aixbi;
            res_i := arxbi + aixbr;
            if (ROUND_I=1) then
                sgn_r := res_r(MSB);
                sgn_i := res_r(MSB);
                res_r := res_r + rnd_const + round_cy; --    + sgn_r;
                res_i := res_i + rnd_const + round_cy; --    + sgn_i;
            end if;
            c_pr(P_TOP downto 0) <= (res_r(MSB downto MSB-P_TOP));
            c_pi(P_TOP downto 0) <= (res_i(MSB downto MSB-P_TOP));

            if (P_WIDTH>P_TOP) then
                c_pr(P_WIDTH-1 downto P_TOP) <= (others => res_r(MSB)); -- zero padd non-relevant MSBs
                c_pi(P_WIDTH-1 downto P_TOP) <= (others => res_i(MSB)); -- zero padd non-relevant MSBs
            end if;
        end process;    

    no_delay_regs: if LATENCY=0 generate
        pr <= c_pr;
        pi <= c_pi;
    end generate;

    need_delay_regs: if LATENCY>0 generate
        delay_regs: process (clk)
        begin
            if clk'event and clk='1' and (LATENCY>0) then  --CLK rising edge
                if (sclr='1') then 
                    reg_r <= (others =>'0');                                        
                    reg_i <= (others =>'0');
                elsif (CE='1') then 
                    reg_r <= reg_r(P_WIDTH*(LATENCY-1)-1 downto 0) & c_pr;
                    reg_i <= reg_i(P_WIDTH*(LATENCY-1)-1 downto 0) & c_pi;
                end if;
            end if;
        end process;

        pr    <= reg_r(P_WIDTH*LATENCY-1 downto P_WIDTH*(LATENCY-1));
        pi    <= reg_i(P_WIDTH*LATENCY-1 downto P_WIDTH*(LATENCY-1));

    end generate;

end behavioral;
