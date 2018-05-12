library ieee;  
use ieee.std_logic_1164.all;

library XilinxCoreLib;
use XilinxCoreLib.da_1d_dct_pack_v2_1.all;

package da_1d_dct_v2_1_comp is

component c_da_1d_dct_v2_1
  generic( c_operation        : INTEGER := FORWARD_DCT;
           c_data_width       : INTEGER := 16; 
           c_data_type        : INTEGER := 1; --signed
           c_coeff_width      : INTEGER := 16;
           c_points           : INTEGER := 8;
           c_clks_per_sample  : INTEGER := 8; 
           c_precision_control: INTEGER := FULL_PRECISION;
           c_result_width     : INTEGER := 19;
           c_latency          : INTEGER := 16;
           c_shape            : INTEGER := 0; -- not needed for model
           c_enable_symmetry  : INTEGER := 0; 
           c_has_reset        : INTEGER := 0; -- not supported in Version 1 core
           c_enable_rlocs     : INTEGER := 0 -- not needed for model
         );
  port(din   : in    std_logic_vector((c_data_width -1) downto 0); 
       dout  : out    std_logic_vector( (getResultWidth(c_result_width, c_points, c_data_width, c_data_type, c_coeff_width,c_precision_control) - 1) downto 0);
       nd    : in     std_logic;
       rfd   : out std_logic;
       rdy   : out   std_logic;
       clk   : in    std_logic;
       rst   : in     std_logic:= '0'); --rst: not supported in Version 1 core
end component;

-- The following tells XST that c_da_1d_dct_v2_1 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core 
  attribute box_type : string; 
  attribute box_type of c_da_1d_dct_v2_1: component is "black_box"; 
  attribute GENERATOR_DEFAULT : string; 
  attribute GENERATOR_DEFAULT of c_da_1d_dct_v2_1: component is 
            "generatecore com.xilinx.ip.da_1d_dct_v2_1.c_da_1d_dct_v2_1";

end da_1d_dct_v2_1_comp;
