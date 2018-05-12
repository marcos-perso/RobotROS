---------------------------------------------------------------------------
--  $Id: sync_fifo_v3_0.vhd,v 1.1 2010-07-10 21:43:23 mmartinez Exp $ 
--------------------------------------------------------------------------------
--  Synchronous FIFO : VHDL Behavioral Model
--------------------------------------------------------------------------------
--
-- This File is owned and controlled by Xilinx and must be used solely
-- for design, simulation, implementation and creation of design files
-- limited to Xilinx devices or technologies. Use with non-Xilinx
-- devices or technologies is expressly prohibited and immediately
-- terminates your license.
--
-- Xilinx products are not intended for use in life support
-- appliances, devices, or systems. Use in such applications is
-- expressly prohibited.
--
--
--        ****************************
--        ** Copyright Xilinx, Inc. **
--        ** All rights reserved.   **
--        ****************************
--
---------------------------------------------------------------------------
--  Filename      : sync_fifo_v3_0.vhd                                   --
--                                                                       --
--  Description : Synchronous FIFO behavioral model                      --
--                                                                       --
--  
--  History : 
--                            9/8/00   First Version
--                            9/12/00  Add ram model
--                            9/14/00  Change DATA_COUNT assignment . When
--                                     FULL is asserted DATA_COUNT wil become
--                                     all 1's .
--                            9/15/00  Modification to DATA_COUNT selection
--                            9/18/00  Initialize outputs
--                            9/24/00  Initialize memory outputs
--                            9/25/00  Remove ieee.std_logic_unsigned library
--                                     and rewrite the code for the counters
--                                     to work without this library
--                            10/27/00 Add Xilinx Header
--                            11/30/00 Rename to sync_fifo_v2_0
--                            06/08/01 Rename to sync_fifo_v3_0
---------------------------------------------------------------------------
library ieee;
USE ieee.std_logic_1164.all;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.sync_fifo_pkg_v3_0.all;


entity sync_fifo_v3_0 is
    generic ( 
              c_dcount_width       :    integer := 1;   
              c_enable_rlocs       :    integer := 0;  
              c_has_dcount         :    integer := 0 ;
              c_has_rd_ack         :    integer := 0 ;
              c_has_rd_err         :    integer := 0 ;
              c_has_wr_ack         :    integer := 0 ;
              c_has_wr_err         :    integer := 0 ;
              c_memory_type        :    integer := 0 ;
              c_ports_differ       :    integer := 0 ;
              c_rd_ack_low         :    integer := 0 ;
              c_read_data_width    :    integer := 0 ;
              c_read_depth         :    integer := 16 ;
              c_rd_err_low         :    integer := 0 ;
              c_wr_ack_low         :    integer := 0 ;
              c_wr_err_low         :    integer := 0 ;
              c_write_data_width   :    integer := 0 ;
              c_write_depth        :    integer := 16 
              );
    port (  CLK          : in std_logic;
            SINIT        : in std_logic;
            DIN          : in  std_logic_vector(c_write_data_width-1 downto 0);
            WR_EN        : in std_logic;
            RD_EN        : in  std_logic;
            DOUT         : out std_logic_vector(c_read_data_width-1 downto 0);
            FULL         : out std_logic;
            EMPTY        : out std_logic;
            RD_ACK       : out std_logic;
            WR_ACK       : out std_logic;
            RD_ERR       : out std_logic;
            WR_ERR       : out std_logic;
            DATA_COUNT   : out std_logic_vector(c_dcount_width-1 downto 0) 
           );
end sync_fifo_v3_0;

architecture behavioral of sync_fifo_v3_0 is

 constant one        : integer := 1 ;
 constant addr_max   : integer := log2roundup(c_write_depth) ;
 constant addr_max_plus1 : integer:= addr_max + 1 ;
 constant addr_gnd_bus           :     std_logic_vector(addr_max downto 0) := (others => '0');
 constant max_cnt : std_logic_vector(addr_max downto 0) := '1' & addr_gnd_bus(addr_max-1 downto 0);
 constant max_cnt_integer : integer :=  std_logic_vector_2_posint(max_cnt) ;
 constant max_cnt_minus1_int : integer:= max_cnt_integer - one ;
 constant max_cnt_minus1: std_logic_vector(addr_max downto 0) := int_2_std_logic_vector(max_cnt_minus1_int, addr_max_plus1);
 constant one_std1  : std_logic_vector(addr_max-1 downto 0) := int_2_std_logic_vector(one, addr_max) ;
 constant one_std2  : std_logic_vector(addr_max downto 0)  := int_2_std_logic_vector(one, addr_max_plus1) ;
 -- signal read_addr_integer : integer ;
 -- signal write_addr_integer : integer ;
 -- signal fcounter_integer : integer ; 


 signal rd_ack_internal             :     std_logic ;
 signal rd_err_internal             :     std_logic ;
 signal wr_ack_internal             :     std_logic ;
 signal wr_err_internal             :     std_logic ;
 signal rd_ack_out                  :     std_logic ;
 signal rd_err_out                  :     std_logic ;
 signal wr_ack_out                  :     std_logic ;
 signal wr_err_out                  :     std_logic ;
 signal sinit_internal         :     std_logic ;
                                                                                                                                               
 signal fullreg                :     std_logic;
 signal emptyreg               :     std_logic;
 signal read_addr              :     std_logic_vector(addr_max-1 downto 0) := (others => '0');
 signal write_addr             :     std_logic_vector(addr_max-1 downto 0) := (others => '0');
 signal fcounter               :     std_logic_vector(addr_max downto 0) := (others => '0');
 signal fcounter_max           :     std_logic_vector(addr_max downto 0) := (others => '0');
 signal read_allow             :     std_logic;
 signal write_allow            :     std_logic;
 signal gnd                    :     std_logic  := '0';
 signal gnd_bus                :     std_logic_vector(c_write_data_width-1 downto 0) := (others => '0');
 signal pwr_bus                :     std_logic_vector(c_write_data_width-1 downto 0) := (others => '1');
 -- signal addr_gnd_bus           :     std_logic_vector(addr_max downto 0) := (others => '0');
 signal pwr                    :     std_logic  := '1';
 -- signal max_cnt                :     std_logic_vector(addr_max downto 0);
 signal memory_data_out        :     std_logic_vector(c_read_data_width-1 downto 0);
 signal memory_data_in         :     std_logic_vector(c_write_data_width-1 downto 0);

 subtype word is std_logic_vector (c_write_data_width-1 downto 0) ;
 type memory_array is array (0 to c_write_depth-1) of word ;
 
 signal ram : memory_array ;

  

BEGIN   --- architecture




    FULL         <= fullreg;
    EMPTY        <= emptyreg;
    DOUT         <= memory_data_out ;
    memory_data_in <=  DIN  ;
    sinit_internal <=  SINIT ;


    read_allow      <= (RD_EN and not emptyreg);
    write_allow     <= (WR_EN and not fullreg);

 --   addr_gnd_bus <= (others => '0');
 --   max_cnt      <= '1' & addr_gnd_bus(addr_max-1 downto 0);
    gnd_bus      <= (others => '0');
    pwr_bus      <= (others => '1');
    gnd          <= '0';
    pwr          <= '1';


-------------------------------------------------------------------------
--       Handshaking Logic                                             --
-------------------------------------------------------------------------

rd_ack_1 : if (c_rd_ack_low = 0) generate
    rd_ack_out <=  rd_ack_internal ;
end generate ;
rd_ack_0 : if (c_rd_ack_low = 1) generate 
    rd_ack_out <=  not rd_ack_internal ;
end generate ;


wr_ack_1 : if (c_wr_ack_low = 0) generate
    wr_ack_out <=  wr_ack_internal ;
end generate ;
wr_ack_0 : if (c_wr_ack_low = 1) generate
    wr_ack_out <=  not wr_ack_internal ;
end generate ;

rd_err_1 : if (c_rd_err_low = 0) generate
    rd_err_out <=  rd_err_internal ;
end generate ;
rd_err_0 : if (c_rd_err_low = 1) generate
    rd_err_out <=  not rd_err_internal ;
end generate ;

wr_err_1 : if (c_wr_err_low = 0) generate
    wr_err_out <=  wr_err_internal ;
end generate ;
wr_err_0 : if (c_wr_err_low = 1) generate
    wr_err_out <=  not wr_err_internal ;
end generate ;

dcount_0 : if (c_has_dcount = 1) and (c_dcount_width <= addr_max) generate
    DATA_COUNT <=  fcounter_max(addr_max-1 downto (addr_max - c_dcount_width)) ;
end generate ;
dcount_1 : if (c_has_dcount =1) and (c_dcount_width = addr_max + 1) generate
    DATA_COUNT <= fcounter ;
end generate ;

-- dcount_process : process (DATA_COUNT_int)
-- begin
--  if (c_has_dcount = 1 ) then
--     DATA_COUNT <= DATA_COUNT_int ;
--  end if ;
-- end process dcount_process ;


rd_ack_process : process (rd_ack_out)
begin
   if (c_has_rd_ack = 1 ) then
      RD_ACK <= rd_ack_out ;
   -- else
   --    RD_ACK <= '1' ;
   end if ;
end process rd_ack_process ;

wr_ack_process : process (wr_ack_out) 
begin 
   if (c_has_wr_ack = 1 ) then 
      WR_ACK <= wr_ack_out ;
  --  else 
  --    WR_ACK <= '1' ;
   end if ; 
end process wr_ack_process ;

rd_err_process : process (rd_err_out)  
begin    
   if (c_has_rd_err = 1 ) then  
      RD_ERR <= rd_err_out ;
  --  else  
  --     RD_ERR <= '0' ;
   end if ;  
end process rd_err_process ;

wr_err_process : process (wr_err_out)   
begin     
   if (c_has_wr_err = 1 ) then   
      WR_ERR <= wr_err_out ; 
  -- else   
  --    WR_ERR <= '0' ; 
   end if ;      
end process wr_err_process ;

rd_ack_logic : process (CLK )
 variable first_time : boolean := TRUE ;
begin
  if (first_time = TRUE) then
     rd_ack_internal <= '0' ;
     first_time := FALSE ;
  else 
     if ( CLK'event and CLK = '1') then
              if (SINIT = '1') then
                  rd_ack_internal <= '0' ;
              else
                  rd_ack_internal <= RD_EN and not emptyreg ;
              end if;
     end if ;
   end if ;
end process rd_ack_logic ;

wr_ack_logic : process (CLK )
 variable first_time : boolean := TRUE ; 
begin
  if (first_time = TRUE) then
     wr_ack_internal <= '0' ;
     first_time := FALSE ;
  else  
     if ( CLK'event and CLK = '1') then 
              if (SINIT = '1') then 
                  wr_ack_internal <= '0' ; 
              else 
                  wr_ack_internal <= WR_EN and not fullreg ; 
              end if;
     end if ;
   end if ; 
end process wr_ack_logic ;

rd_err_logic : process (CLK )
 variable first_time : boolean := TRUE ;
begin
  if (first_time = TRUE ) then
     rd_err_internal <= '0' ;
     first_time := FALSE ;
  else   
     if ( CLK'event and CLK = '1') then  
              if (SINIT = '1') then  
                  rd_err_internal <= '0' ;  
              else  
                  rd_err_internal <= RD_EN and emptyreg ; 
              end if;
     end if ;
   end if ; 
end process rd_err_logic ;


wr_err_logic : process (CLK )
 variable first_time : boolean := TRUE ;
begin
  if (first_time = TRUE ) then
     wr_err_internal <= '0' ;
     first_time := FALSE ;
  else    
     if ( CLK'event and CLK = '1') then   
              if (SINIT = '1') then   
                  wr_err_internal <= '0' ;   
              else     
                  wr_err_internal <= WR_EN and fullreg ; 
              end if;
     end if ;
   end if ; 
end process wr_err_logic ;

fcounter_max_proc : process (fcounter)
begin
     for N in addr_max downto 0 loop
         fcounter_max(N) <= fcounter(addr_max) or fcounter(N) ;
     end loop ;
end process fcounter_max_proc ;  

 
 


    

---------------------------------------------------------------
--                                                           --
--  Empty flag is set on reset (initial), or when on the     --
--  next clock cycle, Write Enable is low, and either the    --
--  FIFOcount is equal to 0, or it is equal to 1 and Read    --
--  Enable is high (about to go Empty).                      --
--                                                           --
---------------------------------------------------------------

    empty_proc : process (CLK)
       variable first_time : boolean := TRUE ;
    begin
     if (first_time = TRUE ) then
        emptyreg <= '1' ;
        first_time := FALSE ;
     else
        if (CLK'event and CLK = '1') then
            if sinit_internal = '1' then
                emptyreg <= '1';
            elsif ((fcounter(addr_max downto 1) = addr_gnd_bus(addr_max downto 1)) and
                   (WR_EN = '0') and
                   ((fcounter(0) = '0') or (RD_EN = '1'))) then
                emptyreg <= '1';
            else
                emptyreg <= '0';
            end if;
        end if;
      end if ;
    end process empty_proc;

---------------------------------------------------------------
--                                                           --
--  Full flag is cleared on reset .                          --
---------------------------------------------------------------
    full_proc:  process (CLK)
      variable  first_time: boolean := TRUE ;
    begin
     if (first_time = TRUE ) then
        fullreg <= '0' ;
        first_time := FALSE ;
     else
       if (CLK'event and CLK = '1') then
            if sinit_internal = '1' then
                fullreg <= '0';
            elsif (((fcounter = max_cnt) and
                    (RD_EN = '0')) or
                   ((fcounter = max_cnt_minus1 ) and
                    ((WR_EN = '1') and (RD_EN = '0')))) then
                fullreg <= '1';
            else
                fullreg <= '0';
            end if;
        end if;
      end if ;
    end process  full_proc;

    
----------------------------------------------------------------
--                                                            --
--  Generation of address pointers.                           --
----------------------------------------------------------------

 read_counter: process (CLK)
   variable read_addr_integer: integer ;
 begin  
            if (CLK'event and CLK = '1') then  
                if sinit_internal = '1' then
                    read_addr_integer  := 0;
                elsif (read_allow = '1') then
                    if ( read_addr_integer = c_write_depth-1 ) then 
                       read_addr_integer := 0 ;
                    else 
                       read_addr_integer := read_addr_integer + 1 ;
                    end if ;
                end if;
                read_addr <= int_2_std_logic_vector(read_addr_integer, addr_max) ;
            end if;
  end process read_counter ;

 write_counter: process (CLK)
    variable write_addr_integer : integer ; 
 begin  -- process 
            if CLK'event and CLK = '1' then  -- rising clock edge 
                if sinit_internal = '1' then 
                    write_addr_integer   := 0; 
                elsif (write_allow = '1') then 
                    if ( write_addr_integer = c_write_depth-1 ) then  
                       write_addr_integer :=  0 ; 
                    else   
                       write_addr_integer := write_addr_integer + 1 ;
                    end if ; 
                end if;
                write_addr <=  int_2_std_logic_vector(write_addr_integer, addr_max) ;   
            end if;   
  end process write_counter ; 

    

   
----------------------------------------------------------------
--                                                            --
--  Generation of FIFOcount.  Used to determine how           --
--  full FIFO is, based on a counter that keeps track of how  --
--  many words are in the FIFO.  Also used to generate Full   --
--  and Empty flags.                                          --
----------------------------------------------------------------

    fifo_count : process (CLK)
        variable temp : std_logic_vector(1 downto 0);
        variable fcounter_integer : integer ;
    begin
        temp := read_allow & write_allow;
        if (CLK'event and CLK = '1') then
            if (sinit_internal = '1') then
                fcounter_integer  := 0;
            else
                case temp is
                    when "00" => fcounter_integer := fcounter_integer;      --no action
                    when "01" => fcounter_integer := fcounter_integer + 1 ;  --write
                    when "10" => fcounter_integer := fcounter_integer - 1;  --read
                    when "11" => fcounter_integer := fcounter_integer;      --read and write
                    when others => fcounter_integer := 0;
                end case;
            end if;
            fcounter <=  int_2_std_logic_vector(fcounter_integer, addr_max_plus1) ;
        end if;
    end process fifo_count;

----------------------------------------------------------------
--                                                            --
--                                                            --
----------------------------------------------------------------

 memory_proc: process (CLK)
  --   variable ram : memory_array ;
  variable first_time : boolean := TRUE ;
 begin  -- process

   if (first_time = TRUE ) then
       memory_data_out <= (others => '0') ;
       first_time := FALSE ;
   else
            if CLK'event and CLK = '1' then
                if (SINIT = '1' ) then
                    memory_data_out <= (others => '0') ;
                else  
                    if (read_allow = '1') then
                        memory_data_out <= ram(std_logic_vector_2_posint(read_addr));
                    end if;
                    if  (write_allow = '1') then
                        ram(std_logic_vector_2_posint(write_addr)) <= memory_data_in;
                    end if;
                end if ;
            end if;
   end if ;
  end process memory_proc ;
  




END behavioral;

