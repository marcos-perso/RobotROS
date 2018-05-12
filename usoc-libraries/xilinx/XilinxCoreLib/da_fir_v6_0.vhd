-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/da_fir_v6_0.vhd,v 1.1 2010-07-10 21:43:01 mmartinez Exp $
-- ************************************************************************
--  Copyright 1996-2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************
--
--  Description:
--    DA FIR filter behavioral model
--

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

LIBRARY std;
USE std.textio.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.dafir_pack_v6_0.ALL;
USE XilinxCoreLib.ul_utils.ALL;

ENTITY C_DA_FIR_V6_0 IS
  GENERIC( c_data_width : INTEGER;
           c_result_width : INTEGER;
           c_coeff_width : INTEGER;
           c_taps : INTEGER;
           c_response : INTEGER;
           c_data_type : INTEGER;
           c_coeff_type : INTEGER;
           c_channels : INTEGER;
           c_filter_type : INTEGER;
           c_saturate : INTEGER;
           c_has_sel_o : INTEGER;
           c_has_sel_i : INTEGER;
           c_mem_init_file : STRING;
           c_zpf : INTEGER;
           c_reg_output : INTEGER; 
           c_baat : INTEGER; 
           c_has_sin_f : INTEGER;  
           c_has_sin_r : INTEGER;  
           c_has_sout_r : INTEGER; 
           c_has_sout_f : INTEGER; 
           c_reload : INTEGER;
           c_reload_delay : INTEGER; 
           c_reload_mem_type : INTEGER; -- ignored by model
           c_polyphase_factor : INTEGER; 
           c_optimize : INTEGER; -- ignored by model
           c_enable_rlocs : INTEGER; -- ignore by model
           c_use_model_func : INTEGER; 
           c_latency : INTEGER; 
           c_shape : INTEGER); -- ignored by model
  PORT(      din  : IN  std_logic_vector( c_data_width-1 DOWNTO 0 ) := (OTHERS => '0');
               nd : IN  std_logic;
              clk : IN  std_logic;
          coef_ld : IN  std_logic := '0';
           ld_din : IN  std_logic_vector( c_coeff_width-1 DOWNTO 0) := (OTHERS => '0');
            ld_we : IN  std_logic := '0';
         cas_f_in : IN  std_logic_vector( c_baat-1 downto 0) := (OTHERS => '0');
         cas_r_in : IN  std_logic_vector( c_baat-1 downto 0) := (OTHERS => '0');
        cas_f_out : OUT std_logic_vector( c_baat-1 downto 0);
        cas_r_out : OUT std_logic_vector( c_baat-1 downto 0);
            sel_i : OUT std_logic_vector( bitsneededtorepresent(c_channels-1)-1 DOWNTO 0);
            sel_o : OUT std_logic_vector( bitsneededtorepresent(c_channels-1)-1 DOWNTO 0);
             dout : OUT std_logic_vector( c_result_width-1 DOWNTO 0 );
           dout_q : OUT std_logic_vector( c_result_width-1 DOWNTO 0 );
           dout_i : OUT std_logic_vector( c_data_width-1 DOWNTO 0);
              rdy : OUT std_logic;
              rfd : OUT std_logic);
END C_DA_FIR_V6_0;

ARCHITECTURE behavioral OF C_DA_FIR_V6_0 IS

-- ------------------------------------------------------------------------ --
-- GUI CONSTANT DECLARATIONS                                                --
-- ------------------------------------------------------------------------ --

  CONSTANT data_width     : INTEGER := c_data_width;
  CONSTANT result_width   : INTEGER := c_result_width;
  CONSTANT orig_number_of_taps : INTEGER := c_taps;     -- number of taps specified by user
  CONSTANT number_of_taps : INTEGER := c_taps + ((c_taps-1) * eval(c_filter_type=c_interpolated_fir) * (c_zpf-1));  -- total number of taps after adding zeros for interpolated filters
  CONSTANT coef_width     : INTEGER := c_coeff_width; 
  CONSTANT response       : INTEGER := c_response;
  CONSTANT data_signed    : BOOLEAN := (c_data_type=c_signed);
  CONSTANT coef_signed    : BOOLEAN := (c_coeff_type=c_signed);
  CONSTANT data_nrz       : BOOLEAN := (c_data_type=c_nrz);
  CONSTANT coef_nrz       : BOOLEAN := (c_coeff_type=c_nrz);
  CONSTANT saturate       : BOOLEAN := (c_saturate=1);
  CONSTANT has_out_chan_indicator : BOOLEAN := (c_has_sel_o=1);
  CONSTANT has_in_chan_indicator  : BOOLEAN := (c_has_sel_i=1);
  CONSTANT has_casc_r_in          : BOOLEAN := (c_has_sin_r=1);
  CONSTANT has_casc_f_in          : BOOLEAN := (c_has_sin_f=1);
  CONSTANT has_casc_r_out         : BOOLEAN := (c_has_sout_r=1);
  CONSTANT has_casc_f_out         : BOOLEAN := (c_has_sout_f=1);
  CONSTANT chan_ind_width         : INTEGER := bitsneededtorepresent(c_channels-1);
  CONSTANT filter_type	          : INTEGER := c_filter_type;
  CONSTANT number_of_channels     : INTEGER := c_channels;
  CONSTANT zero_packing_factor    : INTEGER := c_zpf;
  CONSTANT has_registered_output  : BOOLEAN := (c_reg_output=1);
  CONSTANT use_model_func	  : BOOLEAN := (c_use_model_func=1);
  CONSTANT use_latency            : INTEGER := c_latency;
  CONSTANT baat			  : INTEGER := c_baat;
  CONSTANT coefficient_file       : STRING  := c_mem_init_file;
  CONSTANT pda			  : BOOLEAN := (c_baat = data_width);
  CONSTANT polyphase_factor       : INTEGER := c_polyphase_factor;
  CONSTANT interpolating_filter   : BOOLEAN := (c_filter_type = c_polyphase_interpolating);
  CONSTANT decimating_filter      : BOOLEAN := (c_filter_type = c_polyphase_decimating);
  CONSTANT interpolating_half_band : BOOLEAN := (c_filter_type = c_interpolating_half_band);
  CONSTANT decimating_half_band   : BOOLEAN := (c_filter_type = c_decimating_half_band);
  CONSTANT hilbert_transform      : BOOLEAN := (c_filter_type=c_hilbert_transform);
  CONSTANT reloadable             : BOOLEAN := (c_reload = c_stop_during_reload);
  CONSTANT reload_delay		  : INTEGER := c_reload_delay; 
  CONSTANT local_coef_width	  : INTEGER := c_coeff_width + eval(c_coeff_type=c_nrz);
  CONSTANT local_data_width	  : INTEGER := c_data_width + eval(c_data_type=c_nrz);

-- ------------------------------------------------------------------------ --
-- TYPE DECLARATIONS                                                        --
-- ------------------------------------------------------------------------ --

  TYPE filter_coefficients_type IS ARRAY(1 TO number_of_taps) OF std_logic_vector(local_coef_width-1 downto 0);
  TYPE   tap_storage_type IS ARRAY(1 TO number_of_taps) OF std_logic_vector(local_data_width-1 downto 0);
  TYPE   all_tap_storage_type IS ARRAY(0 to number_of_channels-1) of tap_storage_type;


-- ------------------------------------------------------------------------ --
-- FUNCTIONS                                                                --
-- ------------------------------------------------------------------------ --


  FUNCTION hex_to_std_logic_vector(hexstring: STRING)
    RETURN std_logic_vector IS

    CONSTANT length 	  : integer := hexstring'LENGTH;
    VARIABLE bitval       : std_logic_vector((length*4)-1 downto 0);
    VARIABLE posn	  : integer := bitval'LEFT;
    VARIABLE ch           : character;
  BEGIN
    FOR i in 1 to length LOOP
      ch := hexstring(i);
      CASE ch IS
        WHEN '0' => bitval(posn downto posn-3) := "0000";
        WHEN '1' => bitval(posn downto posn-3) := "0001";
        WHEN '2' => bitval(posn downto posn-3) := "0010";
        WHEN '3' => bitval(posn downto posn-3) := "0011";
        WHEN '4' => bitval(posn downto posn-3) := "0100";
        WHEN '5' => bitval(posn downto posn-3) := "0101";
        WHEN '6' => bitval(posn downto posn-3) := "0110";
        WHEN '7' => bitval(posn downto posn-3) := "0111";
        WHEN '8' => bitval(posn downto posn-3) := "1000";
        WHEN '9' => bitval(posn downto posn-3) := "1001";
        WHEN 'A' | 'a' => bitval(posn downto posn-3) := "1010";
        WHEN 'B' | 'b' => bitval(posn downto posn-3) := "1011";
        WHEN 'C' | 'c' => bitval(posn downto posn-3) := "1100";
        WHEN 'D' | 'd' => bitval(posn downto posn-3) := "1101";
        WHEN 'E' | 'e' => bitval(posn downto posn-3) := "1110";
        WHEN 'F' | 'f' => bitval(posn downto posn-3) := "1111";
        WHEN OTHERS => ASSERT false
                       REPORT "Invalid hex value in MIF file" SEVERITY ERROR;
                       bitval(posn downto posn-3) := "XXXX";
     END CASE;
     posn := posn - 4;
   END LOOP;
   RETURN bitval;
 END hex_to_std_logic_vector;

--
-- Read coefficients from the mif file, and convert from NRZ to signed if necessary
--

  FUNCTION read_coefficients( filename: string; number_of_values: integer; nrz_coef: boolean )
    RETURN filter_coefficients_type IS

    VARIABLE coefficients : filter_coefficients_type;
    FILE     coeffile     : TEXT IS filename;
    VARIABLE hexline	  : LINE;
    VARIABLE width	  : INTEGER := (coef_width+3)/4;
    VARIABLE hexstring	  : STRING(1 TO width);
    VARIABLE bitval	  : std_logic_vector(width*4 -1 DOWNTO 0);
    VARIABLE lines	  : INTEGER := 1;
  BEGIN

    WHILE (NOT(endfile(coeffile)) AND (lines <= number_of_values)) LOOP
      readline(coeffile, hexline);
      read(hexline, hexstring);
      bitval := hex_to_std_logic_vector(hexstring);
      if (nrz_coef) then
        if (bitval(0) = '0') then
          coefficients(lines) := "01";
        elsif (bitval(0) = '1') then
          coefficients(lines) := "11";
        else
          ASSERT false
          REPORT "Invalid NRZ data in MIF file" SEVERITY ERROR;
          coefficients(lines) := "XX";
        end if;
      else
        coefficients(lines) := bitval(coef_width-1 downto 0);
      end if;
      lines := lines + 1;
    END LOOP;
    return coefficients;
  END read_coefficients;

--
-- Use function read_coefficients to read the mif file, and convert from NRZ to signed if necessary.
-- For interpolated filters, add zeros in the coefficient array.
--
 FUNCTION assign_filter_coefficients( filename: STRING;
                                      filter_type : INTEGER;
                                      orig_number_of_taps : INTEGER;   
			              zero_packing_factor: INTEGER;
                                      number_of_taps: INTEGER; 
			              nrz_coef : BOOLEAN )
    RETURN filter_coefficients_type IS

    VARIABLE filter_coefficients : filter_coefficients_type;
    VARIABLE packed_filter_coefficients : filter_coefficients_type;
    VARIABLE posn : INTEGER;

  BEGIN
    filter_coefficients := read_coefficients(filename, orig_number_of_taps, nrz_coef );
    IF (filter_type = c_interpolated_fir) THEN
      posn := 1;
      FOR i IN 1 TO orig_number_of_taps-1 LOOP
        packed_filter_coefficients(posn) := filter_coefficients(i);
        posn := posn + 1;
        IF (zero_packing_factor > 1) THEN
          FOR j in 1 TO zero_packing_factor-1 LOOP
            packed_filter_coefficients(posn) := (OTHERS => '0');
            posn := posn + 1;
          END LOOP;
        END IF;
      END LOOP;
      packed_filter_coefficients(posn) := filter_coefficients(orig_number_of_taps);
      ASSERT posn = number_of_taps REPORT "fundamental error in assigning coeffs" SEVERITY ERROR;
    ELSE
      packed_filter_coefficients := filter_coefficients;
    END IF;
    RETURN packed_filter_coefficients;
  END assign_filter_coefficients;

--
-- Compute the latency of the parallel to serial converter depending on the filter characteristics.
-- This is the number of cycles after ND that RFD will be asserted again.
--
  function compute_psc_latency(symmetric: boolean;
  				baat: integer;
  				data_width: integer)
  return integer is
  variable psc_latency: integer := 0;
  begin
    if (baat = data_width) then
      psc_latency := 1;
    elsif (baat = 1) then
      psc_latency := data_width + (eval(NOT (interpolating_filter) AND symmetric)); 
    else
      psc_latency := (data_width + eval(NOT (interpolating_filter) AND symmetric) + (baat - 1))/baat;
    end if;
    if ((interpolating_filter OR interpolating_half_band) AND (psc_latency < polyphase_factor)) then
      psc_latency := polyphase_factor;
    end if;
    psc_latency := psc_latency-1; -- subtract one because the model doesn't count the first rising edge
    return psc_latency;
  end compute_psc_latency;		


  function all0(a: std_logic_vector)
    RETURN boolean IS
  variable z: std_logic_vector(a'LENGTH-1 downto 0) := (OTHERS => '0');
  BEGIN
    return (a = z); 
  END all0;

  function all1(a: std_logic_vector)
    RETURN boolean IS
  variable o: std_logic_vector(a'LENGTH-1 downto 0) := (OTHERS => '1');
  BEGIN
    return (a = o); 
  END all1;

  function any1(a: std_logic_vector)
    RETURN boolean IS
  variable z: std_logic_vector(a'LENGTH-1 downto 0) := (OTHERS => '0');
  BEGIN
    return (NOT (a = z));
  end any1;

-- Zero the data memory.  Note that if the data is NRZ then the data memory is 
-- initialized with 1s (NRZ 0).
  function zero_taps(number_of_taps: integer; data_nrz: boolean)
    RETURN tap_storage_type IS
  variable retval: tap_storage_type;
  BEGIN
    if (data_nrz) then
      for i in 1 to number_of_taps loop
        retval(i) := "01";
      end loop;
    else
      for i in 1 to number_of_taps loop
        retval(i) := (OTHERS => '0');
      end loop;
    end if;
    return retval;
  END zero_taps;

-- ------------------------------------------------------------------------ --
-- CONSTANT DECLARATIONS                                                    --
-- ------------------------------------------------------------------------ --

  CONSTANT symmetric: BOOLEAN := (response = c_symmetric OR response = c_neg_symmetric);
  CONSTANT psc_latency: INTEGER := compute_psc_latency(symmetric, baat, data_width);
  CONSTANT cascaded: BOOLEAN := has_casc_f_in OR has_casc_f_out;
  CONSTANT cascade_num_cycles: INTEGER := (data_width + eval(data_width /= baat)*eval(symmetric) + baat - 1)/baat;
  CONSTANT extwidth: INTEGER := cascade_num_cycles*baat;
  CONSTANT full_result_width   : INTEGER := local_coef_width + local_data_width + bitsneededtorepresent(number_of_taps);


-- ------------------------------------------------------------------------ --
-- SIGNAL DECLARATIONS                                                      --
-- ------------------------------------------------------------------------ --

 
  SIGNAL process_data     : std_logic			 	      := '0';
  SIGNAL data_ready	  : std_logic				      := '0';
  SIGNAL cascade_data_ready  : std_logic			      := '0';
  SIGNAL cascade_input_read : std_logic				      := '1';
  SIGNAL result_ready	  : std_logic				      := '0';
  SIGNAL processed_result : std_logic				      := '0';
  SIGNAL delayed_nd1	  : std_logic				      := '0';
  SIGNAL delayed_nd	  : std_logic				      := '0';
  SIGNAL data             : all_tap_storage_type                      := (OTHERS => zero_taps(number_of_taps, data_nrz));
  SIGNAL filter_coefficients : filter_coefficients_type               := assign_filter_coefficients(coefficient_file, filter_type, orig_number_of_taps, zero_packing_factor, number_of_taps, coef_nrz);
  SIGNAL channel_number   : integer                                   := 0;
  SIGNAL new_data         : std_logic_vector(data_width-1 downto 0)   := (OTHERS => '0');
  SIGNAL delayed_new_data : std_logic_vector(data_width-1 downto 0)   := (OTHERS => '0');
  SIGNAL new_f_data       : std_logic_vector(data_width-1 downto 0)   := (OTHERS => '0');
  SIGNAL new_r_data       : std_logic_vector(data_width-1 downto 0)   := (OTHERS => '0');
  SIGNAL save_casc_f      : std_logic_vector(extwidth-1 downto 0)     := (OTHERS => '0');
  SIGNAL save_casc_r      : std_logic_vector(extwidth-1 downto 0)     := (OTHERS => '0');
  SIGNAL result           : std_logic_vector(result_width-1 downto 0) := (OTHERS => '0');
  SIGNAL mid_value        : std_logic_vector(data_width-1 downto 0)   := (OTHERS => '0'); 
  SIGNAL polyphase_internal_nd : std_logic			      := '0';
  SIGNAL polyphase_internal_rfd : std_logic			      := '1';
  SIGNAL ce		  : std_logic				      := '1';
  SIGNAL lrfd             : std_logic                                 := '1';
  SIGNAL reloading        : std_logic                                 := '0';

BEGIN

  rfd <= lrfd;


--
-- Update the data memory with the new DIN value. Becomes active when data_ready or cascade_ready
-- is asserted.
--   Handle unknowns on the inputs.
--   For interpolating filters, stuff 0s into the data memory.
--   For NRZ data, translate from NRZ to signed before storing in data memory
--   Assert process_data for a new result to be computed
--   Clears the data memory when the filter is being reloaded
--
  tap_storage : PROCESS
  variable setup : boolean := TRUE;
  constant midpoint: integer := (number_of_taps+1)/2;
  constant loop_count : integer := eval(interpolating_half_band OR interpolating_filter) * (polyphase_factor-1) + 1;
  variable local_data : std_logic_vector(local_data_width-1 downto 0);
  BEGIN
    if (setup = TRUE) then
      WAIT UNTIL clk'event AND rat(clk)='1' AND rat(clk'last_value)='0';
      setup := false;
    elsif ((rat(clk) = 'X' AND rat(ce) /= '0' AND rat(clk'LAST_VALUE)/='X') OR
           (rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='X')) then
      for i in 0 to number_of_channels-1 loop
        for j in 1 to number_of_taps loop
          data(i)(j) <= setallX(data_width);
        end loop;
      end loop;
    elsif (data_ready'event and data_ready='1') then
      -- used only if not cascaded
      if (anyX(new_data)) then
        local_data := (OTHERS => 'X');
      elsif (data_nrz) then
        if (new_data(0) = '0') then
          local_data := "01";
        else
          local_data := "11";
        end if;
      else
        local_data := new_data;
      end if;
      for i in 1 to loop_count loop
        for j in number_of_taps downto 2 loop
          data(channel_number)(j) <= data(channel_number)(j-1);
        end loop;
        data(channel_number)(1) <= local_data;
        if (NOT (decimating_half_band OR decimating_filter) OR polyphase_internal_nd = '1') then
          process_data <= '1';
          WAIT until (result_ready'event AND result_ready = '0') OR reloading = '1';
          process_data <= '0';
          WAIT for 0 ns;
        else
          process_data <= 'X';
          WAIT for 0 ns;
          process_data <= '0';
        end if;
        local_data := (OTHERS => '0');
      end loop;
    elsif (cascade_data_ready'event and cascade_data_ready='1') then
      -- used only if cascaded.  Cascading has not been updated for NRZ and reloading
      if (anyX(new_f_data)) then
        data(channel_number)(1) <= (OTHERS => 'X');
      else
        data(channel_number)(1) <= new_f_data;
      end if;
      if NOT has_casc_r_in then
        for j in number_of_taps downto 2 loop
          data(channel_number)(j) <= data(channel_number)(j-1);
        end loop;
      else
        for j in midpoint downto 2 loop
          data(channel_number)(j) <= data(channel_number)(j-1);
        end loop;
        for j in number_of_taps downto midpoint+2 loop
          data(channel_number)(j) <= data(channel_number)(j-1);
        end loop;
        if (anyX(new_r_data)) then
          data(channel_number)(midpoint+1) <= (OTHERS => 'X');
        else
          data(channel_number)(midpoint+1) <= new_r_data;
        end if;
      end if;
      process_data <= '1';
      WAIT until (result_ready'event AND result_ready = '0') OR reloading = '1';
      process_data <= '0';
      WAIT for 0 ns;
    end if;
    if (reloading = '1') then
      for i in 0 to number_of_channels-1 loop
        for j in 1 to number_of_taps loop
          if (data_nrz) then
            data(i)(j) <= "01";
          else
            data(i)(j) <= (OTHERS => '0');
          end if;
        end loop;
      end loop;
      process_data <= '0';
      WAIT until reloading = '0';
    end if;
    wait on clk, data_ready, cascade_data_ready, reloading; 
  end process tap_storage;

--
-- Handle new data, and set up the output signals lrfd (the local version of RFD), and SEL_I
-- If reloading has started, then
--   set RFD to 0
--   Wait a cycle and set SEL_I to 0
--   Wait for reloading to be completed before waiting for new data again
-- If the ND signal is asserted, then
--   Update the input channel number and SEL_I
--   Assert data_ready so that tap_storage can store the new data.  Wait until process_data is 
--     cleared to indicate that the data has been processed.
--   Clear RFD and wait psc_latency cycles before asserting RFD again
--   For decimating filters, polyphase_factor samples must be read in before they are processed.
--     These filters have an external memory that can store the new samples while the subfilters
--     are processing the old samples.  Signals polyphase_internal_nd and polyphase_internal_rfd
--     are used to track when this memory is full.
-- 
  psc : PROCESS
  variable local_channel_number : integer := 0;
  variable sub_filter_number : integer := polyphase_factor-1;
  variable setup : boolean := TRUE;
  variable local_data: std_logic_vector(data_width-1 downto 0) := (OTHERS => '0');
  BEGIN
    if (setup) then
      lrfd <= '1';
      if (has_in_chan_indicator) then
        sel_i <= (OTHERS => '0');
      end if;
      setup := false;
    end if;
    if ( reloading = '0' ) then
      WAIT until ((clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1' AND 
         ((polyphase_internal_rfd = '0' AND (decimating_half_band OR decimating_filter)) OR (rat(nd)='1' and lrfd='1')))
         OR reloading ='1' );
    end if;
    if (reloading = '1') then
      lrfd <= '0';
      if (has_in_chan_indicator) then
        WAIT UNTIL clk'event AND rat(clk)='1' AND rat(clk'last_value)='0';
        sel_i <= (OTHERS => '0');
      end if;
      WAIT UNTIL reloading = '0';
      lrfd <= '1';
      local_channel_number := 0;
      channel_number <= 0;
      sub_filter_number := polyphase_factor-1;
      local_data := (OTHERS => '0');
      new_data <= (OTHERS => '0');
      polyphase_internal_nd <= '0';
    else
      if ((decimating_half_band OR decimating_filter) AND polyphase_internal_rfd = '0') then
        polyphase_internal_nd <= '0';
      end if;
      if (rat(nd)='1' and lrfd = '1') then
        channel_number <= local_channel_number;
        local_channel_number := (local_channel_number + 1) MOD number_of_channels;
        if (has_in_chan_indicator) then
          sel_i <= int_2_std_logic_vector(local_channel_number, chan_ind_width);
        end if;
        if NOT has_casc_f_in then
          local_data := din;
        end if;
        if (decimating_half_band OR decimating_filter) then
          sub_filter_number := (sub_filter_number + 1) MOD polyphase_factor;
          if (sub_filter_number = polyphase_factor-1) then
            if (polyphase_internal_rfd = '0') then
              lrfd <= '0';
              WAIT until polyphase_internal_rfd = '1' OR reloading = '1';
            end if;
            polyphase_internal_nd <= '1';
          else
            polyphase_internal_nd <= '0';
          end if;
        end if;
	if (reloading = '0') then
          new_data <= local_data;
          if NOT cascaded then
            data_ready <= '1';
            WAIT until (process_data'event AND process_data = '0') OR reloading = '1';
            data_ready <= '0';
          end if;
          if (psc_latency > 0 AND NOT (decimating_half_band OR decimating_filter)) then
            lrfd <= '0';
            for i in 1 to psc_latency loop
              WAIT until (clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1') OR reloading = '1';
              if (reloading = '1') then
                exit;
              end if;
            end loop;
          end if;
          lrfd <= '1' ;
        end if; -- reloading = '0'
      end if; -- rat(nd) = '1'
    end if; -- reloading = '1'
  end process psc;

--
-- Handle reloading.
--   When coef_ld is asserted, assert signal reloading, so that the rest of the model can handle
--     reloading.
--     Check that valid coefficients are provided on ld_din.
--     If coefficients are of type NRZ, convert from NRZ to signed
--     Save the coefficient in the coefficient array, and handle symmetry and negative symmetry
--     Once all the coefficients have been provided, wait for reload_delay cycles, before 
--       deasserting signal reload.  Reloading is now completed.
--
  reload: PROCESS

  constant num_coefs: integer := (eval(symmetric) * (orig_number_of_taps + 1)/2) + (eval(NOT symmetric) * orig_number_of_taps);  
  constant half_band: boolean := (filter_type = c_half_band OR filter_type = c_decimating_half_band OR filter_type = c_interpolating_half_band);
  variable posn: integer := 1;
  variable local_coef : std_logic_vector(local_coef_width-1 downto 0) := (OTHERS => '0');
  BEGIN
    if (NOT reloadable) then
      WAIT;
    else
      WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(coef_ld)='1';
      reloading <= '1';      
      posn := 1;
      for i in 1 to num_coefs loop
        WAIT UNTIL clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ld_we)='1';
        if (((filter_type = c_half_band) OR (filter_type = c_decimating_half_band) OR (filter_type = c_interpolating_half_band) ) AND (i MOD 2 = 0) AND (i < num_coefs)) then
          ASSERT (all0(ld_din)) report "Not a valid coefficient for a halfband filter : this coefficient must be zero." severity error;
        elsif ((filter_type = c_hilbert_transform) AND (i MOD 2 = 0)) then
          ASSERT (all0(ld_din)) report "Not a valid coefficient for a hilbert transform : this coefficient must be zero." severity error;
        end if;
        if (coef_nrz) then
          if (ld_din(0) = '0') then
            local_coef := "01";
          elsif (ld_din(0) = '1') then
            local_coef := "11";
          else
            local_coef := "XX";
          end if;
        else
          local_coef := ld_din;
        end if;
        filter_coefficients(posn) <= local_coef;
        if (response = c_symmetric) then
          filter_coefficients(number_of_taps-posn+1) <= local_coef;
        elsif (response = c_neg_symmetric AND (orig_number_of_taps MOD 2 = 0 OR posn < (number_of_taps+1)/2)) then
          filter_coefficients(number_of_taps-posn+1) <= two_comp(local_coef);
        end if;
        if (filter_type = c_interpolated_fir) then
          posn := posn+ zero_packing_factor;
        else
          posn := posn + 1;
        end if; 
      end loop;
      for i in 1 to reload_delay loop
        WAIT UNTIL clk'event AND rat(clk)='1' AND rat(clk'last_value)='0';
        ASSERT (rat(coef_ld)='0') report "COEF_LD should not be asserted when the filter is being reloaded" severity error;
        ASSERT (rat(ld_we)='0') report "LD_WE should not be asserted when the filter is being reloaded" severity error;
      end loop;
      reloading <= '0';
    end if;
  end process reload;
        
--
-- Model the subfilters for polyphase decimating and decimating halfband filters
--   Wait until polyphase_internal_nd is asserted.  This means that polyphase_factor samples have
--   been received.  Deassert polyphase_internal_rfd, so that polyphase_internal_nd cannot be 
--   asserted again, and wait psc_latency cycles before asserting polyphase_internal_rfd again.
--   If the filter is reloading new coefficients, deassert polyphase_internal_rfd, wait until
--   reloading is completed, and assert polyphase_internal_rfd again.
--
  polyphase_sub_filter: PROCESS
  BEGIN
    if (decimating_half_band OR decimating_filter) then
      WAIT until (clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1' AND polyphase_internal_nd='1') OR reloading = '1';
      if (reloading = '1') then
        polyphase_internal_rfd <= '0';
        WAIT UNTIL reloading = '0';
      elsif psc_latency > 0 then
        polyphase_internal_rfd <= '0';
        for i in 1 to psc_latency loop
          WAIT until (clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1') OR reloading='1';
          if (reloading = '1') then
            exit;
          end if;
        end loop;
      end if;
      polyphase_internal_rfd <= '1'; 
    else
      WAIT;
    end if;
  end process polyphase_sub_filter;

  delay_nd: PROCESS
  BEGIN
    if cascaded then
      delayed_nd1 <= (nd and lrfd) AFTER 0 ns;
      if NOT has_casc_f_in AND nd = '1' and lrfd = '1' then
        delayed_new_data <= din AFTER 0 ns;
      end if;
      WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1';
    else
      WAIT;
    end if;
  end process delay_nd;

  delay_nd1: PROCESS
  BEGIN
    if NOT pda AND cascaded then
      delayed_nd <= delayed_nd1 AFTER 0 ns;
      WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1';
    else
      WAIT;
    end if;
  end process delay_nd1;

-- Cascading has not been updated for reloading or for NRZ
  cascade_data_writer: PROCESS
  variable cycle_number: integer := 1;
  variable savout: std_logic_vector(extwidth-1 downto 0) := (OTHERS => '0');
  variable savrout: std_logic_vector(extwidth-1 downto 0) := (OTHERS => '0');
  constant midpoint: integer := (number_of_taps+1)/2;
  variable setup: boolean := true;
  variable first_stage: boolean := has_casc_f_out AND NOT has_casc_f_in;
  variable middle_stage: boolean := has_casc_f_in AND has_casc_f_out;
  BEGIN

    if cascaded then
    if setup then
      if has_casc_f_out then
        cas_f_out <= (OTHERS => '0');
      end if;
      if has_casc_r_out then
        cas_r_out <= (OTHERS => '0');
      end if; 
      setup := false;
    else
      -- wait until one cycle after ND is asserted
      if pda then
        WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1' AND rat(delayed_nd1)='1';  
      else
        WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1';
        if (rat(delayed_nd1) /= '1') then
          if has_casc_f_out then
            if symmetric then
              if number_of_taps = 2 then
                cas_f_out <= save_casc_f(baat-1 downto 0);
              else
                cas_f_out <= data(channel_number)(midpoint-1)(baat-1 downto 0);
              end if;
            else
              if number_of_taps = 1 then
                cas_f_out <= save_casc_f(baat-1 downto 0);
              else
                cas_f_out <= data(channel_number)(number_of_taps-1)(baat-1 downto 0);
              end if;
            end if;
          end if; -- has_casc_f_out
          if has_casc_r_out then
            if number_of_taps = 2 OR (middle_stage AND number_of_taps = 3) then
              cas_r_out <= save_casc_r(baat-1 downto 0);
            else
              cas_r_out <= data(channel_number)(number_of_taps-1)(baat-1 downto 0);
            end if;
          end if;
          WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1' AND rat(delayed_nd1)='1';  
        end if; -- delayed_nd1 \= '1'
        if has_casc_f_in OR has_casc_r_in then
          if cascade_input_read /= '1' then
            WAIT until cascade_input_read = '1';
          end if;
        end if;
      end if; -- pda
                
      -- It is now 1 cycle since ND was asserted
      if NOT has_casc_f_in then
        new_f_data <= delayed_new_data;
      elsif pda then
        new_f_data <= cas_f_in;
      else
        new_f_data <= save_casc_f(data_width-1 downto 0);
      end if;
      if has_casc_r_in then
        if pda then
          new_r_data <= cas_r_in;
        else
          new_r_data <= save_casc_r(data_width-1 downto 0);
        end if;
      end if;
      cascade_data_ready <= '1';
      WAIT until process_data'event AND process_data = '0'; -- data has been read and shifted
      cascade_data_ready <= '0';

      if has_casc_f_out OR has_casc_r_out then
        savrout := extend(data(channel_number)(number_of_taps), extwidth, data_signed);
        if (symmetric) then
          savout := extend(data(channel_number)(midpoint), extwidth, data_signed);
        else
          savout := savrout;
        end if;
        if has_casc_f_out then
          cas_f_out <= savout(baat-1 downto 0);
        end if;
        if has_casc_r_out then
          cas_r_out <= savrout(baat-1 downto 0);
        end if; 

        if cascade_num_cycles > 1 then
          FOR cycle_number in 2 to cascade_num_cycles loop
            WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1' ;
            if has_casc_f_out then
              cas_f_out <= savout(cycle_number*baat-1 downto (cycle_number-1)*baat);
            end if;
            if has_casc_r_out then
              cas_r_out <= savrout(cycle_number*baat-1 downto (cycle_number-1)*baat);
            end if;
          end loop;
        end if;
      end if; --has cascade outputs 
    end if; -- setup
    else
      WAIT;
    end if;
  end process cascade_data_writer;

-- Cascading has not been updated for reloading or for NRZ
  cascade_data_reader: PROCESS
  variable cycle_number: integer := 1;
  variable extdata: std_logic_vector(extwidth-1 downto 0) := (OTHERS => '0');
  variable extrdata: std_logic_vector(extwidth-1 downto 0) := (OTHERS => '0');
  constant midpoint: integer := (number_of_taps+1)/2;
  variable first_stage: boolean := has_casc_f_out AND NOT has_casc_f_in;
  BEGIN

    if (has_casc_f_in OR has_casc_r_in) AND NOT pda then
      -- Wait until 2 cycles after ND is asserted
      WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1' AND rat(delayed_nd)='1';  

      extdata := (OTHERS => '0');
      extrdata := (OTHERS => '0');
      if has_casc_f_in then
        extdata(baat-1 downto 0) := cas_f_in;
        save_casc_f <= extdata;
      end if;
      if has_casc_r_in then
        extrdata(baat-1 downto 0) := cas_r_in;
        save_casc_r <= extrdata;
      end if;
      if cascade_num_cycles > 1 then
      FOR cycle_number in 2 to cascade_num_cycles loop
        WAIT until clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='1' ;
        if has_casc_f_in then
          extdata(cycle_number*baat-1 downto (cycle_number-1)*baat) := cas_f_in;
          save_casc_f <= extdata;
        end if;
        if has_casc_r_in then
          extrdata(cycle_number*baat-1 downto (cycle_number-1)*baat) := cas_r_in;
          save_casc_r <= extrdata;
        end if;
      end loop;
      end if;
      cascade_input_read <= '1';
      WAIT until cascade_data_ready = '1';
      cascade_input_read <= '0';
    else
      WAIT;
    end if;
  end process cascade_data_reader;
    
--
-- Multiply accumulate
--   When process_data is asserted, compute the new result.
--   Assert result_ready so the new result may be saved
-- 
  mac: PROCESS
    variable local_result: std_logic_vector(full_result_width-1 downto 0) := (OTHERS => '0');
    variable ldata: std_logic_vector(data_width downto 0);
    variable coef: std_logic_vector(coef_width downto 0);
    variable product: std_logic_vector(data_width+1+coef_width+1-1 downto 0);
  
--
-- Multiply two std_logic_vectors - both must be the same width.  
-- Use bit-arithmetic if the result bitwidth is greater than 32
--
  FUNCTION "*"(a, b : std_logic_vector)
  RETURN std_logic_vector IS
    constant a_width : integer := a'LENGTH;
    constant b_width : integer := b'LENGTH;
    variable la: std_logic_vector(a_width-1 downto 0) := a;
    variable lb: std_logic_vector(b_width-1 downto 0) := b;
    variable product: std_logic_vector(a_width+b_width-1 downto 0);
    variable negative : boolean;
    variable a_value, b_value, prod_value: integer;
    variable index : integer;
    variable cin, value: std_logic;
  BEGIN
    if (anyX(la) or anyX(lb)) then
      product := setallX(a_width+b_width);
    elsif (all0(la) or all0(lb)) then
      product := (OTHERS => '0');
    elsif ( a_width + b_width < 32 ) then
      a_value := std_logic_vector_2_int(la);
      b_value := std_logic_vector_2_int(lb);
      prod_value := a_value * b_value; 
      product := int_2_std_logic_vector(prod_value,a_width+b_width);
    else
      negative := FALSE;
      if ( (la(a_width-1) xor lb(b_width-1)) = '1' ) then
        negative := TRUE;
      end if ;
      if (la(a_width-1) = '1') then
        la := two_comp(la);
      end if ; 
      if (lb(b_width-1) = '1') then
        lb := two_comp(lb);
      end if ; 
      product := (OTHERS => '0');
       for i in 0 to b_width -1 loop -- b width
        if (lb(i) = '1') then
          index := i;
          cin := '0';
          for j in 0 to a_width-1 loop  -- add a to prod 
            value := product(index) xor la(j) xor cin; -- sum
            cin := (product(index) and la(j)) or (product(index) and cin) or 
                         (la(j) and cin); -- carry
            product(index) := value;
            index := index + 1;
          end loop;
          product(index) := product(index) xor cin; -- last carry 
        else
          cin := '0';
        end if;        
      end loop;
      if (negative) then
        product := two_comp(product);
      end if;
    end if;
    return product;
  end "*";

--
-- Add two std_logic_vectors - both must be the same width
--
  function "+"(a,b : std_logic_vector)
    return std_logic_vector IS
    constant a_width: integer := a'LENGTH;
    constant b_width: integer := b'LENGTH;
    constant max_width: integer := eval(a_width >= b_width)*a_width + eval(b_width > a_width)*b_width;
    variable sa : std_logic_vector(max_width-1 downto 0) := extend(a, max_width);
    variable sb : std_logic_vector(max_width-1 downto 0) := extend(b, max_width);
    variable retval : std_logic_vector(max_width-1 downto 0);
    variable carry : std_logic := '0';
  BEGIN  -- plus
    IF (anyX(sa) OR anyX(sb)) THEN
      retval := (OTHERS => 'X');
    elsif (all0(sa)) THEN
      retval := sb;
    elsif (all0(sb)) THEN
      retval := sa;
    else
      FOR i IN 0 TO max_width-1 LOOP
        retval(i) := sa(i) XOR sb(i) XOR carry;
        carry := (sa(i) AND sb(i)) or
                 (sa(i) AND carry) or
	         (sb(i) AND carry);
      END LOOP;  -- i
    END IF;    
    RETURN retval;
  END "+";

-- 
-- Convert a std_logic_vector to the required width.
-- If the output width is greater than the vector width, then sign or zero extend it
-- If the output width is less than the vector width, and we are not saturating, then use
--   the least significant bits.  If saturating, and the vector has overflowed (or underflowed)
--   the output bit width, then return the largest positive or smallest negative number.  
-- Saturating is not supported in this release.
    function saturated_value(data: std_logic_vector;
    			     signed, saturate: boolean;
    			     data_width, out_width: integer)
      RETURN std_logic_vector IS
      variable result: std_logic_vector(out_width-1 downto 0);
      constant nOnes : std_logic_vector(out_width-2 downto 0) := (others=>'1');
    begin
      if (out_width > data_width) then
        result := extend(data, out_width, signed);
      elsif (out_width = data_width) then
        result := data;
      elsif (NOT saturate) then
        result := data(out_width-1 downto 0);
      else
        if (signed) then
          if ((data(out_width-1)='1' AND all1(data(data_width-1 downto out_width))) OR
              (data(out_width-1)='0' AND all0(data(data_width-1 downto out_width)))) then
             result := data(out_width-1 downto 0);
          elsif (data(data_width-1) = '1') then
            result := (OTHERS => '1');
          else
            --  NCVHDL fix 7/7/05
            --  result := ('0', OTHERS => '1');
            result := '0' & nOnes;
          end if;
        else -- unsigned
          if (any1(data(data_width-1 downto out_width))) then
            result := (OTHERS => '1');
          else
            result := data(out_width-1 downto 0);
          end if;
        end if;
      end if;
      return result;
    end saturated_value;

  BEGIN
    WAIT UNTIL process_data'event AND process_data = '1';
    local_result := (OTHERS => '0');
    for j in 1 to number_of_taps loop
      ldata := extend(data(channel_number)(j), data_width+1, data_signed);
      coef :=  extend(filter_coefficients(j), coef_width+1, coef_signed);
      product := ldata * coef;
      local_result := local_result + product;
    end loop;
    result <= saturated_value(local_result, data_signed OR coef_signed OR data_nrz OR coef_nrz, saturate, full_result_width, result_width);
    mid_value <= data(channel_number)(number_of_taps/2 + number_of_taps MOD 2)(data_width-1 downto 0);
    result_ready <= '1';
    WAIT UNTIL processed_result'event AND processed_result='1';
    result_ready <= '0';
  end process; --mac 

--
-- Store the computed results for latency cycles, and assign them to DOUT or DOUT_I and DOUT_Q at
-- this time.  The results are stored in a linked list, along with the number of cycles they
-- must be delayed.  This value is decremented every cycle.  When the value reaches zero, it 
-- is placed on an output port, and RDY asserted.
-- For interpolating filters, multiple results are generated from a single input sample.  This
-- process ensures that these results are output in subsequent cycles by incrementing the latency
-- for each consecutive result.
-- This process also tracks the output channel for multichannel filters, and sets SEL_O 
-- accordingly.
-- When the filter is reloading, the linked list is deleted. 
--
  delay_result: PROCESS
    function compute_latency(use_model_func: boolean;
    			     use_latency: integer ) return integer is

    variable latency: integer := 0;
    begin
      assert (NOT use_model_func) report "Currently the model does not compute the latency.  Parameter c_use_model_func MUST be set to 0. Please call Xilinx support." severity failure; 
      latency := use_latency;
      if (cascaded) then
        latency := latency - 1; -- for cascaded DAs the input data is delayed by one cycle
      end if;
      latency := latency - 1;  -- because the model doesn't count the first rising edge
      return latency;
    end compute_latency;

    constant latency: integer := compute_latency( use_model_func, use_latency);
    type output_record;
    type output_ptr is access output_record;
    type output_record is
      record
        result: std_logic_vector(result_width-1 downto 0);
        mid_result: std_logic_vector(data_width-1 downto 0);
        channel_number: integer;
        cycles_left: integer;
        nxt: output_ptr;
      end record;
    variable list_head: output_ptr := NULL;
    variable elem: output_ptr := NULL;
    variable setup: boolean := true;
    variable old_bin_chan_num: std_logic_vector(chan_ind_width-1 downto 0) := (OTHERS => '0');
    variable bin_chan_num: std_logic_vector(chan_ind_width-1 downto 0) := (OTHERS => '0');
    variable head_latency, local_latency: integer;

    procedure add_element_to_list(result: std_logic_vector(result_width-1 downto 0);
    				  mid_result: std_logic_vector(data_width-1 downto 0);
    				  channel_number, cycles_left: integer;
    				  variable list_head: inout output_ptr) IS
      variable elem: output_ptr;
    begin
      elem := NEW output_record;
      elem.result := result;
      elem.mid_result := mid_result;
      elem.channel_number := channel_number;
      elem.cycles_left := cycles_left;
      elem.nxt := list_head;
      list_head := elem;    
    end add_element_to_list;

    procedure make_list_elements_unknown(variable list_head: output_ptr) IS
      variable elem: output_ptr := list_head;
    begin
     while (elem /= NULL) loop
        elem.result := (OTHERS => 'X');
        elem.mid_result := (OTHERS => 'X');
        elem := elem.nxt;
      end loop;
    end make_list_elements_unknown;

    procedure decrement_cycles_left(variable list_head: inout output_ptr;
                                    variable ret_elem: out output_ptr) IS
      variable prv_elem: output_ptr := NULL;
      variable elem: output_ptr := list_head;
    BEGIN
      ret_elem := NULL;
      while (elem /= NULL) loop
        elem.cycles_left := elem.cycles_left-1;
        if (elem.cycles_left = 0) then
          ret_elem := elem;
          elem := prv_elem;  -- the deallocated elem will always be the last element in the list
          if (elem = NULL) then
            list_head := NULL;
          else
            elem.nxt := NULL;
            elem := elem.nxt;
          end if;
        else
          prv_elem := elem;
          elem := elem.nxt;
        end if;
      end loop;
    end decrement_cycles_left;

    procedure remove_all_elements_from_list(variable list_head: inout output_ptr) IS
      variable next_elem: output_ptr := NULL;
    begin
      while (list_head /= NULL) loop
        next_elem := list_head;
        list_head := list_head.nxt;
        deallocate(next_elem);
      end loop;
    end remove_all_elements_from_list;

    procedure get_head_latency(variable list_head: in output_ptr;
                               variable head_latency: out integer) is
    begin
      if (list_head = NULL) then
        head_latency := 0;
      else
        head_latency := list_head.cycles_left;
      end if;
    end get_head_latency;
 
  BEGIN
    if (setup = TRUE) then
      rdy <= '0';
      if (has_out_chan_indicator) then
        sel_o <= (OTHERS => '0');
      end if;
      if (has_registered_output) then
        if (hilbert_transform) then
          dout_q <= (OTHERS => '0');
          dout_i <= (OTHERS => '0');
        else
          dout <= (OTHERS => '0');
        end if;
      end if;
      setup := false;
    elsif ((clk'event AND rat(clk) = 'X' AND rat(ce) /= '0' AND rat(clk'LAST_VALUE)/='X') OR
           (clk'event AND rat(clk)='1' AND rat(clk'last_value)='0' AND rat(ce)='X')) then
      make_list_elements_unknown(list_head);
    elsif (clk'event AND rat(clk) = '1' and rat(clk'last_value)='0' and rat(ce)='1') then 
      decrement_cycles_left(list_head, elem);
      if (elem /= NULL) then
        if (has_out_chan_indicator) then
          bin_chan_num := int_2_std_logic_vector((elem.channel_number+1)MOD number_of_channels, chan_ind_width); 
        end if;
        if (coef_ld = '0') then
          if (hilbert_transform) then
            dout_i <= elem.mid_result AFTER 0 ns;
            dout_q <= elem.result AFTER 0 ns;
          else
            dout <= elem.result AFTER 0 ns;
          end if;
          rdy <= '1' AFTER 0 ns;
        end if;
        deallocate(elem);
      else
        rdy <= '0' AFTER 0 ns;
        if (NOT has_registered_output) then
          if (hilbert_transform) then
            dout_q <= (OTHERS => 'X') AFTER 0 ns;
            dout_i <= (OTHERS => 'X') AFTER 0 ns;
          else
            dout <= (OTHERS => 'X') AFTER 0 ns;
          end if;
        end if;
      end if;
      if (has_out_chan_indicator) then
        sel_o <= old_bin_chan_num AFTER 0 ns;
        old_bin_chan_num := bin_chan_num;
      end if;
    elsif (result_ready'event AND result_ready = '1') then
      get_head_latency(list_head, head_latency);
      if (head_latency >= latency) then
        local_latency := head_latency+1;
      else
        local_latency := latency;
      end if;
      add_element_to_list(result, mid_value, channel_number, local_latency, list_head);
      processed_result <= '1';
      WAIT FOR 0 ns;
      processed_result <= '0';
    end if;
    if (reloading'event AND reloading = '1') then 
      remove_all_elements_from_list(list_head);
      if (NOT has_registered_output) then
        if (hilbert_transform) then
          dout_q <= (OTHERS => 'X');
          dout_i <= (OTHERS => 'X');
        else
          dout <= (OTHERS => 'X');
        end if;
      else
        if (hilbert_transform) then
          dout_q <= (OTHERS => '0');
          dout_i <= (OTHERS => '0');
        else
          dout <= (OTHERS => '0');
        end if;
      end if;
      rdy <= '0';
      if (has_out_chan_indicator) then
        WAIT UNTIL clk'event AND rat(clk)='1' AND rat(clk'last_value)='0';
        sel_o <= (OTHERS => '0');
        bin_chan_num := (OTHERS => '0');
        old_bin_chan_num := (OTHERS => '0');
      end if;
      WAIT UNTIL reloading = '0';
    end if; 
    WAIT ON clk, result_ready, reloading;
  end process;
          
END behavioral;


