-- ************************************************************************
-- $Id: da_1d_dct_v2_1.vhd
-- ************************************************************************
-- Copyright 2000 - Xilinx Inc.
-- All rights reserved.
-- ************************************************************************
-- Filename: da_1d_dct_v2_1.vhd
-- Creation : Dec 12th, 2000
-- Description: VHDL Behavioral Model for 1D DCT operation
-- 
-- Algorithm : Calculates the 1D DCT coefficients. DCT Points range from 8
--             to 32. There is double buffering at the input, to allow
--             continuous usage of DCT engine.
-- 
-- Equations: Even DCT                                               
--
--            N-1                                        
--  X(k) = SUM { c_k * x(n) * cos((pi*(2n+1)k) /(2*N)) } 
--            n=0                                        
--                                 where k = 0,1, ... ,N-1            
--                                                                   
-- Even IDCT                                                         
--            N-1                                        
--  x(n) = SUM { c_k * X(k) * cos((pi*(2n+1)k) /(2*N)) } 
--            k=0                                        
--                                 where n = 0,1, ... ,N-1            
--                                                                   
--           NOTE :  c_k = 1/sqrt(N)        for k=0                         
--                       = sqrt(2)/sqrt(N)  for k=1,2,..,N-1                
--                                                                   
-- *******************************************************************
-- Last Change :
--
-- *********************************************************************

library ieee;  
use ieee.std_logic_1164.all;
--use ieee.STD_LOGIC_UNSIGNED.all;

library XilinxCoreLib;
use XilinxCoreLib.ul_utils.all;
use XilinxCoreLib.iputils_std_logic_unsigned.all;

--library work;
use XilinxCoreLib.da_1d_dct_pack_v2_1.all;

entity c_da_1d_dct_v2_1 is
  generic( c_operation        : INTEGER := FORWARD_DCT;
           c_data_width       : INTEGER := 16; -- 8 to 24
           c_data_type        : INTEGER := UNSIGNED_VALUE; 
           c_coeff_width      : INTEGER := 16; -- 8 to 24
           c_points           : INTEGER := 8;  -- 8 to 32
           c_clks_per_sample  : INTEGER := 9; 
           c_precision_control: INTEGER := FULL_PRECISION;
           c_result_width     : INTEGER := 36;
           c_latency          : INTEGER := 16;
           c_shape            : INTEGER := 0; -- not needed for model
           c_enable_symmetry  : INTEGER := 0; 
           c_has_reset        : INTEGER := 0; -- not supported for Version 1, set default to 0 (false)
           c_enable_rlocs     : INTEGER := 0 -- not needed for model
         );
  port(din   : in    std_logic_vector((c_data_width -1) downto 0); 
       dout  : out    std_logic_vector( (getResultWidth(c_result_width, c_points, c_data_width, c_data_type, c_coeff_width,c_precision_control) - 1) downto 0):= (others => '0');
       nd    : in     std_logic;
       rfd   : out std_logic:= '0';
       rdy   : out   std_logic:= '0';
       clk   : in    std_logic;
       rst   : in     std_logic:='0'); --not supported in Version 1
end c_da_1d_dct_v2_1;

architecture behavioral of c_da_1d_dct_v2_1 is

  ---------------------------------------------------------------------------------------
  -- CONSTANTS
  ---------------------------------------------------------------------------------------
  constant  FORWARD_DCT        : integer := 0;
  constant  INVERSE_DCT        : integer := 1;
  
  -- determine how many clocks are required to process the data and output the results
  constant  NUMBER_CLOCKS:     integer := calculateNumberClocks( c_data_width, c_clks_per_sample, c_points, c_operation, c_enable_symmetry );
  constant data_width   : integer := getDataWidth(c_data_width, c_data_type);
  constant result_width : integer := getResultWidth(c_result_width,c_points, c_data_width, c_data_type, c_coeff_width,c_precision_control);
  constant full_precision_result_width : integer := getResultWidth(c_result_width,c_points, c_data_width, c_data_type, c_coeff_width, FULL_PRECISION);

  constant scale        : integer := 2**(c_coeff_width - 1);
  
  ---------------------------------------------------------------------------------------
  -- SIGNALS
  ---------------------------------------------------------------------------------------
  signal read1_done  : std_logic := '0';
  signal read2_done  : std_logic := '0';
  signal result_done : std_logic := '0';

  signal first_set    : integer := 1; -- 1 when yet getting 1st set data

  -- create an array of std logic vectors that will be used to delay the result for number clocks that match the latency
  type delayDOUT_array is array(0 to (c_latency -1)) of std_logic_vector((result_width - 1) downto 0);
  signal doutDelay  : delayDOUT_array := (others => (others => '0')); 
  signal doutDelay_0: std_logic_vector((result_width - 1) downto 0) := (others => '0'); 
  
  -- create an array to delay the ND signal to create the RDY signal
  type delayRDY_array is array(0 to (c_latency -1)) of std_logic;
  signal rdyDelay  : delayRDY_array:= (others => '0');
  signal rdyDelay_0: std_logic := '0';
  
  -- create an array to store the output data
  type   doutArray is array( 0 to (c_points - 1)) of std_logic_vector( (result_width - 1) downto 0 );
  signal dout_reg: doutArray := (others => (others => '0')); 

  TYPE slv_coefficientArray is array (natural range <>, natural range <>) of std_logic_vector(c_coeff_width - 1 downto 0);
  TYPE slv_dataInputArray is array (natural range <>) of std_logic_vector(data_width - 1 downto 0);
  TYPE slv_resultsArray is array (natural range <>) of std_logic_vector(full_precision_result_width -1 downto 0);
begin  
  
  -- store the incoming data and if there are c_points stored then 
  -- calculate the output for each DCT/IDCT branch
  store_din_calc_result_and_rfd: process (clk, rst)
  
    -- keeps track of how many words have been written into the DIN
    variable load_counter: integer := 0;
    -- array to hold the real values of the input data and results
    variable data:  slv_dataInputArray(0 to (c_points - 1)) := (others => (others => '0'));
    variable data_2:  slv_dataInputArray(0 to (c_points - 1)) := (others => (others => '0'));
    variable result:  slv_resultsArray(0 to (c_points - 1)) := (others => (others => '0'));
    variable local_read1_done : std_logic := '0';
    variable local_read2_done : std_logic := '0';

    variable coefficients:  coefficientArray ( 0 to (c_points - 1), 0 to (c_points - 1) ); 
    variable coeff_round :  slv_coefficientArray ( 0 to (c_points - 1), 0 to (c_points - 1) ); 

    variable internalIDCT: std_logic := '0'; 
    variable internalRFD : std_logic := '0';
    variable firstPass: boolean := true;
    variable index : integer := 0;

    variable sum : std_logic_vector(full_precision_result_width -1 downto 0) := (others => '0');
    variable product : std_logic_vector( data_width + c_coeff_width -1 downto 0) := (others => '0');

    --added for testing ND is low when RFD is high
    variable tmp : std_logic := '0';
  begin
    -- the first time through calculate the tables and clear the internal DOUT storage 
    if ( firstPass ) then  
      firstPass := false;
      -- set the internal state of the IDCT pin, optional pin based on operation 
      case c_operation is
        when FORWARD_DCT => 
             internalIDCT := '0';
        when INVERSE_DCT => 
             internalIDCT := '1';
        when others => 
             internalIDCT := '0';
      end case;

      if(internalIDCT = '0') then
        coefficients  := generateCoefficients( c_points, FORWARD_DCT);
      else
        coefficients := generateCoefficients( c_points, INVERSE_DCT );
      end if;
      
      for i in 0 to c_points - 1 loop
        for j in 0 to c_points - 1 loop
          
					-- this does rounding to nearest integer
          coeff_round(i,j) := int_2_std_logic_vector(integer(real(scale) * coefficients(i,j)), c_coeff_width); 
        end loop;
      end loop;
    end if;    
  

   -- each rising edge of the clock with a ND and RFD asserted, store and then process the data
    if (clk = '1' and clk'event) then

       -- handle the reset condition
      if ( c_has_reset = 1 and rst = '1' ) then
        load_counter := 0; 
        read1_done  <= '0';
        local_read1_done  := '0';
        local_read2_done  := '0';
        read2_done <= '0';
 
        internalRFD := '0';
        RFD <= '0';
 
        data := (others => (others => '0'));
        data_2 := (others => (others => '0'));
        result := (others => (others => '0'));
        dout_reg <= (others => (others => '0'));
 
 	 	  else
       
        if(nd = '1') and (internalRFD = '1') then
 
          if(local_read1_done = '0') then
            -- store the input value
            data(load_counter) :=  data_type_adjust(din, c_data_type);
          
            load_counter := load_counter + 1;  -- increment the load counter 
    
            if ( load_counter = c_points ) then
              local_read1_done := '1';
              load_counter := 0;    
            end if; -- load_counter
          end if;
        end if; -- nd high
        
        if(result_done = '1') or (first_set = 1) or (local_read2_done = '0') then
          tmp := '1';
        elsif(local_read2_done = '1') then
          tmp := '0';
        end if;
        
        if (local_read1_done = '1') and (tmp = '1') then
          data_2 := data;
          first_set <= 0;
          local_read2_done := '1';
        elsif(local_read1_done = '0') and (result_done = '1') then
          local_read2_done := '0';
        end if; 
 
        if(local_read2_done = '1') and (local_read1_done = '1') then
          for rowIndex in 0 to (c_points -1) loop
            -- clear the sum to start
            sum := (others => '0');         
            for columnIndex in 0 to (c_points - 1) loop
              product := slv_mult(data_2(columnIndex), coeff_round(rowIndex, columnIndex), 1);
              sum := extend(product,full_precision_result_width) + sum;
            end loop;
            -- store the results in the results array
            result(rowIndex) := sum;         
          end loop;
 
          -- take the real values stored in the dout array and convert them back 
          -- into standard logic vectors to be output
          for index in 0 to (c_points - 1) loop
            dout_reg(index) <= trim_result( result(index), result_width, c_precision_control );
          end loop;
        end if; -- local_read2_done = '1' and local_read1_done ='1'
 
        if (local_read1_done = '1') and (tmp = '1') then
          local_read1_done := '0';
        end if;
 
        -- getting the rfd signal.
        if((first_set = 1) or (NUMBER_CLOCKS = c_points) or (data_width < c_points)) then
          internalRFD := '1';
        else 
          if(local_read1_done = '0') then
            internalRFD := '1';
          else
            internalRFD := '0';
          end if;
        end if;
        rfd <= internalRFD;
        
      
        read2_done <= local_read2_done;
        read1_done <= local_read1_done;
 
     end if; -- rst
   end if; -- clk
  end process; 
  
  -- delay the output of clocks to match the latency value
  delay_output_signals: process (clk, rst) 
  
  variable delayIndex : integer := 1;
  begin 

    if clk = '1' and clk'event then  

      if(c_has_reset = 1 and rst = '1') then
        dout <= (others => '0');
        rdy <= '0';
        for index in 1 to (c_latency - 1) loop
          doutDelay(index) <= (others => '0');
          rdyDelay(index) <= '0';
        end loop;

			else

        dout <= doutDelay(c_latency - 3); 
        rdy  <= rdyDelay( c_latency - 3);
 
        doutDelay(1) <= doutDelay_0;
        rdyDelay(1)  <= rdyDelay_0;
 
        for delayIndex in 2 to (c_latency - 3) loop
          doutDelay(delayIndex) <= doutDelay(delayIndex - 1) ;
          rdyDelay(delayIndex)  <= rdyDelay(delayIndex - 1) ;
        end loop;
			end if; --rst
    end if;  -- clk

  end process;--delay_output
  
  pass_output_to_delaychain:process(clk, rst)

  variable internalRDY :std_logic := '0';
  variable result_counter : integer := 0;

  begin


    if clk = '1' and clk'event then
      if(c_has_reset = 1 and rst = '1') then
        result_counter := 0;
        result_done  <= '0';
        internalRDY := '0';
        rdyDelay_0 <= '0';
        doutDelay_0 <= (others => '0');
				
			else

        if (read2_done = '1') then
          result_counter := result_counter + 1;
          
          if(result_counter >= c_points) then
            if(result_counter = c_points) then
              internalRDY := '1';
            else
              internalRDY := '0';
            end if;
 
            if (result_counter = NUMBER_CLOCKS ) then
              result_counter := 0;
            end if;
 
            doutDelay_0 <= dout_reg(c_points - 1);
          else 
            if (result_counter < c_points) then
              doutDelay_0 <= dout_reg(result_counter - 1);
            end if;
            internalRDY := '1';
              
          end if;
 
          if(result_counter = NUMBER_CLOCKS - 1 ) then
              result_done <= '1';
            end if;
        else
          result_counter := 0;
          internalRDY := '0';
 
        end if;--read2_done
 
        rdyDelay_0 <= internalRDY;
 
        if ((result_done = '1') or (first_set = 1)) then
          result_done <= '0';
        end if;
			end if; -- rst
     end if; --clk

  end process; --pass_output_to_delaychain

end behavioral;
