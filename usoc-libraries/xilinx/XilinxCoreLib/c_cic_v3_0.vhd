-- $Header
-- ************************************************************************
--  Copyright 1996-1998 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************
--
--  Description:
--    CIC filter behavioral model
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY std;
USE std.textio.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.ul_utils.ALL;

USE XilinxCoreLib.cic_pack_v3_0.ALL;
--USE work.cic_pack_v3_0.ALL;

ENTITY C_CIC_V3_0 IS
  GENERIC ( --  c_input_sample_rate     : real;   -- not used in model
             -- c_system_clk            : real;  -- not used in model
            c_data_width              : INTEGER;
            c_stages                  : INTEGER;
            c_filter_type             : INTEGER;
            c_number_channels          : integer;
            c_sample_rate_change_type : integer;
            c_sample_rate_change      : INTEGER;    
            c_sample_rate_change_min  : integer;
            c_sample_rate_change_max  : integer;
            c_differential_delay      : INTEGER;
            c_result_width            : INTEGER;
            c_latency                     : INTEGER;
            c_enable_rlocs            : INTEGER);  -- unused in the model
  PORT    ( din     : IN  std_logic_vector( c_data_width-1 DOWNTO 0 );
            nd      : IN  std_logic;
            clk     : IN  std_logic;
            rfd     : OUT std_logic;
            rdy     : OUT std_logic;
             ld_din   : IN  std_logic_vector( bitsneededtorepresent(c_sample_rate_change_max) - 1 downto 0):= (others => '0');
             we        : IN  std_logic := '0';
            dout    : OUT std_logic_vector( c_result_width-1 DOWNTO 0) ); 
END C_CIC_V3_0;

ARCHITECTURE behavioral OF C_CIC_V3_0 IS

-- ----------------------------------------------------------------------- --
-- CONSTANT DECLARATIONS
-- ----------------------------------------------------------------------- --

  CONSTANT data_width                : INTEGER := c_data_width;
  CONSTANT programmable_rate_change     : BOOLEAN := (c_sample_rate_change_type = programmable);
  CONSTANT sample_rate_change           : INTEGER := c_sample_rate_change;
  CONSTANT sample_rate_change_type      : INTEGER := c_sample_rate_change_type;
  CONSTANT sample_rate_change_min       : INTEGER := c_sample_rate_change_min;
  CONSTANT sample_rate_change_max       : INTEGER := c_sample_rate_change_max;
  CONSTANT differential_delay           : INTEGER := c_differential_delay;
  CONSTANT number_of_stages             : INTEGER := c_stages;
  CONSTANT number_of_channels      : INTEGER := c_number_channels;
  CONSTANT interpolating_filter         : BOOLEAN := (c_filter_type = C_INTERPOLATING_FILTER);
  CONSTANT decimating_filter            : BOOLEAN := (c_filter_type = C_DECIMATING_FILTER);
  CONSTANT result_width                 : INTEGER := c_result_width; 
  CONSTANT latency            : INTEGER := c_latency;  
  CONSTANT load_din_port_width      : INTEGER := bitsneededtorepresent(c_sample_rate_change_max);

-- ----------------------------------------------------------------------- --
-- FUNCTIONS
-- ----------------------------------------------------------------------- --

-- ---------------------------------------------------------------------------
 -- Create a std_logic_vector with all bits tied to '0'
 -- ---------------------------------------------------------------------------
 function all0( a: std_logic_vector )
    RETURN boolean IS
  variable z: std_logic_vector(a'LENGTH-1 downto 0) := (OTHERS => '0');
  BEGIN
    return (a = z); 
  END all0;

  -- -----------------------------------------------------------------------------
  -- ADD together two std_logic_vectors 
  --     NOTE: a and b should be the same length, and the result is always the same length
  -- -----------------------------------------------------------------------------
  function "+"(a,b : std_logic_vector)
    return std_logic_vector IS
    constant a_width: integer := a'LENGTH;
    constant b_width: integer := b'LENGTH;
    variable retval : std_logic_vector(a_width-1 downto 0);
    variable carry : std_logic := '0';
  BEGIN  -- plus
    ASSERT (a_width = b_width)
    REPORT "arguments to + should be of the same width" severity error;
    IF (anyX(a) OR anyX(b)) THEN
      retval := (OTHERS => 'X');
    elsif (all0(a)) THEN
      retval := b;
    elsif (all0(b)) THEN
      retval := a;
    else
      FOR i IN 0 TO a_width-1 LOOP
        retval(i) := a(i) XOR b(i) XOR carry;
        carry := (a(i) AND b(i)) or
                 (a(i) AND carry) or
           (b(i) AND carry);
      END LOOP;  -- i
    END IF;    
    RETURN retval;
  END "+";

  -- ------------------------------------------------------------------------------
  -- SUBTRACT two std_logic_vectors
  --    NOTE: a and b should be the same length, and the result is always the same length
  -- ------------------------------------------------------------------------------
FUNCTION "-" (a, b : std_logic_vector)
    RETURN std_logic_vector IS
    constant a_width: integer := a'LENGTH;
    constant b_width: integer := b'LENGTH;
    VARIABLE retval : std_logic_vector(a_width-1 DOWNTO 0);
    VARIABLE borrow : std_logic := '1';
BEGIN
    ASSERT (a_width = b_width)
    REPORT "arguments to - should be of the same width" severity error;
    IF (anyX(a) OR anyX(b)) THEN
        retval := (OTHERS => 'X');
    ELSE
        FOR i IN 0 TO a_width-1 LOOP
            retval(i) := a(i) XOR NOT(b(i)) XOR borrow;
            borrow := (a(i) AND (NOT b(i)))  OR 
                      (a(i) AND  borrow) OR 
                      ((NOT b(i)) AND borrow);
        END LOOP;
    END IF;
    RETURN retval;
END "-";

-- -----------------------------------------------------------------------
-- Data Structure TYPES
-- -----------------------------------------------------------------------
  -- create a type that can hold the data for each stage
  -- the type has indexs along the (differential delay)(number channels)(stages)
  type data_vals is array(0 to (differential_delay - 1)) of std_logic_vector( result_width-1 downto 0);
  type channel_data_vals is array( 0 to (number_of_channels -1) ) of data_vals; 
  type results is array( 0 to number_of_stages - 1 ) of channel_data_vals;
  
  -- this data type holds the results from each stage as its feed from each stage to the next. Note that
  -- the number of channels is used to adjust the length of the delay into the next stage
  type channel_results_vals is array( 0 to (number_of_channels -1) ) of std_logic_vector( result_width-1 downto 0);
  type delayed_results is array( 0 to number_of_stages - 1 ) of channel_results_vals;
  type channel_din_vals  is array( 0 to (number_of_channels - 1) ) of  std_logic_vector( result_width-1 downto 0);
  
  -- types to support delaying the output, handles latency through the core
  type results_latency_vals is array( 0 to (latency -1) ) of std_logic_vector( result_width-1 downto 0);
  type latency_delay      is array( 0 to (number_of_channels - 1) ) of  results_latency_vals;
  
-- ----------------------------------------------------------------------- --
-- SIGNAL DECLARATIONS
-- ----------------------------------------------------------------------- --

  SIGNAL integ_stage_din     : std_logic_vector( result_width-1 downto 0) := (OTHERS => '0');

  SIGNAL integ_din         : std_logic_vector( result_width-1 downto 0) := (OTHERS => '0');
  SIGNAL integ_dout          : std_logic_vector( result_width-1 downto 0) := (OTHERS => '0');
  SIGNAL comb_din            : channel_din_vals; 
  SIGNAL comb_dout           : std_logic_vector( result_width-1 downto 0) := (OTHERS => '0'); 
  SIGNAL integ_nd            : std_logic := '0';
  SIGNAL integ_rdy           : std_logic := '0';
  SIGNAL comb_nd             : std_logic := '0';
  SIGNAL comb_rdy            : std_logic := '0'; 
  
  SIGNAL delay_dout          : latency_delay;
  
  SIGNAL startup       : std_logic := '0';
  SIGNAL localRdy       : std_logic := '0';
  SIGNAL localRFD       : std_logic := '0';
  
  SIGNAL data             : results;  
  SIGNAL delayedResults     : delayed_results;
  
  SIGNAL loadDinHoldReg   : std_logic_vector( (load_din_port_width - 1) downto 0 ) := int_2_std_logic_vector( sample_rate_change, load_din_port_width );
  SIGNAL loadDinReg     : std_logic_vector( (load_din_port_width - 1) downto 0 ) := int_2_std_logic_vector( sample_rate_change, load_din_port_width );
  
BEGIN

-- ----------------------------------------------------------------------- --
-- INTEGRATOR
--
--  There are two way that the integrator is driven: from ND directly or from ND and 
--  the output of the comb section or the insertion of 0's counter
-- ----------------------------------------------------------------------- --

integ : PROCESS (integ_nd, startup)
  
-- delay storage for output
  type resultarray is array( 0 to number_of_stages - 1 ) of std_logic_vector( result_width-1 downto 0);
  type resultChannelArray is array ( 0 to number_of_channels - 1) of resultarray; 
  
  variable result: resultChannelArray; 

  -- channel counter
  variable channel : integer := 0;

BEGIN  
  -- ------------------------------------------------------------
  -- Start-up initialization
  -- ------------------------------------------------------------
    if (startup = '1') then
    for stageLoop in 0 to (number_of_stages - 1) loop
      for channelLoop in 0 to (number_of_channels - 1) loop
              result(channelLoop)(stageLoop) := (OTHERS => '0');
      end loop;
    end loop;
    elsif ( integ_nd = '1' ) then
    -- --------------------------------------------------------
  -- Rising clock edge -- process the incoming data 
  -- All of the stages process data whenever the integ_nd signal is asserted (1)
  -- --------------------------------------------------------
    -- set the output of the integerator to be the present value of the final stage
    -- then set that the integ_rdy is asserted
        integ_dout <= result(channel)(number_of_stages - 1);  
        integ_rdy <= '1';

    -- loop through this channels stages and calculate the new results
    -- store the addition of each stage back into the same location within the results array
    for stageIndex in (number_of_stages - 1) downto 0 loop
      if ( stageIndex > 0 ) then
        result(channel)(stageIndex) := result(channel)(stageIndex) + result(channel)(stageIndex - 1); 
      else
        result(channel)(stageIndex) := result(channel)(stageIndex) + integ_din;
      end if;
        end loop;
      -- increament the channel counter to the next one to be processed
        channel := (channel + 1) MOD number_of_channels;
  else -- no input data available to the integrator 
        integ_rdy <= '0';
    end if; 
  
  end process integ; 
  
-- ----------------------------------------------------------------------- --
-- COMB Section
-- ----------------------------------------------------------------------- --

  comb : PROCESS (comb_nd, startup)
  -- variable to keep track of which channel is being processed
  variable channel: integer := 0;

  BEGIN  
  -- ---------------------------------------------------------------
  -- Initialize all of the variables array of vectors -- set to 0's 
  -- ---------------------------------------------------------------
    if (startup = '1') then
    -- clear the internal data/results storage for each stage
    for stagesIndex in 0 to (number_of_stages - 1) loop
      for channelIndex in 0 to (number_of_channels - 1) loop
        for differentialDelayIndex in 0 to (differential_delay - 1) loop
          data(stagesIndex)(channelIndex)(differentialDelayIndex) <= (OTHERS => '0'); 
          end loop;
      end loop;
    end loop;                        
    
    -- clear the delay elements between each of the stages
    for stagesIndex in 0 to (number_of_stages - 1) loop
      for channelIndex in 0 to (number_of_channels - 1) loop
        delayedResults(stagesIndex)(channelIndex) <= (OTHERS => '0');
       end loop;
    end loop;
    else
    -- ---------------------------------------------------------------
    -- Rising clock edge - process the incoming data
    -- ---------------------------------------------------------------
    if (comb_nd ='1' AND comb_nd'event AND comb_nd'last_value='0') then
      
      -- loop through and calculate the comb filters next stage result values.
      for stageIndex in (number_of_stages-1) downto 0 loop
         -- take the last element in the previous stages delay out and set is as the input to this stage OR
         -- if this is the first stage then use the input to the COMB section as the input
         if ( stageIndex > 0 ) then
           delayedResults(stageIndex)(channel) <= delayedResults(stageIndex - 1)(channel) - data(stageIndex)(channel)(differential_delay -1);
           if ( stageIndex = (number_of_stages - 1) ) then
             comb_dout <= delayedResults(stageIndex - 1)(channel) - data(stageIndex)(channel)(differential_delay -1);
           end if;
         else  
           delayedResults(stageIndex)(channel) <= comb_din(channel) - data(stageIndex)(channel)(differential_delay -1);
           if ( number_of_stages = 1 ) then 
             comb_dout <= comb_din(channel) - data(stageIndex)(channel)(differential_delay -1);
           end if;
         end if;
      end loop; -- end of calculating the next set of intermediate results
          
      -- shift the data storage, differential delay
      for stageIndex in (number_of_stages-1) downto 0 loop
         -- shift the data stored in the differential delay elements
         for diffDelayIndex in (differential_delay -1) downto 0 loop
          -- if this is the first section and the first location in the differential delay 
           if ( (diffDelayIndex = 0) AND (stageIndex = 0) ) then
            -- then store the incoming comb data input
            data(stageIndex)(channel)(diffDelayIndex) <= comb_din(channel);
          elsif (diffDelayIndex = 0)  then
            -- not the first stage but is the first differential delay storage element - store the previous stages result
            data(stageIndex)(channel)(diffDelayIndex) <= delayedResults(stageIndex - 1)(channel); 
          else 
            -- simply move the previous data sample into the next location
            data(stageIndex)(channel)(diffDelayIndex) <= data(stageIndex)(channel)(diffDelayIndex - 1) ;
          end if;
         end loop;
      end loop; -- stages loop
        
      comb_rdy <= '1';
      
      -- increment the channel that is being worked on
      if ( channel >= (number_of_channels - 1) ) then
        channel := 0;
        else 
        channel := channel + 1;
        end if;
    else  -- no comb_nd signal turn the comb_rdy off 
        comb_rdy <= '0';
    end if;  
    end if;  
  end process comb; 

  -- --------------------------------------------------------------------------------
  -- Control Process 
  --
  --  reads the data in and asserts the appropriate internal ND signals
  -- --------------------------------------------------------------------------------
  control: PROCESS
  variable inputSampleCount:       integer := sample_rate_change;  
  variable sampleCountCompareValue: integer := sample_rate_change;
  variable channelCounter  :       integer := 0;
  
  begin  
    for channelIndex in 0 to (number_of_channels - 1) loop
      comb_din(channelIndex) <= (others => '0');
      for latencyIndex in 0 to (latency - 1) loop  
        delay_dout (channelIndex)(latencyIndex) <= (others => '0');
      end loop;
    end loop;
    
    -- assert the internal startup signal to force the INTEGRATOR and COMB to initialize there data structures
    startup <= '1'; 
    wait for 0 ns;
    startup <= '0';
    wait for 0 ns;
    
    -- initial signal values
    rfd  <= '1';        -- Ready For Data 
    localRFD <= '1';
    dout <= (OTHERS => '0');  -- initialize the DOUT to all 0's
    rdy  <= '0';          -- initialize the READY output to 0

    if ( interpolating_filter ) then
      -- loop forever
      interpolating_processing_loop: while ( true ) loop 
        
        -- if the filter has a programmable rate change look for a new value on the LD_DIN Port with WE asserted
        if ( programmable_rate_change ) then
          if ( we = '1' ) then 
            -- update the input holding register for the programmable rate change
            loadDinHoldReg <= ld_din;
          end if;
        end if;
            
        if ( nd = '1' AND localRFD = '1' AND clk'event AND clk = '1' AND clk'last_value = '0' ) then 
          
          -- update the local compare integer value for the rate change value 
          if ( programmable_rate_change ) then
             sampleCountCompareValue := std_logic_vector_2_posint(loadDinReg); 
          end if;
          
          -- start processing the input sample 
          -- filter is busy turn the RFD off
          rfd <= '0';
          localRFD <= '0';
          -- insert the data into the comb section 
          comb_din(channelCounter) <= extend( din, result_width);
          comb_nd  <= '1';
          -- comb finished, pass the comb results into the integrator from the previous processing pass
          integ_din <= comb_dout;
          -- wait for the comb filter to process the input sample
          wait until ( comb_rdy = '1' );
          
          comb_nd <= '0';
          wait for 0 ns;  -- let the data "settle" on the integrators input
          integ_nd <= '1';
          -- wait for the integrator to finish
          wait until ( integ_rdy = '1' );
          
          -- turn the new data for the Integrator off -- this will create an event when reasserted below
          integ_nd <= '0';
          -- take the output of the integrator and place it on the DOUT port
          dout <= integ_dout;                        
          rdy  <= '1'; 
          -- wait til the next clock edge
          wait until (clk'event AND clk = '1' AND clk'last_value = '0');
          
          -- insert (rate_change - 1 ) 0's into the integrator section
          for inputSampleCount in 1 to (sampleCountCompareValue - 1) loop
            integ_din <= (others => '0');
            integ_nd <= '1';
            wait until ( integ_rdy = '1' );
            integ_nd <= '0'; 
            -- place the integrators output on the DOUT port
            dout <= integ_dout;
            -- if this is the last zero to input into the integrator then re-assert the RFD signal
            if ( inputSampleCount = (sampleCountCompareValue - 1)) then 
              rfd <= '1';
              localRFD <= '1';
            end if;
            -- wait for the next rising clock edge
            wait until (clk'event AND clk = '1' AND clk'last_value = '0'); 
          end loop;
          
          -- if the filter has a programmable rate change
          if ( programmable_rate_change ) then
            -- update the register for the programmable rate change
            loadDinReg <= loadDinHoldReg;
           end if;

          rdy <= '0'; 
          
          integ_nd <= '0';
        else
            wait until (clk'event AND clk = '1' AND clk'last_value = '0');
        end if; 
        
      end loop interpolating_processing_loop;
    else -- decimating filter    
      -- do this forever
      decimating_processing_loop: while ( true ) loop
        -- wait for ND and the next clock input
        wait until ( (nd = '1' OR localRdy = '1' OR we = '1') AND clk = '1' AND clk'event AND clk'last_value = '0');
        
        -- sample count compare value is converted from the register std_logic_vector to an integer for use. 
        sampleCountCompareValue := std_logic_vector_2_posint(loadDinReg); 

        if ( nd = '1' ) then
          -- route the input data into the INTEGRATOR
          integ_din <= extend( din, result_width);
          wait for 1 ns;      -- let the data settle
          -- assert the integrators New Data signal
          integ_nd  <= '1';
          -- wait for the integrator to be finished
          wait until ( integ_rdy = '1' );
          
          -- turn the integrator new data signal off and place the integrator output onto the comb din
          integ_nd <= '0';
          if ( inputSampleCount = (sampleCountCompareValue - 1) ) then
            comb_din(channelCounter) <= integ_dout;
          end if;
          wait for 0 ns;   -- let the data settle
          
          -- check if the decimation value has been reached -- if so then have the COMB filter run
          if ( inputSampleCount >= (sampleCountCompareValue - 1) ) then
            comb_nd   <= '1';
            wait until (comb_rdy = '1');
            comb_nd <= '0';             
            
            rdy <= '1'; 
            localRdy <= '1';
            
            -- set the delayed version of the DOUT onto the DOUT Port and save the comb_dout in the delay "reg"
            dout <= delay_dout(channelCounter)(latency - 1);   
            
            for latencyIndex in 0 to (latency -1) loop
              if ( latencyIndex = 0 ) then
              delay_dout(channelCounter)(0) <= comb_dout;
              else  
              delay_dout(channelCounter)(latencyIndex) <= delay_dout(channelCounter)(latencyIndex - 1);
            end if;
            end loop;
            
              -- if the filter has a programmable rate change look for a new value on the LD_DIN Port with WE asserted
             if ( programmable_rate_change AND ( we = '1' ) ) then
                -- update the input holding register for the programmable rate change
                loadDinHoldReg <= ld_din;
             end if;

            -- if the filter has a programmable rate change AND this is the last channel then update the
            -- rate change compare value from the hold registers
            if ( programmable_rate_change AND (channelCounter = (number_of_channels - 1)) ) then
                -- update the register for the programmable rate change
                loadDinReg <= loadDinHoldReg;
             end if;

            -- if this is the last channel then clear the channel counter and sample counter
            if ( channelCounter < (number_of_channels - 1) ) then
                channelCounter := channelCounter + 1;
            else
              channelCounter := 0;
               inputSampleCount := 0;
            end if;
          else  -- have not reached a decimation output
            comb_nd <= '0';            
            
              -- if the filter has a programmable rate change look for a new value on the LD_DIN Port with WE asserted
             if ( programmable_rate_change AND ( we = '1' ) ) then
                   -- update the input holding register for the programmable rate change
                  loadDinHoldReg <= ld_din;
             end if;

            -- if the channel counter is pointing to the last channel then increment the sample counter
            -- and reset the channel counter to the first channel
            -- else increment the channel counter to the next channel
            if ( channelCounter = (number_of_channels - 1) ) then
              inputSampleCount := inputSampleCount + 1;  
              channelCounter := 0;
            else
              channelCounter := channelCounter + 1;
            end if;
            
            -- insure that the RDY signal is not asserted
            rdy <= '0';  
            localRdy <= '0';
          end if; 
        elsif ( localRdy = '1' ) then  
             -- need to turn of the RDY output signal
             localRdy <= '0';
             rdy      <= '0';
             -- if the filter has a programmable rate change look for a new value on the LD_DIN Port with WE asserted
             if ( programmable_rate_change AND ( we = '1' ) ) then
                -- update the input holding register for the programmable rate change
                loadDinHoldReg <= ld_din;
             end if;
         --  end if;
        elsif ( programmable_rate_change AND ( we = '1' ) ) then
             -- update the input holding register for the programmable rate change
             loadDinHoldReg <= ld_din;
        end if;  
    
      end loop decimating_processing_loop;
    end if; -- check for INTERPOLATING filter      
  end process control;
 
end behavioral;
                
