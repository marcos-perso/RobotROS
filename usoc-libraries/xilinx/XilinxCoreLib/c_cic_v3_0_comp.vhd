-- $Id
-- Component declaration

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.ul_utils.ALL;

PACKAGE c_cic_v3_0_comp IS
COMPONENT C_CIC_V3_0 
  GENERIC ( --  c_input_sample_rate        : real;   -- not used in model
            --  c_system_clk            : real;   -- not used in model
            c_data_width              : INTEGER;
            c_stages                  : INTEGER;
            c_filter_type             : INTEGER;
            c_number_channels        : integer;
            c_sample_rate_change_type : integer;
            c_sample_rate_change      : INTEGER;    
            c_sample_rate_change_min  : integer;
            c_sample_rate_change_max  : integer;
            c_differential_delay      : INTEGER;
            c_result_width            : INTEGER;
            c_latency          : INTEGER;
            c_enable_rlocs            : INTEGER);  -- unused in the model
  PORT    ( din     : IN  std_logic_vector( c_data_width-1 DOWNTO 0 );
            nd      : IN  std_logic;
            clk     : IN  std_logic;
            rfd     : OUT std_logic;
            rdy     : OUT std_logic;
            ld_din  : IN  std_logic_vector( bitsneededtorepresent(c_sample_rate_change_max) - 1 downto 0) := (others => '0');
            we    : IN  std_logic := '0';
            dout    : OUT std_logic_vector( c_result_width-1 DOWNTO 0) ); 
END COMPONENT;
END c_cic_v3_0_comp;
