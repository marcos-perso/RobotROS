LIBRARY ieee;  
USE ieee.std_logic_1164.ALL;
--USE ieee.STD_LOGIC_UNSIGNED.ALL;

LIBRARY xilinxcorelib;
USE xilinxcorelib.ul_utils.ALL;
USE xilinxcorelib.iputils_std_logic_unsigned.ALL;

USE XilinxCoreLib.da_1d_dct_v2_1_comp.ALL;
USE XilinxCoreLib.da_2d_dct_pack_v2_0.ALL;

LIBRARY std;
USE std.TEXTIO.ALL;

ENTITY c_da_2d_dct_v2_0 IS
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
  PORT(din  : IN  std_logic_vector((c_data_width -1) DOWNTO 0):= (others => '0'); 
       dout : OUT std_logic_vector((get_sat_resultwidth(c_operation, 8, c_data_width, c_data_type, 
			                                    c_internal_width, c_result_width, c_coeff_width, c_precision_control) - 1) DOWNTO 0) := (others => '0');
       nd   : IN  std_logic := '0';
       rfd  : OUT std_logic := '0';
       rdy  : OUT std_logic := '0';
       clk  : IN  std_logic;
       rst  : IN  std_logic := '0');
END c_da_2d_dct_v2_0;

ARCHITECTURE behavioral OF c_da_2d_dct_v2_0 IS

  CONSTANT c_points           : INTEGER := 8;
  CONSTANT operation          : INTEGER := effective_operation(c_operation);

  CONSTANT internal_data_type : INTEGER := SIGNED_VALUE;
  CONSTANT sat_internal_width     : INTEGER := get_sat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control);
  CONSTANT unsat_internal_width     : INTEGER := get_unsat_internalwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_coeff_width,c_precision_control);
  CONSTANT sat_result_width       : INTEGER := get_sat_resultwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_result_width, c_coeff_width, c_precision_control);
  CONSTANT unsat_result_width       : INTEGER := get_unsat_resultwidth(c_operation, c_points, c_data_width, c_data_type, c_internal_width, c_result_width, c_coeff_width, c_precision_control);

  SIGNAL rowdin       : STD_LOGIC_VECTOR ( (c_data_width -1) DOWNTO 0) := (others => '0');
  SIGNAL rowdout      : STD_LOGIC_VECTOR ((unsat_internal_width - 1) DOWNTO 0) := (others => '0');
  SIGNAL rownd        : STD_LOGIC := '0';
  SIGNAL rowrfd       : STD_LOGIC := '0';
  SIGNAL rowrdy       : STD_LOGIC := '0';
  SIGNAL columndin    : STD_LOGIC_VECTOR ( (sat_internal_width - 1) DOWNTO 0) := (others => '0');
  SIGNAL columndout   : STD_LOGIC_VECTOR ( (unsat_result_width - 1)DOWNTO 0) := (others => '0');
  SIGNAL columnnd     : STD_LOGIC := '0'; 
  SIGNAL columnrfd    : STD_LOGIC := '0';
  SIGNAL columnrdy    : STD_LOGIC := '0';

  -- signals for saturation logic for IEEE1180 case
  SIGNAL memory_input_from_rowdout : STD_LOGIC_VECTOR ((sat_internal_width - 1) DOWNTO 0) := (others => '0');
  SIGNAL saturated_rowdout     : STD_LOGIC_VECTOR ((sat_internal_width - 1) DOWNTO 0) := (others => '0');
  SIGNAL saturated_columndout  : STD_LOGIC_VECTOR ((sat_result_width - 1) DOWNTO 0) := (others => '0');
  SIGNAL saturated_columnrdy   : STD_LOGIC := '0';

  TYPE   doutArray IS ARRAY( 0 TO (2*c_points*c_points -1) ) OF std_logic_vector( (sat_internal_width - 1) DOWNTO 0 );
  SIGNAL internal_reg: doutArray := (others => (others => '0'));

  signal goingFull, finishedBin, internalreaddata : std_logic := '0';
  signal waitforBinFull : std_logic := '1';

  signal write_counter : std_logic_vector((bitsNeededToRepresent((2 * c_points * c_points) - 1) -1) downto 0) := (others => '0');
  signal read_counter : std_logic_vector((bitsNeededToRepresent((2 * c_points * c_points) - 1) - 1) downto 0) := (others => '0');
  --signal transpose_counter : std_logic_vector((bitsNeededToRepresent((2 * c_points * c_points) - 1) - 1) downto 0) := (others => '0');

  COMPONENT c_da_1d_dct_v2_1
  GENERIC( c_operation        : INTEGER; 
           c_data_width       : INTEGER;
           c_data_type        : INTEGER;
           c_coeff_width      : INTEGER;
           c_points           : INTEGER;
           c_clks_per_sample  : INTEGER; -- not needed for model
           c_precision_control: INTEGER;
           c_result_width     : INTEGER;
           c_latency          : INTEGER;
           c_shape            : INTEGER; -- not needed for model
           c_enable_symmetry  : INTEGER;
           c_has_reset        : INTEGER; -- no reset
           c_enable_rlocs     : INTEGER -- not needed for model
         );
  PORT(din  : IN   std_logic_vector((c_data_width -1) DOWNTO 0); 
       dout : OUT std_logic_vector( (c_result_width - 1) DOWNTO 0);
       nd   : IN  std_logic;
       rfd  : OUT std_logic;
       rdy  : OUT  std_logic;
       clk  : IN   std_logic;
       rst  : IN  std_logic);
  END COMPONENT;

    
BEGIN

  row_dct : c_da_1d_dct_v2_1
    generic map (c_operation => operation, c_data_width => c_data_width,
                 c_data_type => c_data_type, c_coeff_width => c_coeff_width,
                 c_points => c_points, c_clks_per_sample => c_clks_per_sample,
                 c_precision_control => c_precision_control, 
                 c_result_width => unsat_internal_width, c_latency => c_row_latency,
                 c_shape => 0, c_enable_symmetry => c_enable_symmetry,
                 c_has_reset => c_has_reset, c_enable_rlocs => 0)
    port map (din => rowdin, dout => rowdout, nd => rownd,
              rfd => rowrfd, rdy => rowrdy, clk => clk,
              rst => rst );

  column_dct : c_da_1d_dct_v2_1
    generic map (c_operation => operation, c_data_width => sat_internal_width,
                 c_data_type => internal_data_type, c_coeff_width => c_coeff_width,
                 c_points => c_points, c_clks_per_sample => c_clks_per_sample,
                 c_precision_control => c_precision_control, 
                 c_result_width => unsat_result_width, c_latency => c_col_latency,
                 c_shape => 0, c_enable_symmetry => c_enable_symmetry,
                 c_has_reset => c_has_reset, c_enable_rlocs => 0)
    port map (din => columndin, dout => columndout, nd => columnnd,
              rfd => columnrfd, rdy => columnrdy, clk => clk,
              rst => rst );

  rfd_process : process(rowrfd)
  begin
    rfd    <= rowrfd;
  end process;

  feed_row_inputs : process(din, nd)
  begin
    rowdin <= din;
    rownd  <= nd;
  end process;

  -- the saturation logic to be applied for the IEEE case
	-- row outputs are not registered
	-- col outputs are registered, and hence RDY is also registered.
  saturation_logic : process(clk,columndout,rowdout,columnrdy,rowrdy)
	begin
	  if(c_operation = IEEE1180_IDCT ) then
	    if clk'event and clk = '1' then
		    if c_has_reset = 1 and rst = '1' then
			    saturated_columndout <= (others => '0');
				  saturated_columnrdy <= '0';
			  else
			    saturated_columndout <= saturate_logic(columndout,UNSATURATED_RESULT_WIDTH,sat_result_width);
				  saturated_columnrdy <= columnrdy ;
			  end if;
		  end if;
		  saturated_rowdout <= saturate_logic(rowdout,UNSATURATED_INTERNAL_WIDTH,sat_internal_width);
		end if;
	end process;

  -- the col outputs are saturated for IEEE case. and since it is registered,
	-- columnrdy also has to be registered.
  column_outputs: process(columndout,columnrdy,saturated_columndout, saturated_columnrdy)
  begin
	  if(c_operation = IEEE1180_IDCT) then
			dout <= saturated_columndout;
      rdy  <= saturated_columnrdy;
		else
		  dout <= columndout;
      rdy  <= columnrdy;
		end if;
  end process;
 
  -- the row outputs are saturated for IEEE case. However they are not
	-- registered and hence no delays.
  row_outputs : process(clk,rowdout,saturated_rowdout)
	begin
    if(c_operation = IEEE1180_IDCT) then
		  memory_input_from_rowdout <= saturated_rowdout;
		else
		  memory_input_from_rowdout <= rowdout;
		end if;

	end process;
 
  write_memory: process(clk,rst)
  
  --variable write_counter : std_logic_vector((bitsNeededToRepresent((2 * c_points * c_points) - 1) -1) downto 0) := (others => '0');

  begin
    
    if(clk'event and clk='1') then
      if(c_has_reset = 1 and rst = '1') then
        --write_counter := (others => '0');
        write_counter <= (others => '0');
      elsif (rowrdy = '1') then
        internal_reg(slv_to_unsigned_int(write_counter)) <= memory_input_from_rowdout;
        --write_counter := write_counter + '1';
        write_counter <= write_counter + '1';

       -- if(write_counter((write_counter'length - 2) downto 0) = "111111") then
       --   goingFull <= '1';
       -- end if;
      end if;
    end if;
  end process;
  
  going_full_process :process(write_counter, rowrdy)
  begin
    goingFull <= write_counter(0) AND write_counter(1) AND write_counter(2) AND write_counter(3) AND write_counter(4) AND write_counter(5) AND rowrdy;
  end process;

  read_memory: process(clk,rst)
  
  --variable read_counter : std_logic_vector((bitsNeededToRepresent((2 * c_points * c_points) - 1) - 1) downto 0) := (others => '0');
  variable transpose_counter : std_logic_vector((bitsNeededToRepresent((2 * c_points * c_points) - 1) - 1) downto 0) := (others => '0');
  variable clks_counter : std_logic_vector((bitsNeededToRepresent(c_clks_per_sample - 1) - 1) downto 0) := (others => '0');

  begin
    
    if(clk'event and clk='1') then
      if(c_has_reset = 1 and rst = '1') then
        read_counter <= (others => '0');
        transpose_counter := (others => '0');
				clks_counter := (others => '0');
				columnnd <= '0';
      else
			--if(((columnrfd = '1') and (internalreaddata = '1')) or(c_points > c_clks_per_sample))then
			  if ((clks_counter < "01000")  or (c_points >= c_clks_per_sample)) and (internalreaddata = '1') then
          transpose_counter := (read_counter(6) & read_counter(2 downto 0) & read_counter(5 downto 3)); 
          columndin <= internal_reg(slv_to_unsigned_int(transpose_counter)) after 1 ns;
          columnnd <= '1' after 1 ns;
          read_counter <= read_counter + '1';

         -- if(read_counter((read_counter'length - 2) downto 0) = "111111") then
         --   finishedBin <= '1';
         -- end if;

        elsif ((internalreaddata = '0') and (c_points > c_clks_per_sample)) or (clks_counter >= c_points) then
        --elsif(clks_counter >= c_points) then
          columnnd <= '0';
        end if;
			  if((clks_counter = (c_clks_per_sample - 1)) or (internalreaddata = '0')) then
				  clks_counter := (others => '0');
				else
				  if(internalreaddata = '1') then 
					  clks_counter := clks_counter + 1;
					end if;
				end if;

			end if;
    end if;
  end process;

  finishedBin_process :process(read_counter)
  begin
    finishedBin <= read_counter(0) AND read_counter(1) AND read_counter(2) AND read_counter(3) AND read_counter(4) AND read_counter(5);
  end process;


  memory_controls : process(clk, rst, finishedBin,internalreaddata,goingFull,waitforbinFull)
  begin

    if(clk'event and clk='1') then
      if(c_has_reset = 1 and rst = '1') then
        waitforBinFull <= '1';
        internalreaddata <= '0';
      else
        --waitforBinFull generation
        if(finishedBin = '1' and goingFull = '0' and internalreaddata = '1') then
        --if(finishedBin = '1' and internalreaddata = '1') then
          waitforBinFull <= '1';
        elsif(goingFull = '0' and waitforBinFull = '1') then
          waitforBinFull <= '1';
        else
          waitforBinFull <= '0';
        end if;
        
        -- internalreaddata generation
        if((goingFull = '1' and waitforBinFull = '1') or 
           (goingFull = '1' and finishedBin = '1' and internalreaddata = '1')) then
          internalreaddata <= '1';
        elsif (finishedBin = '0' and internalreaddata = '1') then
          internalreaddata <= '1';
        else
          internalreaddata <= '0';
        end if;

      end if;

    end if;

  end process;

END behavioral ;

