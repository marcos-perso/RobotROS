LIBRARY ieee;
USE ieee.std_logic_1164.all;

PACKAGE cmpy_v2_0_comp IS

    component  cmpy_v2_0 
    generic(
        C_FAMILY        : STRING  := "virtex4";
        A_WIDTH         : integer := 24;   
        B_WIDTH         : integer := 24;   
        M_WIDTH         : integer := -1;    -- How many multiplier result bits are used
        P_WIDTH         : integer := 32;    -- product width, 4 to 65 bits
        OPTIMIZE        : integer := 0;     -- SPEED (0), DSP48_COUNT (1)
        ROUND           : integer := 0;     -- 0: Truncate           1: Round
        PIPE_IN         : integer := 1;     -- number of delay stages on input 0 or 1
        PIPE_MID        : integer := 1;     -- 0: unregistered-; 1: registered internal results
        PIPE_OUT        : integer := 1;     -- number of delay stages on output 0 or 1
        C_HAS_SCLR      : integer := 0;     -- Specifies whether the core has SCLR pin
        C_ENABLE_RLOCS  : integer := 1);    -- Used only for non XST code.
    port( 
        ar              : in std_logic_vector(a_width-1 downto 0);
        ai              : in std_logic_vector(a_width-1 downto 0);
        br              : in std_logic_vector(b_width-1 downto 0);
        bi              : in std_logic_vector(b_width-1 downto 0);
        round_cy        : in std_logic := '1';
        pr              : out std_logic_vector(P_WIDTH-1 downto 0);
        pi              : out std_logic_vector(P_WIDTH-1 downto 0);
        clk             : in std_logic;
        ce              : in std_logic;
        sclr            : in std_logic := '0');
    end component; 

END cmpy_v2_0_comp;


