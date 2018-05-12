LIBRARY ieee;  
USE ieee.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.ul_utils.all;
USE XilinxCoreLib.ddc_v1_0_pack.all;


PACKAGE ddc_v1_0_comp is

COMPONENT c_ddc_v1_0
  GENERIC( 
           c_input_sample_rate   			: REAL;
           c_system_clk          			: REAL;
           c_dds_sfdr            			: REAL;
					 c_data_width               : INTEGER;
					 c_dout_width           		: INTEGER;
					 
					 --Mixer parameters
           c_mixer_output_width  			: INTEGER;
           
					 --DDS parameters
					 c_dds_type            			: INTEGER;
					 c_dds_freq_resolution      : REAL;
					 c_dds_memory_type          : INTEGER;
					 c_phase_increment_type     : INTEGER;
					 c_local_oscilator_freq     : REAL;
           c_phase_offset_type        : INTEGER;
           c_phase_offset_value       : REAL;
					
					 --CIC filter parameters
           c_cic_stages          			: INTEGER;
					 c_cic_differential_delay   : INTEGER;
           c_cic_decimate_rate 	  		: INTEGER;
           c_cic_decimate_type  			: INTEGER;
           c_cic_decimation_range_low : INTEGER;
           c_cic_decimation_range_high: INTEGER;
           c_cic_dout_width   		 	  : INTEGER;
					 
					 --Gain Parameters
           c_gain_type  	    				: INTEGER;
           c_gain							    		: INTEGER;
					 c_gain_dout_width          : INTEGER; 
					 
					 --CFIR parameters
					 c_cfir_coef_width     		  : INTEGER;
           c_cfir_mif_file            : STRING;
           c_cfir_number_taps         : INTEGER;
           c_cfir_filter_type         : INTEGER;
           c_cfir_response   				  : INTEGER;
           c_cfir_decimation_rate     : INTEGER;
           c_cfir_reload        		  : INTEGER;
           c_cfir_output_width			  : INTEGER;

           --PFIR parameters
					 c_pfir_coef_width      		: INTEGER;
           c_pfir_mif_file          	: STRING;
           c_pfir_number_taps         : INTEGER;
           c_pfir_filter_type      		: INTEGER;
           c_pfir_response  					: INTEGER;
					 c_pfir_decimation_rate     : INTEGER;
           c_pfir_reload        			: INTEGER; 
           c_pfir_output_width				: INTEGER; 
					 
					 --Threshold detects parameters
					 c_peak_detect         			: INTEGER;
					 c_peak_threshold         	: INTEGER;
					 c_enable_rlocs         		: INTEGER
         );

  PORT(DIN:    IN  std_logic_vector(c_data_width-1 downto 0);
			 ND:     IN  std_logic;
       RDY:    OUT std_logic;
       RFD:    OUT std_logic;
       CLK:    IN  std_logic;
       ADDR:   IN  std_logic_vector(4 downto 0);
       WE:     IN  std_logic;
			 SEL:    IN  std_logic;
       --RD:     IN  std_logic;
       LD_DIN: IN  std_logic_vector((getLdDinWidth(c_peak_detect, c_phase_increment_type, getPhaseAccumWidth(c_input_sample_rate,
c_dds_freq_resolution), c_phase_offset_type, c_cic_decimate_type, c_cic_decimation_range_high, c_gain_type, c_cfir_coef_width, c_pfir_coef_width, c_cfir_reload, c_pfir_reload) - 1) downto 0);
			 --STATUS: OUT std_logic_vector((getThresholdWidth(c_peak_detect) - 1) downto 0);   
       DOUT_I: OUT std_logic_vector(c_dout_width-1 downto 0);
       DOUT_Q: OUT std_logic_vector(c_dout_width-1 downto 0));

END COMPONENT;
  -- The following tells XST that C_DDC_V1_0 is a black box which  
  -- should be generated command given by the value of this attribute 
  -- Note the fully qualified SIM (JAVA class) name that forms the 
  -- basis of the core 
  attribute box_type : string; 
  attribute box_type of c_ddc_v1_0: component is "black_box"; 
  attribute GENERATOR_DEFAULT : string; 
  attribute GENERATOR_DEFAULT of c_ddc_v1_0: component is 
            "generatecore com.xilinx.ip.ddc_v1_0.c_ddc_v1_0"; 

end ddc_v1_0_comp;
