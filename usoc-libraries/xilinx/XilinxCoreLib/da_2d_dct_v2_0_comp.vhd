library ieee;  
use ieee.std_logic_1164.all;

library XilinxCoreLib;
use XilinxCoreLib.da_2d_dct_pack_v2_0.all;

package da_2d_dct_v2_0_comp is

COMPONENT c_da_2d_dct_v2_0
  GENERIC( c_operation        : INTEGER := FORWARD_DCT;
           c_data_width       : INTEGER := 8;
           c_data_type        : INTEGER := 0; --signed
           c_coeff_width      : INTEGER := 12;
           c_internal_width   : INTEGER := 12;
           c_clks_per_sample  : INTEGER := 4; -- not needed for model
           c_precision_control: INTEGER := TRUNCATE;
           c_result_width     : INTEGER := 12;
           c_latency          : INTEGER := 79;
           c_row_latency      : INTEGER := 10;
           c_col_latency      : INTEGER := 10;
           c_shape            : INTEGER := 0; -- not needed for model
           c_enable_symmetry  : INTEGER := 0;
           c_has_reset        : INTEGER := 0; -- no reset
           c_enable_rlocs     : INTEGER := 0; -- not needed for model
					 c_mem_type         : INTEGER := 0  -- not needed by model
         );
  PORT(din  : IN  std_logic_vector ((c_data_width -1) DOWNTO 0):= (others => '0'); 
       dout : OUT std_logic_vector((get_sat_resultwidth(c_operation, 8, c_data_width, c_data_type, 
			                  c_internal_width, c_result_width, c_coeff_width, c_precision_control) - 1) DOWNTO 0) := (others => '0');
       nd   : IN  std_logic := '0';
       rfd  : OUT std_logic := '0';
       rdy  : OUT std_logic := '0';
       clk  : IN  std_logic ;
       rst  : IN  std_logic := '0');
END COMPONENT;
  -- The following tells XST that C_DA_2D_DCT_V2_0 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core 
  attribute box_type : string; 
  attribute box_type of c_da_2d_dct_v2_0: component is "black_box"; 
  attribute GENERATOR_DEFAULT : string; 
  attribute GENERATOR_DEFAULT of c_da_2d_dct_v2_0: component is 
            "generatecore com.xilinx.ip.da_2d_dct_v2_0.c_da_2d_dct_v2_0"; 

end da_2d_dct_v2_0_comp;
