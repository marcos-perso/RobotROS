-- ************************************************************************
-- $Id: async_fifo_v4_0.vhd,v 1.1 2010-07-10 21:42:30 mmartinez Exp $
-- ************************************************************************
--  Copyright 2000 - Xilinx, Inc.
--  All rights reserved.
-- ************************************************************************
--                                                                   
--  Module      : async_fifo_v4_0.vhd (behavioral)                   
-- 	                                                             
--  Description : Async FIFO Behavioral Model. 
--  The following VHDL code implements a generic asynchronous FIFO   
--                with independent (potentially asynchronous)          
--                read/write clocks.  Includes updated flag logic 
--	          & support for non symmetrical data ports. 
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE async_fifo_v4_0_pkg IS

FUNCTION log2roundup(data_value : integer)
RETURN integer;

FUNCTION get_lesser (a: integer; b: integer)
RETURN integer;

FUNCTION  calc_read_depth (wr_depth: integer; wr_width: integer; rd_width: integer) 
RETURN integer;

CONSTANT data_width  : integer :=4;
CONSTANT depth : integer :=64;

END  async_fifo_v4_0_pkg;

PACKAGE BODY async_fifo_v4_0_pkg IS

TYPE log2type IS ARRAY (0 TO 4096) OF integer;

-- ---------------------------------------------------
-- FUNCTION : log2roundup                         --
-- ---------------------------------------------------
FUNCTION log2roundup (data_value: integer)
	RETURN integer IS 
	
	VARIABLE width 		: integer := 4; 
	CONSTANT lower_limit 	: integer := 4;
	CONSTANT upper_limit	: integer := 16;
	
	BEGIN
		FOR i IN (lower_limit -1) TO (upper_limit -1) LOOP
			IF (data_value <= 0) THEN
				width := 0;
				EXIT;
			ELSIF (data_value > (2**i)) THEN   
				width := i + 1;
          		ELSE
          			width := width;
          		END IF;          			
      		END LOOP;
	RETURN width;
END log2roundup;

-- ---------------------------------------------------
-- FUNCTION : get_lesser                          --
-- ---------------------------------------------------
FUNCTION get_lesser (a: integer; b: integer)
	RETURN integer IS
	VARIABLE smallest : integer := 1;
	
	BEGIN
		IF (a < b) THEN
          		smallest := a;
          	ELSE
          		smallest := b;
          	END IF;          			
	RETURN smallest;
END get_lesser;	

-- ---------------------------------------------------
-- FUNCTION : calc_read_depth                     --
-- ---------------------------------------------------
FUNCTION  calc_read_depth (wr_depth: integer; wr_width: integer; rd_width: integer) 
	RETURN integer IS
	VARIABLE read_depth : integer := 256;		
	
	BEGIN
		read_depth := ((wr_depth+1)*(wr_width))/rd_width;
	RETURN read_depth;
END calc_read_depth;	

END async_fifo_v4_0_pkg;
----------------------------------------------------------------------------



--------------------------------------------------------------------------
-- Last modified on 09/03/99
-- Name : async_fifo_v4_0_components.vhd
-- Function : Contains definitions of components used in async fifo.
-- 09/03/99 : Changed component count_sub_reg, width of q port (to q_width)
---------------------------------------------------------------------------
--  Last modified on 09/08/99                                            -- 
--  By          : cde                                                    --
--              : Added c_enable_rlocs generic to memory(.vhd)           --
---------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added three new components:				 --
--				fifoctlr_ns, fe_flag, almst_flag         --
--		: modified: count_sub_reg, and_notb			 --
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--  Last modified on 10/26/99                                            -- 
--  By          : veena                                                  --
--              : modfied   memory.vhd-support for non symm ports        --
---------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

PACKAGE async_fifo_v4_0_components IS

--CONSTANT data_width  : INTEGER :=4;
--CONSTANT depth : INTEGER :=64;
COMPONENT memory_v4
          GENERIC (use_blockmem  : boolean := true;
		   c_enable_rlocs: integer := 0;
                   address_width : integer;
		   rd_addr_width : integer;
                   depth         : integer ;
		   rd_depth	 : integer ;
                   data_width    : integer ;
		   rd_data_width : integer );
          PORT (d    : IN std_logic_vector(data_width-1 DOWNTO 0);
                wa   : IN std_logic_vector(address_width-1 DOWNTO 0);
                ra   : IN std_logic_vector(address_width-1 DOWNTO 0);
                we   : IN std_logic;
                wclk : IN std_logic;
                re   : IN std_logic;
                rclk : IN std_logic;
                q    : OUT std_logic_vector(data_width-1 DOWNTO 0)
               );
END COMPONENT;




COMPONENT bcount_up_ainit_v4
	GENERIC(cnt_size	: integer := 8;
		init_val	: string :="00000000";
                c_enable_rlocs	: integer := 1); 
	PORT (	init		: IN std_logic := '0';
		cen		: IN std_logic := '1';
		clk 		: IN std_logic;
		cnt 		: OUT std_logic_vector(cnt_size-1 DOWNTO 0)
             );
END COMPONENT;


COMPONENT eq_compare_v4
	GENERIC(c_width		: integer := 8;
		c_enable_rlocs	: integer := 1);
	PORT (	a 		: IN std_logic_vector(c_width-1 DOWNTO 0);
		b 		: IN std_logic_vector(c_width-1 DOWNTO 0);
		eq		: OUT std_logic
             );
END COMPONENT;


COMPONENT reg_ainit_v4
	GENERIC(reg_size	: integer 	:= 8;
		init_val	: string 	:= "00000000";
		c_enable_rlocs	: integer	:= 1);
	PORT (	rst 		: IN std_logic 	:= '0';	
		clk 		: IN std_logic;
		cen		: IN std_logic 	:= '1';
		din 		: IN std_logic_vector (reg_size-1 DOWNTO 0);
		qout 		: OUT std_logic_vector (reg_size-1 DOWNTO 0)
             );
END COMPONENT;


COMPONENT binary_to_gray_v4
	GENERIC(reg_size	: integer 	:= 8;
		init_val	: string 	:= "10000000";
		c_enable_rlocs	: integer	:= 1);
	PORT (	rst 		: IN std_logic 	:= '0';	
		clk 		: IN std_logic;
		cen		: IN std_logic 	:= '1';
		bin 		: IN std_logic_vector (reg_size-1 DOWNTO 0);
		gray 		: OUT std_logic_vector (reg_size-1 DOWNTO 0)
             );
END COMPONENT;

	
COMPONENT and_a_b_v4
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		and_out		: OUT std_logic
             );
END COMPONENT;	


COMPONENT or_a_b_v4
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		or_out		: OUT std_logic
             );
END COMPONENT;	


COMPONENT and_a_notb_v4
	GENERIC(c_enable_rlocs	: integer);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		and_out		: OUT std_logic
             );
END COMPONENT;


COMPONENT and_a_b_notc_v4
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		c_in   		: IN std_logic;
		and_out		: OUT std_logic
             );
END COMPONENT;			


COMPONENT and_a_b_c_notd_v4
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		c_in   		: IN std_logic;
		d_in   		: IN std_logic;
		and_out		: OUT std_logic
             );
END COMPONENT;			

	
COMPONENT or_fd_v4
	GENERIC(init_val	: string);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		clk   		: IN std_logic;
		rst   		: IN std_logic;
		q_out		: OUT std_logic
             );
END COMPONENT;	


COMPONENT and_fd_v4
	GENERIC(init_val	: string;
		c_enable_rlocs	: integer);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		clk   		: IN std_logic;
		rst   		: IN std_logic;
		q_out		: OUT std_logic
             );
END COMPONENT;	


COMPONENT nand_fd_v4
	GENERIC(init_val	: string;
		c_enable_rlocs	: integer);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		clk   		: IN std_logic;
		rst   		: IN std_logic;
		q_out		: OUT std_logic
             );
END COMPONENT;	


COMPONENT and_a_notb_fd_v4
	GENERIC(init_val	: string;
		c_enable_rlocs	: integer);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		clk   		: IN std_logic;
		rst   		: IN std_logic;
		q_out		: OUT std_logic
            );
END COMPONENT;


COMPONENT nand_a_notb_fd_v4
	GENERIC(init_val	: string;
		c_enable_rlocs	: integer);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		clk   		: IN std_logic;
		rst   		: IN std_logic;
		q_out		: OUT std_logic
            );
END COMPONENT;


COMPONENT or3_fd_v4
	GENERIC(init_val	: string);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		c_in		: IN std_logic;
		clk   		: IN std_logic;
		rst   		: IN std_logic;
		q_out		: OUT std_logic
             );
END COMPONENT;	

-------------------------------------------------------------------------------
-- This block removed 9/26/00 by jogden to fix CR where empty flag was
--   causing wr_count to reset. (CR 126807)
-------------------------------------------------------------------------------
--COMPONENT pulse_reg_v4
--	PORT (	sclr_in	: IN std_logic;
--		sset_in : IN std_logic;		
--		clk	: IN std_logic;
--		rst	: IN std_logic;
--		q_out	: OUT std_logic
--             );
--END COMPONENT;


COMPONENT count_sub_reg_v4
	GENERIC (width		: integer := 8;
		a_width 	: integer := 8;
		b_width 	: integer := 8;
		q_width		: integer := 8;
		c_enable_rlocs 	: integer := 1);
	PORT (	a_in	: IN std_logic_vector(a_width-1 DOWNTO 0);
		b_in	: IN std_logic_vector(b_width-1 DOWNTO 0);
		clk 	: IN std_logic; 			
		rst_a 	: IN std_logic;
		rst_b 	: IN std_logic;
		q_out	: OUT std_logic_vector(q_width-1 DOWNTO 0)
             );
END COMPONENT;		
		

COMPONENT xor_gate_bit_v4
	GENERIC(input_width 	: integer := 8);
        PORT (	input 	: IN std_logic_vector(input_width-1 DOWNTO 0);
		xor_out : OUT std_logic
             );
END COMPONENT;


COMPONENT gray_to_binary_v4
	GENERIC(num_of_bits     : integer := 8;
                init_val        : string  := "00000001";
                c_enable_rlocs	: integer := 1);
	PORT (	bin_reg         : OUT std_logic_vector(num_of_bits-1 DOWNTO 0);
                grey_reg        : IN std_logic_vector(num_of_bits-1 DOWNTO 0);
                reset           : IN std_logic;
                clk             : IN std_logic
             );
END COMPONENT;

COMPONENT fifoctlr_ns_v4
	GENERIC(width			: integer := 4;
		wr_width		: integer := 4;
		rd_width		: integer := 4;
		c_enable_rlocs		: integer := 1;
		c_has_almost_full	: integer := 0;
		c_has_almost_empty	: integer := 0;
		c_has_wrsync_dcount	: integer := 0;
		wrsync_dcount_width	: integer := 2;
		c_has_rdsync_dcount	: integer := 1;
		rdsync_dcount_width	: integer := 2;
		c_has_rd_ack		: integer := 0;
		c_rd_ack_low		: integer := 0;
		c_has_rd_error		: integer := 0;
		c_rd_error_low		: integer := 0;
		c_has_wr_ack		: integer := 0;
		c_wr_ack_low		: integer := 0;
		c_has_wr_error		: integer := 0;
		c_wr_error_low		: integer := 0
		);
   	PORT (	fifo_reset_in	: IN std_logic;
		read_clock_in	: IN std_logic;
         	write_clock_in	: IN std_logic;
         	read_request_in	: IN std_logic;
         	write_request_in: IN std_logic;
         	read_enable_out	: OUT std_logic;
         	write_enable_out: OUT std_logic;
         	full_flag_out	: OUT std_logic;
         	empty_flag_out	: OUT std_logic;
		almost_full_out : OUT std_logic;
		almost_empty_out: OUT std_logic;
	   	read_addr_out	: OUT std_logic_vector (rd_width-1 DOWNTO 0);
	   	write_addr_out	: OUT std_logic_vector (wr_width-1 DOWNTO 0);
		wrsync_count_out: OUT std_logic_vector (wrsync_dcount_width-1 DOWNTO 0);
		rdsync_count_out: OUT std_logic_vector (rdsync_dcount_width-1 DOWNTO 0);
		read_ack	: OUT std_logic;
		read_error	: OUT std_logic;
		write_ack	: OUT std_logic;
		write_error	: OUT std_logic
		);
END COMPONENT ;

COMPONENT empty_flag_reg_v4
	GENERIC(addr_width	: integer;
		c_enable_rlocs	: integer
		);
   	PORT (	rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce1	: IN std_logic;
		flag_ce2	: IN std_logic;
		reg_clk		: IN std_logic;				
		reg_ce		: IN std_logic;		
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		dlyd_out	: OUT std_logic_vector (addr_width-1 DOWNTO 0);
		flag_out	: OUT std_logic;
		to_almost_logic	: OUT std_logic        	
		);
END COMPONENT;

COMPONENT full_flag_reg_v4
	GENERIC(addr_width	: integer;
		c_enable_rlocs	: integer
		);
   	PORT (	rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce1	: IN std_logic;
		flag_ce2	: IN std_logic;
		reg_clk		: IN std_logic;				
		reg_ce		: IN std_logic;		
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		dlyd_out	: OUT std_logic_vector (addr_width-1 DOWNTO 0);
		flag_out	: OUT std_logic;
		to_almost_logic	: OUT std_logic        	
		);
END COMPONENT;

COMPONENT almst_empty_v4
	GENERIC(addr_width	: integer;
		c_enable_rlocs	: integer
		);
   	PORT   (rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce		: IN std_logic;
		reg_clk		: IN std_logic;
		reg_ce		: IN std_logic;
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		rqst_in		: IN std_logic;
		flag_comb_in	: IN std_logic;
		flag_q_in	: IN std_logic;
		flag_out	: OUT std_logic        	
		);
END COMPONENT;

COMPONENT almst_full_v4
	GENERIC(addr_width	: integer;
		c_enable_rlocs	: integer
		);
   	PORT   (rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce		: IN std_logic;
		reg_clk		: IN std_logic;
		reg_ce		: IN std_logic;
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		rqst_in		: IN std_logic;
		flag_comb_in	: IN std_logic;
		flag_q_in	: IN std_logic;
		flag_out	: OUT std_logic        	
		);
END COMPONENT;

END async_fifo_v4_0_components;
---------------------------------------------------------------------------------




LIBRARY ieee;
USE ieee.std_logic_1164.ALL;


LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_DIST_MEM_V5_0_COMP.ALL;
USE XilinxCoreLib.BLKMEMDP_V4_0_COMP.ALL;

ENTITY memory_v4 IS
          GENERIC (use_blockmem  : boolean ;
		   c_enable_rlocs: integer ;	--cde 09/08/99
                   address_width : integer ;
		   rd_addr_width : integer ;	--cde 10/25/99
                   depth         : integer ;
		   rd_depth	 : integer ;	--cde 10/25/99
                   data_width    : integer ;
		   rd_data_width : integer );	--cde 10/25/99
          PORT (d    : IN std_logic_vector(data_width-1 DOWNTO 0);
                wa   : IN std_logic_vector(address_width-1 DOWNTO 0);
                ra   : IN std_logic_vector(rd_addr_width-1 DOWNTO 0);
                we   : IN std_logic;
                wclk : IN std_logic;
                re   : IN std_logic;
                rclk : IN std_logic;
                q    : OUT std_logic_vector(rd_data_width-1 DOWNTO 0));
END memory_v4;


ARCHITECTURE behavioral OF memory_v4 IS

CONSTANT default_data : string(data_width DOWNTO 1):=(OTHERS => '0');
CONSTANT default_rd_data : string(rd_data_width DOWNTO 1):=(OTHERS => '0');
SIGNAL port_enabled   : std_logic;
SIGNAL sourceless     : std_logic_vector(data_width-1 DOWNTO 0);
SIGNAL sourceless_addr: std_logic_vector(address_width-1 DOWNTO 0);
SIGNAL sourceless_dib : std_logic_vector(rd_data_width-1 DOWNTO 0);
SIGNAL sourceless_net : std_logic;
SIGNAL spo_dummy      : std_logic_vector(data_width-1 DOWNTO 0);
SIGNAL qspo_dummy     : std_logic_vector(data_width-1 DOWNTO 0);
SIGNAL dpo_dummy      : std_logic_vector(data_width-1 DOWNTO 0);
SIGNAL doa_dummy      : std_logic_vector(data_width-1 DOWNTO 0);
SIGNAL unconnected_port : std_logic;
SIGNAL unconnected_spo : std_logic_vector(data_width-1 DOWNTO 0) ;
SIGNAL unconnected_qspo : std_logic_vector(data_width-1 DOWNTO 0) ;
SIGNAL unconnected_dpo : std_logic_vector(data_width-1 DOWNTO 0) ;
SIGNAL unconnected_douta : std_logic_vector(data_width-1 DOWNTO 0);

SIGNAL unconnected_dinb : std_logic_vector(rd_data_width-1 DOWNTO 0) := (OTHERS => '0');
SIGNAL unconnected_ena : std_logic := '1';
SIGNAL unconnected_nda : std_logic;
SIGNAL unconnected_ndb : std_logic;
SIGNAL unconnected_sinita : std_logic := '0';
SIGNAL unconnected_sinitb : std_logic := '0';
SIGNAL unconnected_web : std_logic := '0';


BEGIN

sourceless_net <= '0';
port_enabled   <= '1';
sourceless_dib <= (OTHERS => '0');
sourceless_addr<= (OTHERS => '0');


  blkmem : IF use_blockmem GENERATE
    bmem : blkmemdp_v4_0
      GENERIC MAP (
        c_addra_width          => address_width,
        c_addrb_width          => rd_addr_width,
        c_default_data         => default_data,
        c_depth_a              => depth,
        c_depth_b              => rd_depth,
        c_enable_rlocs         => 0,
        c_has_default_data     => 1,
        c_has_dina             => 1,
        c_has_dinb             => 0,
        c_has_douta            => 0,
        c_has_doutb            => 1,
        c_has_ena              => 0,
        c_has_enb              => 1,
        c_has_limit_data_pitch => 0,
        c_has_nda              => 0,
        c_has_ndb              => 0,
        c_has_rdya             => 0,
        c_has_rdyb             => 0,
        c_has_rfda             => 0,
        c_has_rfdb             => 0,
        c_has_sinita           => 0,
        c_has_sinitb           => 0,
        c_has_wea              => 1,
        c_has_web              => 0,
        c_limit_data_pitch     => 18,
        c_pipe_stages_a        => 0,
        c_pipe_stages_b        => 0,
        c_reg_inputsa         => 0,
        c_reg_inputsb         => 0,
        c_sinita_value         => default_data,
        c_sinitb_value         => default_data,
        c_width_a              => data_width,
        c_width_b              => rd_data_width,
        c_write_modea          => 2,
        c_write_modeb          => 2
        )
      PORT MAP (
        addra                  => wa,
        addrb                  => ra,
        clka                   => wclk,
        clkb                   => rclk,
        dina                   => d,
        dinb                   => unconnected_dinb,    --jeo 9-25-00
        douta                  => unconnected_douta,
        doutb                  => q,
        ena                    => unconnected_ena,     --jeo 9-25-00
        enb                    => re,
        nda                    => unconnected_nda,     --jeo 9-25-00
        ndb                    => unconnected_ndb,     --jeo 9-25-00
        rdya                   => unconnected_port,
        rdyb                   => unconnected_port,
        rfda                   => unconnected_port,
        rfdb                   => unconnected_port,
        sinita                 => unconnected_sinita,  --jeo 9-25-00
        sinitb                 => unconnected_sinitb,  --jeo 9-25-00
        wea                    => we,
        web                    => unconnected_web      --jeo 9-25-00
        );
  END GENERATE blkmem;
------------------- These generics are not used by the FiFO  ----------------
--      c_family                     
--      c_mem_init_file             
--      c_xmem_init_array           
-----------------------------------------------------------------------------



distmem: IF (NOT use_blockmem) GENERATE
 dist_mem: C_DIST_MEM_V5_0 GENERIC MAP 
                        (c_enable_rlocs  => c_enable_rlocs, --cde 09/08/99
                         C_WIDTH => data_width,
			 C_DEPTH => depth,
  			 C_ADDR_WIDTH => address_width,
			 C_MEM_TYPE => 2,-- "c_dp_ram",
			 C_MUX_TYPE => 0,--"c_lut_based", --buft not supported for dp.
			 C_REG_A_D_INPUTS => 0,
			 C_REG_DPRA_INPUT => 0, 
                         C_QUALIFY_WE =>0,
                         C_QCE_JOINED => 0,
			 --C_MEM_INIT_RADIX => 2,
			 C_DEFAULT_DATA	=> default_data, --"0",
			 C_MEM_INIT_FILE => "",
			 C_READ_MIF => 0,
			 C_GENERATE_MIF=> 0,
			 --C_PIPE_STAGES => 1,
			 C_HAS_D => 1,
			 C_HAS_CLK => 1,
			 C_HAS_SPRA => 0,
			 C_HAS_DPRA => 1,
			 C_HAS_I_CE => 0,
			 C_HAS_RD_EN => 0,
			 C_HAS_WE => 1,
			 C_HAS_SPO => 0,
			 C_HAS_QSPO => 1,
			 C_HAS_DPO => 0,
			 C_HAS_QDPO=> 1,
			 C_HAS_QSPO_CE=> 1,
			 C_HAS_QDPO_CE=> 1,
			 C_HAS_QDPO_CLK=> 1,
			 C_HAS_QSPO_RST=> 0,
			 C_HAS_QDPO_RST=> 0
			 )        
                          PORT MAP(A       => wa,
                                   SPO     => spo_dummy, --mandatory port
                                   QSPO    => qspo_dummy,--optional
                                   CLK    => wclk,
                                   WE      => we,
                                   RD_EN   => sourceless_net,
                                   D       => d,
                                   I_CE    => sourceless_net, --optional,
                                   SPRA    => sourceless_addr, --optional,
                                   DPRA    => ra,
                                   DPO     => dpo_dummy, --optional
                                   QSPO_CE  => sourceless_net,
                                   QDPO    => q,
                                   QDPO_CLK => rclk, --read clock
                                   QDPO_CE  => re);
                                    
END GENERATE; --distmem


END behavioral;

---------------------------------------------------------------------------
-- $Id: full_flag.vhd,
---------------------------------------------------------------------------
--                                                                       --
--  Module      : full_flag.vhd 		Last Update: 10/11/99    --
--                                                                       --
--  Description : Behavorial Model, for simulation only			 --
--									 --
--									 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--LIBRARY unisim;
--USE unisim.unisim_comps.all;

--LIBRARY pldir;
--USE pldir.pldir.all;

ENTITY full_flag_reg_v4 IS
	GENERIC(addr_width	: integer := 15;
		c_enable_rlocs	: integer := 0);
   	PORT (	rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce1	: IN std_logic;
		flag_ce2	: IN std_logic;		
		reg_clk		: IN std_logic;
		reg_ce		: IN std_logic;
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		dlyd_out	: OUT std_logic_vector (addr_width-1 DOWNTO 0);
		flag_out	: OUT std_logic;
		to_almost_logic	: OUT std_logic        	
		);
END full_flag_reg_v4 ;

ARCHITECTURE behavioral OF full_flag_reg_v4 IS
--	SIGNAL gnd	: STD_LOGIC;
--	SIGNAL pwr	: STD_LOGIC;
	SIGNAL flag_d	: std_logic;
	SIGNAL flag_q   : std_logic;
	SIGNAL b_dlyd	: std_logic_vector (addr_width-1 DOWNTO 0);
	
BEGIN
--	gnd		<= '0';
--	pwr		<= '1';
	dlyd_out	<= b_dlyd;
	flag_out	<= flag_q;
	to_almost_logic <= flag_d;

flag_blk : BLOCK
	SIGNAL flag_ce		: std_logic;

BEGIN 
	flag_ce <= flag_ce1 OR flag_ce2;

	flag_d <= '1' WHEN ((a_in = b_in)AND(flag_q = '1')) ELSE 
		  '1' WHEN ((a_in = b_dlyd)AND(flag_q = '0')) ELSE
		  '0';

PROCESS  (rst, flag_clk)
BEGIN
	IF rst = '1' THEN 
		flag_q <= '1';
	ELSIF (flag_clk'event AND flag_clk = '1') THEN
		IF (flag_ce = '1') THEN
			flag_q <= flag_d;
		ELSE
			flag_q <= flag_q;
		END IF;
	END IF;
END PROCESS;
END BLOCK flag_blk;

reg_blk: BLOCK
BEGIN
PROCESS  (rst, reg_clk)
BEGIN
	IF rst = '1' THEN 
		FOR i IN 0 TO addr_width-1 LOOP
			IF (i=0 OR i=1 OR i=addr_width-1) THEN
				b_dlyd(i) <= '1';
			ELSE 
				b_dlyd(i) <= '0';
			END IF;
		END LOOP;
	ELSIF (reg_clk'event AND reg_clk = '1') THEN
		IF (reg_ce = '1') THEN
			b_dlyd <= b_in;
		ELSE
			b_dlyd <= b_dlyd;
		END IF;
	END IF;
END PROCESS;
END BLOCK reg_blk;

END behavioral;



--- Empty flag included here

---------------------------------------------------------------------------
-- $Id: empty_flag.vhd
---------------------------------------------------------------------------
--                                                                       --
--  Module      : empty_flag.vhd 		Last Update: 10/11/99    --
--                                                                       --
--  Description : Behavorial Model, for simulation only			 --
--									 --
--									 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--LIBRARY unisim;
--USE unisim.unisim_comps.all;

--LIBRARY pldir;
--USE pldir.pldir.all;

ENTITY empty_flag_reg_v4 IS
	GENERIC(addr_width	: integer := 15;
		c_enable_rlocs	: integer := 0);
   	PORT (	rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce1	: IN std_logic;
		flag_ce2	: IN std_logic;		
		reg_clk		: IN std_logic;
		reg_ce		: IN std_logic;
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		dlyd_out	: OUT std_logic_vector (addr_width-1 DOWNTO 0);
		flag_out	: OUT std_logic;
		to_almost_logic	: OUT std_logic        	
		);
END empty_flag_reg_v4 ;

ARCHITECTURE behavioral OF empty_flag_reg_v4 IS
	SIGNAL flag_d	: std_logic;
	SIGNAL flag_q   : std_logic;
	SIGNAL b_dlyd	: std_logic_vector (addr_width-1 DOWNTO 0);
	
BEGIN
	dlyd_out	<= b_dlyd;
	flag_out	<= flag_q;
	to_almost_logic <= flag_d;

flag_blk : BLOCK
	SIGNAL flag_ce		: std_logic;

BEGIN 
	flag_ce <= flag_ce1 OR flag_ce2;

	flag_d <= '1' WHEN ((a_in = b_in)AND(flag_q = '1')) ELSE 
		  '1' WHEN ((a_in = b_dlyd)AND(flag_q = '0')) ELSE 
		  '0';

PROCESS  (rst, flag_clk)
BEGIN
	IF rst = '1' THEN 
		flag_q <= '1';
	ELSIF (flag_clk'event AND flag_clk = '1') THEN
		IF (flag_ce = '1') THEN
			flag_q <= flag_d;
		ELSE
			flag_q <= flag_q;
		END IF;
	END IF;
END PROCESS;
END BLOCK flag_blk;

reg_blk: BLOCK
BEGIN
PROCESS  (rst, reg_clk)
BEGIN
	IF rst = '1' THEN 
		FOR i IN 0 TO addr_width-1 LOOP
			IF (i=0 OR i=addr_width-1) THEN
				b_dlyd(i) <= '1';
			ELSE 
				b_dlyd(i) <= '0';
			END IF;
		END LOOP;
	ELSIF (reg_clk'event AND reg_clk = '1') THEN
		IF (reg_ce = '1') THEN
			b_dlyd <= b_in;
		ELSE
			b_dlyd <= b_dlyd;
		END IF;
	END IF;
END PROCESS;
END BLOCK reg_blk;

END behavioral;
---------------------------------------------------------------------------

-- Almst_full Included here

---------------------------------------------------------------------------
-- $Id: almst_full.vhd,
---------------------------------------------------------------------------
--                                                                       --
--  Module      : almst_full.vhd 		Last Update: 10/11/99    --
--                                                                       --
--  Description : Behavorial Model, for simulation only			 --
--									 --
--									 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

--LIBRARY unisim;
--USE unisim.unisim_comps.all;

--LIBRARY pldir;
--USE pldir.pldir.all;

ENTITY almst_full_v4 IS
	GENERIC(addr_width	: integer := 15;
		c_enable_rlocs	: integer := 0);
   	PORT (	rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce		: IN std_logic;	
		reg_clk		: IN std_logic;
		reg_ce		: IN std_logic;
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		rqst_in		: IN std_logic;
		flag_comb_in	: IN std_logic;
		flag_q_in	: IN std_logic;
		flag_out	: OUT std_logic       	
		);
END almst_full_v4 ;

ARCHITECTURE behavioral OF almst_full_v4 IS
	SIGNAL flag_d	: std_logic;
	SIGNAL flag_q   : std_logic;
	SIGNAL b_dlyd	: std_logic_vector (addr_width-1 DOWNTO 0);
BEGIN
	flag_out	<= flag_q;

flag_blk : BLOCK
	SIGNAL comp_mux	: std_logic;
	SIGNAL rqst_mux	: std_logic;
	SIGNAL comb_or	: std_logic;

BEGIN 
	comp_mux <= 	'1' WHEN ((a_in = b_in)AND(flag_q_in='1')) ELSE 
		  	'1' WHEN ((a_in = b_dlyd)AND(flag_q_in='0')) ELSE 
		  	'0';
	rqst_mux <= 	'1' WHEN ((comp_mux='1')AND((rqst_in='1')OR(flag_q_in='1'))) ELSE
		  	'0';
	comb_or  <= 	'1' WHEN ((rqst_mux='1')OR(flag_comb_in='1')) ELSE
			'0';
	flag_d 	 <= 	comb_or;

PROCESS  (rst, flag_clk)
BEGIN
	IF rst = '1' THEN 
		flag_q <= '1';
	ELSIF (flag_clk'event AND flag_clk = '1') THEN
		IF (flag_ce = '1') THEN
			flag_q <= flag_d;
		ELSE
			flag_q <= flag_q;
		END IF;
	END IF;
END PROCESS;
END BLOCK flag_blk;

reg_blk: BLOCK
BEGIN
PROCESS  (rst, reg_clk)
BEGIN
	IF rst = '1' THEN 
		FOR i IN 0 TO addr_width-1 LOOP
			IF (i=1 OR i=addr_width-1) THEN
				b_dlyd(i) <= '1';
			ELSE 
				b_dlyd(i) <= '0';
			END IF;
		END LOOP;
	ELSIF (reg_clk'event AND reg_clk = '1') THEN
		IF (reg_ce = '1') THEN
			b_dlyd <= b_in;
		ELSE
			b_dlyd <= b_dlyd;
		END IF;
	END IF;
END PROCESS;
END BLOCK reg_blk;

END behavioral;

--Almst empty included here

---------------------------------------------------------------------------
-- $Id: almst_empty.vhd,
---------------------------------------------------------------------------
--                                                                       --
--  Module      : almst_empty.vhd 		Last Update: 10/11/99    --
--                                                                       --
--  Description : Behavorial Model, for simulation only			 --
--									 --
--									 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


ENTITY almst_empty_v4 IS
	GENERIC(addr_width	: integer := 15;
		c_enable_rlocs	: integer := 0);
   	PORT (	rst		: IN std_logic;
		flag_clk	: IN std_logic;
		flag_ce		: IN std_logic;	
		reg_clk		: IN std_logic;
		reg_ce		: IN std_logic;
		a_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		b_in		: IN std_logic_vector (addr_width-1 DOWNTO 0);
		rqst_in		: IN std_logic;
		flag_comb_in	: IN std_logic;
		flag_q_in	: IN std_logic;
		flag_out	: OUT std_logic       	
		);
END almst_empty_v4;

ARCHITECTURE behavioral OF almst_empty_v4 IS
	SIGNAL flag_d	: std_logic ;  --what drives flag_d ?
	SIGNAL flag_q   : std_logic ; 
	SIGNAL b_dlyd	: std_logic_vector (addr_width-1 DOWNTO 0);
	
BEGIN
	flag_out	<= flag_q;

flag_blk : BLOCK
	SIGNAL comp_mux	: std_logic;
	SIGNAL rqst_mux	: std_logic;
	SIGNAL comb_or	: std_logic;

BEGIN 
	comp_mux <= 	'1' WHEN ((a_in = b_in)AND(flag_q_in='1')) ELSE
		  	'1' WHEN ((a_in = b_dlyd)AND(flag_q_in='0')) ELSE
		  	'0';
	rqst_mux <= 	'1' WHEN ((comp_mux='1')AND((rqst_in='1')OR(flag_q_in='1'))) ELSE
		  	'0';
	comb_or  <= 	'1' WHEN ((rqst_mux='1')OR(flag_comb_in='1')) ELSE
			'0';
	flag_d 	 <= 	comb_or;

PROCESS  (rst, flag_clk)
BEGIN
	IF rst = '1' THEN 
		flag_q <= '1';
	ELSIF (flag_clk'event AND flag_clk = '1') THEN
		IF (flag_ce = '1') THEN
			flag_q <= flag_d;
		ELSE
			flag_q <= flag_q;
		END IF;
	END IF;
END PROCESS;
END BLOCK flag_blk;

reg_blk: BLOCK
BEGIN
PROCESS  (rst, reg_clk)
BEGIN
	IF rst = '1' THEN 
		FOR i IN 0 TO addr_width-1 LOOP
			IF (i=0 OR i=1 OR i=addr_width-1) THEN
				b_dlyd(i) <= '1';
			ELSE 
				b_dlyd(i) <= '0';
			END IF;
		END LOOP;
	ELSIF (reg_clk'event AND reg_clk = '1') THEN
		IF (reg_ce = '1') THEN
			b_dlyd <= b_in;
		ELSE
			b_dlyd <= b_dlyd;
		END IF;
	END IF;
END PROCESS;
END BLOCK reg_blk;

END behavioral;
------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : bcount_up_ainit.vhd
-- Function : Binary counter (up only) with clock enable & ainit value
------------------------------------------------------------------------------

LIBRARY IEEE ;
USE IEEE.STD_LOGIC_1164.ALL ;

LIBRARY XilinxCoreLib ;
USE XilinxCoreLib.C_COUNTER_BINARY_V4_0_COMP.ALL ;

ENTITY bcount_up_ainit_v4 IS
	GENERIC (cnt_size	: integer := 8 ;
		init_val	: string  := "00000000" ;
		c_enable_rlocs	: integer := 1 );
	PORT (	init		: IN std_logic := '0' ;
		cen		: IN std_logic := '1' ;
		clk 		: IN std_logic ;
		cnt 		: OUT std_logic_vector(cnt_size-1 DOWNTO 0) );
END bcount_up_ainit_v4 ;

ARCHITECTURE behavioral OF bcount_up_ainit_v4 IS
	SIGNAL gnd		: std_logic := '0' ;
	SIGNAL vcc		: std_logic := '1' ;
	CONSTANT no		: integer := 0 ;
	CONSTANT yes		: integer := 1 ;
	SIGNAL unused_1		: std_logic ;
	SIGNAL unused_2		: std_logic ;
	SIGNAL unused_3		: std_logic ;
	SIGNAL unused_4		: std_logic ;
	SIGNAL dummy_val	: std_logic_vector(cnt_size-1 DOWNTO 0);

BEGIN
	
count_bin: C_COUNTER_BINARY_V4_0
	GENERIC MAP(	C_WIDTH 	=> cnt_size,
			C_ENABLE_RLOCS	=> c_enable_rlocs,
			C_RESTRICT_COUNT=> 0,		--(not used???)
			C_COUNT_TO	=> init_val,	--Not applicable
			C_COUNT_BY	=> "1",		--Count by one!
			C_COUNT_MODE	=> 0,		--(up???)
			C_THRESH0_VALUE	=> init_val,	--Not applicable
			C_THRESH1_VALUE	=> init_val,	--Not applicable
			C_AINIT_VAL	=> init_val,
			C_SINIT_VAL	=> init_val,	--Not applicable
			C_LOAD_ENABLE	=> 0,		--Not applicable
			C_LOAD_LOW	=> 0,		--Not applicable
			C_SYNC_ENABLE	=> 1,		--Not applicable
			C_SYNC_PRIORITY	=> 1,		--Not applicable
			C_PIPE_STAGES	=> 1,		--DUP?????????????
			C_HAS_THRESH0	=> no,
			C_HAS_Q_THRESH0	=> no,
			C_HAS_THRESH1	=> no,
			C_HAS_Q_THRESH1	=> no,
			C_HAS_CE	=> yes,		--CE pin used
			C_HAS_UP	=> no,		
			C_HAS_IV	=> no,
			C_HAS_L		=> no,		
			C_HAS_LOAD	=> no,
 			C_HAS_ACLR	=> no,	
			C_HAS_ASET	=> no,	
			C_HAS_AINIT	=> yes,		--AINIT used
			C_HAS_SCLR	=> no,	
			C_HAS_SSET	=> no,		
			C_HAS_SINIT	=> no		
			)
	PORT MAP ( 	Q		=> cnt,		--Count Output
			CLK		=> clk,
			UP		=> vcc,	 	--Always count up
			THRESH0 	=> unused_1,	--Not applicable
			Q_THRESH0 	=> unused_2,	--Not applicable
			THRESH1 	=> unused_3,	--Not applicable
			Q_THRESH1 	=> unused_4,	--Not applicable
			CE 		=> cen,
			LOAD		=> gnd,		--LOAD not used
			L		=> dummy_val,	--Load port not used
			IV		=> dummy_val,	--IV port not used
			ACLR		=> gnd,		--ACLR not used
			ASET		=> gnd,		--ASET not used	
			AINIT 		=> init,		
			SCLR		=> gnd,		--SCLR not used
			SSET		=> gnd,		--SSET not used
			SINIT		=> gnd		--SINIT not used
			);
END behavioral ;
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : binary_to_gray.vhd
-- Function : Module converts binary count to equivalent gray count.	
-------------------------------------------------------------------------------

LIBRARY IEEE ;
USE IEEE.std_logic_1164.ALL ;

LIBRARY XilinxCoreLib ;
USE XilinxCoreLib.C_GATE_BUS_V4_0_COMP.ALL ;

ENTITY binary_to_gray_v4 IS
	GENERIC(reg_size	: integer 	:= 8;
		init_val	: string 	:= "00000001";	--LSB to MSB is left to right
		c_enable_rlocs	: integer	:= 1);
	PORT (	rst 		: IN std_logic 	:= '0';	
		clk 		: IN std_logic;
		cen		: IN std_logic 	:= '1';
		bin 		: IN std_logic_vector (reg_size-1 DOWNTO 0);
		gray 		: OUT std_logic_vector (reg_size-1 DOWNTO 0)) ;
END binary_to_gray_v4 ;

ARCHITECTURE behavioral OF binary_to_gray_v4 IS
	SIGNAL gnd		: std_logic := '0';
	SIGNAL vcc		: std_logic := '1';
	CONSTANT no		: integer := 0;
	CONSTANT yes		: integer := 1;
	CONSTANT inv_mask	: string(1 TO reg_size) := (OTHERS => '0');
	SIGNAL dummy_load	: std_logic_vector (reg_size-1 DOWNTO 0);
	SIGNAL ia 		: std_logic_vector (reg_size-1 DOWNTO 0);

BEGIN
	ia(reg_size-1) <= '0';
	ia(reg_size-2 DOWNTO 0) <= bin(reg_size-1 DOWNTO 1);
	
xor_reg: C_GATE_BUS_V4_0
	GENERIC MAP (	C_ENABLE_RLOCS		=> c_enable_rlocs,
			C_GATE_TYPE		=> 4,		--bitwise exclusive OR
			C_WIDTH 		=> reg_size, 
			C_INPUTS		=> 2,		--two bit XOR
			C_INPUT_A_INV_MASK 	=> inv_mask,
			C_INPUT_B_INV_MASK 	=> inv_mask,
			C_INPUT_C_INV_MASK 	=> inv_mask,	--Not Used
			C_INPUT_D_INV_MASK 	=> inv_mask,	--Not Used
			C_AINIT_VAL		=> init_val,	
			C_SINIT_VAL		=> init_val,	--SINIT not used
			C_SYNC_PRIORITY		=> 1,		--Not used (1=c_clear)
			C_SYNC_ENABLE		=> 1,		--Not used (1=c_no_override)
			C_HAS_O			=> no,		--Don't use unregistered output
			C_HAS_Q			=> yes,		--Use registered output
			C_HAS_CE		=> yes,		--CE pin used
 			C_HAS_ACLR		=> no,		--No ACLR pin
			C_HAS_ASET		=> no,		--No ASET pin
			C_HAS_AINIT		=> yes,		--AINIT used
			C_HAS_SCLR		=> no,		--No SCLR pin
			C_HAS_SSET		=> no,		--No SSET pin
			C_HAS_SINIT		=> no		--No SINIT pin
			)
	PORT MAP ( 	IA	=> ia,				
 			IB 	=> bin,				
 			IC	=> bin,		--Port not used 
        		ID	=> bin,		--Port not used	
			Q	=> gray,	--Registered Output
			O	=> dummy_load,	--O not used or generated
			CLK	=> clk,
			CE 	=> cen,
			ACLR	=> gnd,		--ACLR not used
			ASET	=> gnd,		--ASET not used	
			AINIT 	=> rst,		
			SCLR	=> gnd,		--SCLR not used
			SSET	=> gnd,		--SSET not used
			SINIT	=> gnd		--SINIT not used
			);
END behavioral ;
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : eq_compare.vhd
-- Function : Instantiation of C_COMPARE_V4_0 to create an indentity comparitor
-------------------------------------------------------------------------------

LIBRARY IEEE ;
USE IEEE.std_logic_1164.ALL ;

LIBRARY XilinxCoreLib ;
USE XilinxCoreLib.C_COMPARE_V4_0_COMP.ALL ;

ENTITY eq_compare_v4 IS
	GENERIC(c_width		: integer := 8;
		c_enable_rlocs	: integer :=1);
	PORT (	a 		: IN std_logic_vector(c_width-1 DOWNTO 0);
		b 		: IN std_logic_vector(c_width-1 DOWNTO 0);
		eq		: OUT std_logic);
END eq_compare_v4 ;

ARCHITECTURE behavioral OF eq_compare_v4 IS
	SIGNAL gnd		: std_logic := '0';
	SIGNAL vcc		: std_logic := '1';
	CONSTANT no		: integer := 0;
	CONSTANT yes		: integer := 1;
	CONSTANT dummy_val	: string(c_width DOWNTO 1) := (OTHERS => '0');
	SIGNAL dummy_out_1	: std_logic;
	SIGNAL dummy_out_2	: std_logic;
	SIGNAL dummy_out_3	: std_logic;
	SIGNAL dummy_out_4	: std_logic;
	SIGNAL dummy_out_5	: std_logic;
	SIGNAL dummy_out_6	: std_logic;
	SIGNAL dummy_out_7	: std_logic;
	SIGNAL dummy_out_8	: std_logic;
	SIGNAL dummy_out_9	: std_logic;
	SIGNAL dummy_out_10	: std_logic;
	SIGNAL dummy_out_11	: std_logic;

BEGIN
	
eq_comp:C_COMPARE_V4_0
	GENERIC MAP(	C_WIDTH 	=> c_width, 
			C_DATA_TYPE	=> 1,		--(unsigned????)
			C_B_CONSTANT	=> no,		--(no constant????)
			C_B_VALUE=> dummy_val,		--Not Applicable 		
			C_SYNC_ENABLE	=> 1,		--Not Applicable (1=c_no_override)
			C_SYNC_PRIORITY	=> 1,		--Not Applicable (1=c_clear) 
			C_PIPE_STAGES	=> 1,		--Not Applicable
			C_HAS_A_EQ_B	=> yes,
 			C_HAS_A_NE_B	=> no,
			C_HAS_A_LT_B	=> no,
			C_HAS_A_GT_B	=> no,
			C_HAS_A_LE_B	=> no,
			C_HAS_A_GE_B	=> no,
			C_HAS_QA_EQ_B	=> no,
 			C_HAS_QA_NE_B	=> no,
			C_HAS_QA_LT_B	=> no,
			C_HAS_QA_GT_B	=> no,
			C_HAS_QA_LE_B	=> no,
			C_HAS_QA_GE_B	=> no,
			C_HAS_CE	=> no,
			C_HAS_ACLR	=> no,
			C_HAS_ASET	=> no,
			C_HAS_SCLR	=> no,
			C_HAS_SSET	=> no,
			C_ENABLE_RLOCS	=> c_enable_rlocs	
			)
	PORT MAP ( 	A		=> a,	
			B		=> b,	
			A_EQ_B		=> eq,
			CLK		=> gnd,
			CE		=> gnd,
			ACLR		=> gnd,
			ASET		=> gnd,
			SCLR		=> gnd,
			SSET		=> gnd,
			A_GT_B		=> dummy_out_1,
			A_GE_B		=> dummy_out_2,
			A_LT_B		=> dummy_out_3,
			A_LE_B		=> dummy_out_4,
			A_NE_B		=> dummy_out_5,
			QA_GT_B		=> dummy_out_6,
			QA_GE_B		=> dummy_out_7,
			QA_LT_B		=> dummy_out_8,
			QA_LE_B		=> dummy_out_9,
			QA_EQ_B		=> dummy_out_10,
			QA_NE_B		=> dummy_out_11
			);
END behavioral ;
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : reg_ainit.vhd
-- Function : A generic register with an init_val and clock enable 
--		wrapper file of the C_REG_FD_V4_0 baseblox
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_REG_FD_V4_0_COMP.ALL;

ENTITY reg_ainit_v4 IS
	GENERIC(reg_size	: integer 	:= 8;
		init_val	: string	:= "00000000";
		c_enable_rlocs	: integer	:= 1);		--LSB to MSB is left to right
	PORT (	rst 		: IN std_logic 	:= '0';	
		clk 		: IN std_logic;
		cen		: IN std_logic 	:= '1';
		din 		: IN std_logic_vector(reg_size-1 DOWNTO 0);
		qout 		: OUT std_logic_vector(reg_size-1 DOWNTO 0));
END reg_ainit_v4 ;

ARCHITECTURE behavioral OF reg_ainit_v4 IS
	CONSTANT no		: integer 	:= 0;
	CONSTANT yes		: integer 	:= 1;
	SIGNAL gnd		: std_logic 	:= '0';
	SIGNAL vcc		: std_logic 	:= '1';
BEGIN
reg_fd: C_REG_FD_V4_0
	GENERIC MAP(
		C_WIDTH 	=> reg_size, 
		C_AINIT_VAL	=> init_val,
		C_SINIT_VAL	=> init_val,	--SINIT not used
		C_SYNC_PRIORITY	=> 1,		--Not used (1=c_clear)
		C_SYNC_ENABLE	=> 1,		--Not used (1=c_no_override)
		C_HAS_CE	=> yes,		--CE pin used
 		C_HAS_ACLR	=> no,		--No ACLR pin
		C_HAS_ASET	=> no,		--No ASET pin
		C_HAS_AINIT	=> yes,		--AINIT used
		C_HAS_SCLR	=> no,		--No SCLR pin
		C_HAS_SSET	=> no,		--No SSET pin
		C_ENABLE_RLOCS	=> c_enable_rlocs,		--Not part of Behavorial Model????
		C_HAS_SINIT	=> no		--No SINIT pin
			)
	PORT MAP ( 	D	=> din,		--Data Input
			Q	=> qout,	--Registered Output
			CLK	=> clk,
			CE 	=> cen,
			ACLR	=> gnd,		--ACLR not used
			ASET	=> gnd,		--ASET not used	
			AINIT	=> rst,		
			SCLR	=> gnd,		--SCLR not used
			SSET	=> gnd,		--SSET not used
			SINIT	=> gnd		--SINIT not used
			);
END behavioral ;
--------------------

-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_a_b.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A & B
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_a_b_v4 IS
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		and_out	: OUT std_logic);
END and_a_b_v4;

ARCHITECTURE behavioral OF and_a_b_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL and_in	: std_logic_vector(1 DOWNTO 0);
	
BEGIN
	and_in(1) <= a_in;
	and_in(0) <= b_in;

and_a_b:C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 0,		--c_and
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> and_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : or_a_b.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A + B
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY or_a_b_v4 IS
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		or_out	: OUT std_logic);
END or_a_b_v4;

ARCHITECTURE behavioral OF or_a_b_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL or_in	: std_logic_vector(1 DOWNTO 0);
	
BEGIN
	or_in(1) <= a_in;
	or_in(0) <= b_in;

or_a_b:C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 2,		--c_or
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> or_in,
		O	=> or_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_a_notb.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates A & !B
-------------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added c_enable_rlocs generic		                 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_a_notb_v4 IS
	GENERIC(c_enable_rlocs	: integer := 1);
	PORT (	a_in		: IN std_logic;
		b_in   		: IN std_logic;
		and_out		: OUT std_logic);
END and_a_notb_v4;

ARCHITECTURE behavioral OF and_a_notb_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL and_in	: std_logic_vector(1 DOWNTO 0);
	
BEGIN

	and_in(1) <= a_in;
	and_in(0) <= b_in;

and_a_notb:C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 0,		--c_and
      		C_ENABLE_RLOCS	=> c_enable_rlocs,
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "01", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> and_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
---------
--------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_a_notb_fd.vhd
-- Function : A registered implementation of C_GATE_BIT:
--		(a_in and !b_in) is the D input to a FD with asynchronous
--		set/reset determined buy init_val
---------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added c_enable_rlocs generic		                 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_a_notb_fd_v4 IS
	GENERIC(init_val	: string  :="0";
		c_enable_rlocs	: integer := 1);
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		clk	: IN std_logic;
		rst	: IN std_logic;
		q_out	: OUT std_logic);
END and_a_notb_fd_v4;

ARCHITECTURE behavioral OF and_a_notb_fd_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL vcc   	: std_logic 	:= '1';
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL and_in	: std_logic_vector(1 DOWNTO 0);

	
BEGIN
	and_in(0) <= a_in;
	and_in(1) <= b_in;

and_fd:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> c_enable_rlocs,
      		C_GATE_TYPE 	=> 0,		--c_and
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "10", 
		C_AINIT_VAL 	=> init_val,
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> no,
		C_HAS_Q		=> yes,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> yes,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> fake_out,
		clk	=> clk,
		q	=> q_out,
		CE	=> vcc, 	
		AINIT 	=> rst, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);

END behavioral;
---------
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : nand_a_notb_fd.vhd
-- Function : A registered implementation of C_GATE_BIT:
--		(a_in nand !b_in) is the D input to a FD with asynchronous
--		set/reset determined buy init_val
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY nand_a_notb_fd_v4 IS
	GENERIC(init_val	: string :="0";
		c_enable_rlocs	: integer:=0);
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		clk	: IN std_logic;
		rst	: IN std_logic;
		q_out	: OUT std_logic);
END nand_a_notb_fd_v4;

ARCHITECTURE behavioral OF nand_a_notb_fd_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL vcc   	: std_logic 	:= '1';
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL nand_in	: std_logic_vector(1 DOWNTO 0);

	
BEGIN
	nand_in(0) <= a_in;
	nand_in(1) <= b_in;

nand_fd:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> yes,
      		C_GATE_TYPE 	=> 1,		--c_nand
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "10", 
		C_AINIT_VAL 	=> init_val,
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> no,
		C_HAS_Q		=> yes,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> yes,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> nand_in,
		O	=> fake_out,
		clk	=> clk,
		q	=> q_out,
		CE	=> vcc, 	
		AINIT 	=> rst, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_a_b_notc.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates 
--		A & B & !C
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_a_b_notc_v4 IS
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		c_in	: IN std_logic;
		and_out	: OUT std_logic);
END and_a_b_notc_v4;

ARCHITECTURE behavioral OF and_a_b_notc_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL and_in	: std_logic_vector(2 DOWNTO 0);
	
BEGIN
	and_in(0) <= a_in;
	and_in(1) <= b_in;
	and_in(2) <= c_in;
	
and_a_b_notc:C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 0,		--c_and
		C_INPUTS    	=> 3,
		C_INPUT_INV_MASK=> "100", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> and_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-----
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_a_b_c_notd.vhd
-- Function : A combinatorial implementation of C_GATE_BIT that generates 
--		A & B & C & !D
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_a_b_c_notd_v4 IS
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		c_in	: IN std_logic;
		d_in	: IN std_logic;
		and_out	: OUT std_logic);
END and_a_b_c_notd_v4;

ARCHITECTURE behavioral OF and_a_b_c_notd_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL and_in	: std_logic_vector(3 DOWNTO 0);
	
BEGIN
	and_in(3) <= a_in;
	and_in(2) <= b_in;
	and_in(1) <= c_in;
	and_in(0) <= d_in;
	
and_a_b_c_notd:C_GATE_BIT_V4_0 
   	GENERIC MAP (
      		C_GATE_TYPE 	=> 0,		--c_and
		C_INPUTS    	=> 4,
		C_INPUT_INV_MASK=> "0001", 
		C_AINIT_VAL 	=> "0",
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> yes,
		C_HAS_Q		=> no,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> no,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> and_out,
		clk	=> fake_in,
		q	=> fake_out,
		CE	=> fake_in, 	
		AINIT 	=> fake_in, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
--------

-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : or_fd.vhd
-- Function : A registered implementation of C_GATE_BIT:
--		(a_in or b_in) is the D input to a FD with asynchronous
--		set/reset determined buy init_val
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY or_fd_v4 IS
	GENERIC(init_val: string :="0");
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		clk	: IN std_logic;
		rst	: IN std_logic;
		q_out	: OUT std_logic);
END or_fd_v4;

ARCHITECTURE behavioral OF or_fd_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL or_in	: std_logic_vector(1 DOWNTO 0);
SIGNAL vcc   : std_logic := '1';
	
BEGIN
	or_in(0) <= a_in;
	or_in(1) <= b_in;

or_fd:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> yes,
      		C_GATE_TYPE 	=> 2,		--c_or
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> init_val,
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> no,
		C_HAS_Q		=> yes,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> yes,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> or_in,
		O	=> fake_out,
		clk	=> clk,
		q	=> q_out,
		CE	=> vcc, 	
		AINIT 	=> rst, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
--------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_fd.vhd
-- Function : A registered implementation of C_GATE_BIT:
--		(a_in and b_in) is the D input to a FD with asynchronous
--		set/reset determined buy init_val
---------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added c_enable_rlocs generic		                 --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY and_fd_v4 IS
	GENERIC(init_val	: string  :="0";
		c_enable_rlocs	: integer := 1);
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		clk	: IN std_logic;
		rst	: IN std_logic;
		q_out	: OUT std_logic);
END and_fd_v4;

ARCHITECTURE behavioral OF and_fd_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL vcc   	: std_logic 	:= '1';
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL and_in	: std_logic_vector(1 DOWNTO 0);

	
BEGIN
	and_in(0) <= a_in;
	and_in(1) <= b_in;

and_fd:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> c_enable_rlocs,
      		C_GATE_TYPE 	=> 0,		--c_and
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> init_val,
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> no,
		C_HAS_Q		=> yes,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> yes,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> and_in,
		O	=> fake_out,
		clk	=> clk,
		q	=> q_out,
		CE	=> vcc, 	
		AINIT 	=> rst, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;

-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : and_fd.vhd
-- Function : A registered implementation of C_GATE_BIT:
--		(a_in nand b_in) is the D input to a FD with asynchronous
--		set/reset determined buy init_val
-------------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added c_enable_rlocs generic		                 --
---------------------------------------------------------------------------


LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY nand_fd_v4 IS
	GENERIC(init_val	: string  :="0";
		c_enable_rlocs	: integer := 1);
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		clk	: IN std_logic;
		rst	: IN std_logic;
		q_out	: OUT std_logic);
END nand_fd_v4;

ARCHITECTURE behavioral OF nand_fd_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL vcc   	: std_logic 	:= '1';
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL nand_in	: std_logic_vector(1 DOWNTO 0);

	
BEGIN
	nand_in(0) <= a_in;
	nand_in(1) <= b_in;

nand_fd:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS	=> c_enable_rlocs,
      		C_GATE_TYPE 	=> 1,		--c_nand
		C_INPUTS    	=> 2,
		C_INPUT_INV_MASK=> "00", 
		C_AINIT_VAL 	=> init_val,
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> no,
		C_HAS_Q		=> yes,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> yes,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> nand_in,
		O	=> fake_out,
		clk	=> clk,
		q	=> q_out,
		CE	=> vcc, 	
		AINIT 	=> rst, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : or3_fd.vhd
-- Function : A registered implementation of C_GATE_BIT:
--		(a_in or b_in or c_in) is the D input to a FD with asynchronous
--		set/reset determined buy init_val
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;

ENTITY or3_fd_v4 IS
	GENERIC(init_val: string :="0");
	PORT (	a_in	: IN std_logic;
		b_in   	: IN std_logic;
		c_in	: IN std_logic;
		clk	: IN std_logic;
		rst	: IN std_logic;
		q_out	: OUT std_logic);
END or3_fd_v4;

ARCHITECTURE behavioral OF or3_fd_v4 IS
	CONSTANT no	: integer 	:= 0;
	CONSTANT yes	: integer 	:= 1;
	SIGNAL fake_in	: std_logic	:= '0';
	SIGNAL fake_out	: std_logic;
	SIGNAL or_in	: std_logic_vector(2 DOWNTO 0);
	SIGNAL vcc   	: std_logic 	:= '1';
	
BEGIN
	or_in(2) <= a_in;
	or_in(1) <= b_in;
	or_in(0) <= c_in;
	
or3_fd:C_GATE_BIT_V4_0 
   	GENERIC MAP (
   		C_ENABLE_RLOCS  => yes,
      		C_GATE_TYPE 	=> 2,		--c_or
		C_INPUTS    	=> 3,
		C_INPUT_INV_MASK=> "000", 
		C_AINIT_VAL 	=> init_val,
		C_SINIT_VAL 	=> "0",
		C_HAS_O		=> no,
		C_HAS_Q		=> yes,
		C_HAS_CE	=> no,
		C_HAS_ACLR	=> no,
		C_HAS_ASET	=> no,
		C_HAS_AINIT	=> yes,
		C_HAS_SCLR	=> no,
		C_HAS_SSET	=> no,
		C_HAS_SINIT	=> no) 
          PORT MAP (
          	I	=> or_in,
		O	=> fake_out,
		clk	=> clk,
		q	=> q_out,
		CE	=> vcc, 	
		AINIT 	=> rst, 
		ASET 	=> fake_in, 	
		ACLR 	=> fake_in, 	
		SINIT	=> fake_in,
		SSET	=> fake_in,	
		SCLR 	=> fake_in
		);
END behavioral;

---------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : count_sub_reg.vhd
-- Function : Same functionality of a_minus_b_fd, but this module has two 
--		reset inputs, either one active (='1') will cause the register 
--		to asynchronously change to all zeros (init_val = zerostring) 		
---------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By          : cde                                                    --
--              : Added generic width for non-symetirc support           --
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;


LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_ADDSUB_V4_0_COMP.ALL;
USE XilinxCoreLib.async_fifo_v4_0_components.ALL;
--USE WORK.async_fifo_v4_0_components.ALL;

ENTITY count_sub_reg_v4 IS
	GENERIC (
		width		: integer := 8; --GENERIC width greater of a_width, b_width
		a_width 	: integer := 4;
		b_width		: integer := 8;
		q_width		: integer := 2;
		c_enable_rlocs 	: integer := 1);
	PORT (	a_in	: IN std_logic_vector(a_width-1 DOWNTO 0);
		b_in	: IN std_logic_vector(b_width-1 DOWNTO 0);
		clk 	: IN std_logic; 			
		rst_a 	: IN std_logic;
		rst_b 	: IN std_logic;
		q_out	: OUT std_logic_vector(q_width-1 DOWNTO 0));
END count_sub_reg_v4;

ARCHITECTURE behavioral OF count_sub_reg_v4 IS


	CONSTANT no		: integer := 0;
	CONSTANT yes		: integer := 1;
	CONSTANT zerostring	: string(1 TO width+1) := (OTHERS => '0');
	CONSTANT initstring	: string(1 TO q_width) := (OTHERS => '0');
	SIGNAL dummy_in 	: std_logic := '0';
	SIGNAL load_0		: std_logic_vector(q_width-1 DOWNTO 0);
	SIGNAL load_1		: std_logic;
	SIGNAL load_2		: std_logic;
	SIGNAL load_3		: std_logic;
	SIGNAL load_4		: std_logic;		
	SIGNAL load_5		: std_logic;	
	SIGNAL load_6		: std_logic;
	SIGNAL reset		: std_logic;
	SIGNAL a		: std_logic_vector(width DOWNTO 0);
	SIGNAL b		: std_logic_vector(width DOWNTO 0);
	SIGNAL addsub_out	: std_logic_vector(q_width-1 DOWNTO 0);
	
	CONSTANT a_pad		: integer	:= (width - a_width);
	CONSTANT b_pad		: integer	:= (width - b_width);

BEGIN

a_input: FOR i IN 0 TO width GENERATE
--	BEGIN
	a1: IF (i = width) GENERATE
		a(i) <= '1';
	END GENERATE a1;	
	a2: IF ((i < width) AND (i >= a_pad)) GENERATE
		a(i) <= a_in(i - a_pad);
	END GENERATE a2;	
	a3: IF (i < (a_pad)) GENERATE
		a(i) <= '0';
	END GENERATE a3;	
END GENERATE a_input;

b_input: FOR i IN 0 TO width GENERATE
--	BEGIN
	b1: IF (i = width) GENERATE
		b(i) <= '0';
	END GENERATE b1;
	b2: IF ((i < width) AND (i >= b_pad)) GENERATE
		b(i) <= b_in(i - b_pad);
	END GENERATE b2;		
	b3: IF (i < b_pad) GENERATE
		b(i) <= '0';
	END GENERATE b3;		
END GENERATE b_input;

q_out <= addsub_out;
	
or_gate:or_a_b_v4
	PORT MAP (	a_in		=> rst_a,
			b_in 		=> rst_b,
			or_out		=> reset);

count_sub_reg:C_ADDSUB_V4_0
	GENERIC MAP (	C_ENABLE_RLOCS	=> c_enable_rlocs,
			C_A_WIDTH	=> (width+1),
			C_B_WIDTH	=> (width+1),
			C_OUT_WIDTH	=> (width+1),
			C_LOW_BIT	=> (width-q_width),
			C_HIGH_BIT	=> (width-1),
			C_ADD_MODE	=> 1,		--c_sub??????
			C_A_TYPE	=> 1,		--unsigned???
			C_B_TYPE	=> 1,		--unsigned???
			C_B_CONSTANT	=> no,
			C_B_VALUE	=> zerostring,
			C_AINIT_VAL	=> initstring,
			C_SINIT_VAL	=> initstring,	--SINIT not used
			C_SYNC_PRIORITY	=> 1,		--Not used (1=c_clear)
			C_SYNC_ENABLE	=> 1,		--Not used (1=c_no_override)
			C_BYPASS_ENABLE	=> no,		--BYPASS, Not used
			C_BYPASS_LOW	=> no,		--BYPASS, Not used
			C_PIPE_STAGES	=> 1,		--per spec 07/13/99
			C_HAS_S		=> no,		--Module is registered
			C_HAS_Q		=> yes,		--Use registered output of MUX
			C_HAS_C_IN	=> no,		--No C_IN pin
			C_HAS_C_OUT	=> no,		--No C_OUT pin			
			C_HAS_Q_C_OUT	=> no,		--No Q_C_OUT pin			
			C_HAS_B_IN	=> no,		--No B_IN pin
			C_HAS_B_OUT	=> no,		--No B_OUT pin
			C_HAS_Q_B_OUT	=> no,		--No Q_B_OUT pin
			C_HAS_OVFL	=> no,		--No OVFL pin
			C_HAS_Q_OVFL	=> no,		--No Q_OVFL pin
			C_HAS_CE	=> no,		--No CE pin
			C_HAS_ADD	=> no,		--No ADD pin
			C_HAS_BYPASS	=> no,		--No BYPASS pin
			C_HAS_A_SIGNED	=> no,		--No A_SIGNED pin
			C_HAS_B_SIGNED	=> no,		--No B_SIGNED pin
			C_HAS_ACLR	=> no,		--No ACLR pin
			C_HAS_ASET	=> no,		--No ASET pin
			C_HAS_AINIT	=> yes,		--AINIT used
			C_HAS_SCLR	=> no,		--No SCLR used
			C_HAS_SSET	=> no,		--No SSET used
			C_HAS_SINIT	=> no		--No SINIT used
			)
	PORT MAP ( 	A	=> a,
			B	=> b,
			Q	=> addsub_out,
			S	=> load_0,
			CLK	=> clk,
			ADD	=> dummy_in,
			OVFL	=> load_1,
			Q_OVFL	=> load_2,
			C_IN	=> dummy_in,
			C_OUT	=> load_3,
			Q_C_OUT	=> load_4,
			B_IN	=> dummy_in,
			B_OUT	=> load_5,
			Q_B_OUT	=> load_6,
			CE	=> dummy_in,
			BYPASS	=> dummy_in,
			A_SIGNED=> dummy_in,
			B_SIGNED=> dummy_in,
			ACLR	=> dummy_in,
			ASET	=> dummy_in,
			AINIT	=> reset,
			SCLR	=> dummy_in,
			SSET	=> dummy_in,
			SINIT	=> dummy_in
			);
END behavioral;


-------------------------------------------------------------------------------
-- Last modified on 09-26-00
-- Block was removed by jogden to fix CR regarding the empty flag causing
-- wr_count to reset. (CR# 126807)
-------------------------------------------------------------------------------
-- Last modified on 08/25/99
-- Name : pulse_reg.vhd
-- Function : pulse_reg is a asynchronous reset (AINIT = '0') flip-flop with 
--		both SCLR & SSET inputs (SCLR has proirity) SCLR is only active
--		if the and of sclr & q_out inputs are true.
-------------------------------------------------------------------------------
--
--LIBRARY IEEE;
--USE IEEE.std_logic_1164.ALL;
--
--
--LIBRARY XilinxCoreLib;
--USE XilinxCoreLib.C_REG_FD_V4_0_COMP.ALL;
--USE XilinxCoreLib.async_fifo_v4_0_components.ALL;
----USE WORK.async_fifo_v4_0_components.ALL;
--
--ENTITY pulse_reg_v4 IS
--	PORT (	sclr_in	: IN std_logic;
--		sset_in : IN std_logic;	
--		clk	: IN std_logic;
--		rst	: IN std_logic;
--		q_out	: OUT std_logic);
--END pulse_reg_v4;
--
--ARCHITECTURE behavioral OF pulse_reg_v4 IS
--	SIGNAL gnd	: std_logic := '0';
--	SIGNAL vcc	: std_logic := '1';
--	CONSTANT no	: integer := 0;
--	CONSTANT yes	: integer := 1;
--	SIGNAL sclr	: std_logic;
--	SIGNAL reg_out	: std_logic_vector(0 DOWNTO 0);
--	SIGNAL b_tmp	: std_logic;
--	
--BEGIN
--	q_out	<= reg_out(0);
--	b_tmp	<= reg_out(0);
--
--and_gate:and_a_b_v4
--	PORT MAP (	
--		a_in	=> sclr_in,
--		b_in   	=> b_tmp,
--		and_out	=> sclr);
--		
--reg_fd:C_REG_FD_V4_0
--	GENERIC MAP(
--		C_WIDTH 	=> 1, 
--		C_AINIT_VAL	=> "0",
--		C_SINIT_VAL	=> "0",		--SINIT not used
--		C_SYNC_PRIORITY	=> 1,		--Used (1=c_clear)
--		C_SYNC_ENABLE	=> 1,		--Not used (1=c_no_override)
--		C_HAS_CE	=> no,		--CE pin used
-- 		C_HAS_ACLR	=> no,		--No ACLR pin
--		C_HAS_ASET	=> no,		--No ASET pin
--		C_HAS_AINIT	=> yes,		--AINIT used
--		C_HAS_SCLR	=> yes,		--No SCLR pin
--		C_HAS_SSET	=> yes,		--No SSET pin
--		C_ENABLE_RLOCS	=> no,		--Not part of Behavorial Model//expected by XCC
--		C_HAS_SINIT	=> no		--No SINIT pin
--		)
--	PORT MAP ( 	
--		D		=> reg_out,	--Flop only controled by AINIT/SCLR/SSET
--		Q		=> reg_out,	--Registered Output
--		CLK		=> clk,
--		CE 		=> vcc,
--		ACLR		=> gnd,		--ACLR not used
--		ASET		=> gnd,		--ASET not used	
--		AINIT		=> rst,		
--		SCLR		=> sclr,
--		SSET		=> sset_in,
--		SINIT		=> gnd		--SINIT not used
--		);
--END behavioral;


-------------------------------------------------------------------------------
-- Name : or_gate_bit.vhd
-- Last modified on 08/25/99
-- Function : A wrapper that creates an entity that makes a n-bit gate bit xor
-- gate.  It uses the baseblox component C_GATE_BIT_BUS to accomplish this.
-- 07/08/99
-- Changes:
--	sourceless_net given an initial value of '0' to prevent ambiguity
--	Added SIGNAL dummy_load_0, as for unused output was connected to sourceless_net
--	This process shouldn't be REGISTERED!
--	clk and reset ports not needed
--	xor_out driven by O port not Q port of xor_mod:
-- 08/11/99
--	Changed architecture to xilinx
-------------------------------------------------------------------------------

LIBRARY ieee;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.C_GATE_BIT_V4_0_COMP.ALL;
USE XilinxCoreLib.PRIMS_CONSTANTS_V4_0.ALL;

ENTITY xor_gate_bit_v4 IS

   GENERIC ( input_width : integer:= 4);
   PORT    ( input  : IN std_logic_vector(input_width-1 DOWNTO 0);
             xor_out: OUT std_logic);

END xor_gate_bit_v4;

ARCHITECTURE behavioral OF xor_gate_bit_v4 IS


   FUNCTION zerostring (length: integer) RETURN string IS
      VARIABLE ans : string( 1 TO length);
   BEGIN

      FOR i IN 1 TO length LOOP
          ans(i) := '0';
      END LOOP;

      RETURN ans;
     
   END zerostring;

   SIGNAL sourceless_net : std_logic := '0';
   SIGNAL dummy_load_0: std_logic;

   
BEGIN

   xor_mod: C_GATE_BIT_V4_0 
      GENERIC MAP ( C_GATE_TYPE => c_xor,
                    C_INPUTS    => input_width,
                    C_INPUT_INV_MASK =>zerostring(input_width), 
                    C_AINIT_VAL => "0",
                    C_SINIT_VAL => "0",
                    C_HAS_O => 1,
                    C_HAS_Q => 0,
                    C_HAS_CE => 0,
                    C_HAS_ACLR => 0,
                    C_HAS_ASET => 0,
                    C_HAS_AINIT => 0,
                    C_HAS_SCLR => 0,
                    C_HAS_SSET => 0,
                    C_HAS_SINIT => 0 ) 
          PORT MAP (  I => input,
		    CLK => sourceless_net,	
		    CE => sourceless_net, 	
		    AINIT => sourceless_net, 
		    ASET => sourceless_net, 	
		    ACLR => sourceless_net, 	
		    SINIT => sourceless_net,
		    SSET => sourceless_net,	
		    SCLR => sourceless_net,	
		    Q    => dummy_load_0,
                    O    => xor_out
                    );
END behavioral;

-------------------------------------------------------------------------------
-- Name : Grey_to_binary_im.vhd
-- Last modified on 08/25/99
-- Function : This module converts grey encoded values to its counter part
-- binary representation. This doesn't use a brute force method.
-- Max input with is 16 bits. Can be implemented in 2 levels.
-- 08/02/99
-- Modified:  
--	to use reg_ainit (replaces reg_as), includes new generic init_val
--  	xor_gate bit has been changed to non-registered
-- 08/11/99
-- 	Modified: changed architecture to xilinx
-------------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.PRIMS_CONSTANTS_V4_0.ALL;
USE XilinxCoreLib.async_fifo_v4_0_components.ALL;
--USE WORK.async_fifo_v4_0_components.ALL;

--USE XilinxCoreLib.gray_to_binary_comp.ALL;

ENTITY gray_to_binary_v4 IS

   GENERIC (	num_of_bits	: integer := 8;
   		init_val	: string  := "00000001";
   		c_enable_rlocs	: integer := 1);
   PORT (	bin_reg		: OUT std_logic_vector(num_of_bits-1 DOWNTO 0);
             	grey_reg	: IN std_logic_vector(num_of_bits-1 DOWNTO 0);
             	reset  		: IN std_logic;
             	clk    		: IN std_logic);

END gray_to_binary_v4;

ARCHITECTURE behavioral OF gray_to_binary_v4 IS
  
   ----------------------------------------------------------------------------
   -- Function: port_rem
   -- Argument: bus_width_sub1 : INTEGER
   --           => width of the bus - 1  that needs to be XORed together
   -- Description: Returns the number of ports that needs to be connected
   -- to the XOR tree
   ----------------------------------------------------------------------------
   FUNCTION port_rem (bus_width_sub1: integer) RETURN integer IS
   BEGIN

      RETURN (bus_width_sub1+1) REM 4;
     
   END port_rem;

   ----------------------------------------------------------------------------
   -- Function : which_case
   -- Argument : bus_width_sub1 : INTEGER
   --            => width of the bus - 1 that needs to be XORed together
   -- Description: There are 4  cases to consider when building the XOR tree.
   --              This function determines which of these cases applies for
   --              the given width of the bus
   ----------------------------------------------------------------------------
   
   FUNCTION which_case (bus_width_sub1: integer) RETURN integer IS
   BEGIN

      -- Case 1 : bus width < 3
      -- Use 1 4-input xor gate
     
      IF (bus_width_sub1+1 < 4) THEN

         RETURN 1; 

      -- Case 2 : bus width is divisible by 4
      -- Create a 4-input xor gate, and if needed
      -- connect all the 4-input xor gate to produce correct
      -- output
         
      ELSIF ((bus_width_sub1+1) REM 4 = 0) THEN

         RETURN 2;

      -- Case 3 : bus_width/4 + (bus width rem 4) < 4
      -- Create a xor gate in the second logic level
      ELSIF ( port_rem(bus_width_sub1) + (bus_width_sub1+1)/4 ) <= 4 THEN

         RETURN 3;
         
      ELSIF ( port_rem(bus_width_sub1) + (bus_width_sub1+1)/4 ) > 4 THEN

      -- Case 4 : bus_width/4 + (bus width rem 4) > 4
      -- Create a xor gate in the first logic level for the (bus width rem 4)
      -- bits and then in the second level, connect it with the relevant 4-input
      -- xor gates to produce the correct output.

        RETURN 4;

      ELSE
      
	RETURN 0;        
       
      END IF;

   END which_case;


   -- Keep track of number of full 4-input XOR gates used in
   -- the first level
   CONSTANT num_xor4 : integer := num_of_bits/4;

   -- Keeps the output of the 4-input XOR gates in the first level
   -- Convention: xor4_l1(i) := is XOR of
   --                        (num_of_bits-1-4*i DOWNTO num_of_bits-4-4*i)
   
   SIGNAL xor4_l1: std_logic_vector(num_xor4-1 DOWNTO 0);

   -- Reversed version of the input (to simplify indexing)
   SIGNAL grey_reg_rev : std_logic_vector(grey_reg'range);

   -- Reversed version of the output (to simplify indexing)
   SIGNAL temp_out : std_logic_vector(grey_reg'range);

   -- The resulting output that feeds into the results register
   SIGNAL outr     : std_logic_vector(grey_reg'range);
  
   SIGNAL vcc      : std_logic:='1';  --vk added 7/21
BEGIN

  -- Reverse the input so that it'll be easier to process
  r1: FOR j IN 0 TO num_of_bits-1 GENERATE

     grey_reg_rev(num_of_bits-1-j) <= grey_reg(j);
    
  END GENERATE r1;

  -- Go through the loop num_of_bits-1 time
  -- (MSB is just passed through)
  l1: FOR i IN  1 TO num_of_bits-1 GENERATE


    -- First Case : Bus width is less than 4
    b1: BLOCK
      
        -- Number of inputs to be connected
        -- on the first level
        CONSTANT x      : integer := port_rem(i);

        -- Temp input vector
        SIGNAL xor_in : std_logic_vector( x-1 DOWNTO 0);
        
        
      BEGIN    
           c1: IF (which_case(i) = 1) GENERATE

           -- Assign the input
           s1a:FOR j IN xor_in'high DOWNTO xor_in'low GENERATE

              xor_in(j) <= grey_reg_rev(j);
             
           END GENERATE s1a;

           -- Generate appropriate XOR logic
           x1: xor_gate_bit_v4 GENERIC MAP (input_width => x)
                            PORT MAP ( input => xor_in,
                                       xor_out => temp_out(i)
                                      );

       END GENERATE c1;
   END BLOCK b1;

   -- Second Case : Bus width is divisible by 4
   b2: BLOCK

       -- Temp input vector for level 1 and 2
       SIGNAL xor_inl1 : std_logic_vector(3 DOWNTO 0);
       SIGNAL xor_inl2 : std_logic_vector(((i+1)/4)-1 DOWNTO 0);
       
   BEGIN

      c2: IF (which_case(i) = 2) GENERATE

         -- Assign level 1 input
         s2a: FOR j IN xor_inl1'high DOWNTO  xor_inl1'low GENERATE

              xor_inl1(xor_inl1'high-j) <= grey_reg_rev(i-j);
             
         END GENERATE s2a;
              
         -- Create first level 4-input xor_gate
         x2a: xor_gate_bit_v4 GENERIC MAP (input_width => xor_inl1'length)
                           PORT MAP  ( input => xor_inl1,
                                       xor_out => xor4_l1(((i+1)/4)-1)
                                     );
         
         -- If bus width is larger than 8 then must add the appropriate number
         -- of 4-inputs from 1st level to 2nd level and combine them
         x2b: IF (i+1 >= 8) GENERATE

             s2b: FOR j IN xor_inl2'low TO xor_inl2'high GENERATE

                xor_inl2(j) <= xor4_l1(j);
             
             END GENERATE s2b;
             
             x2b1: xor_gate_bit_v4 GENERIC MAP (input_width => xor_inl2'length)
                            PORT MAP    ( input => xor_inl2,
                                          xor_out => temp_out(i) 
                                        );
         END GENERATE x2b;

         -- If the first XOR gate, then the output is from the first level output
         s2c: IF i=3  GENERATE

             temp_out(i) <= xor4_l1(0);

         END GENERATE s2c;
         
      END GENERATE c2;

   END BLOCK b2;

      -- Case 3: If the num_of_bits is larger than 4 but
      -- num_of_bits rem 4 is less than available
      -- input in the second level, just add a second level

   b3: BLOCK

     -- number of inputs from the first level
     CONSTANT f     : integer := (i+1)/4;
     -- number of inputs that needs to be added
     CONSTANT x     :integer := port_rem(i);
     -- temp input
     SIGNAL xor_inl2: std_logic_vector((x+f)-1 DOWNTO 0);
     
   BEGIN

     c3: IF (which_case(i) = 3 ) GENERATE

       -- Assign inputs
       s3a: FOR j IN 0 TO x-1 GENERATE

         xor_inl2(j+f) <= grey_reg_rev(i-j); 
         
       END GENERATE s3a;

       s3b: FOR j IN 0 TO f-1 GENERATE

         xor_inl2(j) <= xor4_l1(j); 
         
       END GENERATE;
       
       -- Create xor logic on the second level
       x3b1: xor_gate_bit_v4 GENERIC MAP (input_width => (x+f))
         PORT MAP   ( input => xor_inl2,
                      xor_out => temp_out(i) 
                      );
     END GENERATE c3;
   END BLOCK b3;
        
   -- Case 4: If the num_of_bits is larger than 4 but the
   -- num_of_bits rem 4 is more than the avaiable input in the
   -- second level, must add a 2nd and a 1st level
         
   b4: BLOCK

      -- number of first level inputs
      CONSTANT f : integer := (i+1)/4;

      -- number of inputs that needs to be added
      CONSTANT x : integer := port_rem(i);

      -- Temp first level input
      SIGNAL xor_inl1: std_logic_vector(x-1 DOWNTO 0);

      -- Temp first level output
      SIGNAL xor_outl1 : std_logic;
      
      -- used f instead of f-1 since you have to propogate
      -- the output of the additional 1st level XOR gate
      -- (xor_outl1)
      SIGNAL xor_inl2: std_logic_vector(f DOWNTO 0);
         
        
   BEGIN

      c4: IF (which_case(i) = 4 ) GENERATE

        -- Assign the input signal for the first level
         s4a: FOR j IN xor_inl1'low TO xor_inl1'high GENERATE

             xor_inl1(j) <= grey_reg_rev(i-j);
          
         END GENERATE s4a;

         
         -- Create first level logic
         x4a1: xor_gate_bit_v4 GENERIC MAP (input_width => x)
                            PORT MAP   ( input => xor_inl1,
                                         xor_out => xor_outl1 
                                       );

        -- Assign the input signal for the second level
        xor_inl2(xor_inl2'high) <= xor_outl1;
         
        s4b: FOR j IN xor_inl2'low TO xor_inl2'high-1 GENERATE

            xor_inl2(j) <= xor4_l1(j);
              
        END GENERATE s4b;

        -- Create second level input
        x4b1: xor_gate_bit_v4 GENERIC MAP (input_width => f+1)
                           PORT MAP    (input => xor_inl2,
                                        xor_out => temp_out(i) 
                                       );
              
            
        END GENERATE c4;
        
     END BLOCK b4;

    END GENERATE l1;

    temp_out(0) <= grey_reg_rev(0);
         
     -- Reversed the temporary output signal to the outr vector
     r2: FOR j IN 0 TO num_of_bits-1 GENERATE

        outr(num_of_bits-1-j) <= temp_out(j);
    
     END GENERATE r2;

    -- Register the output
    reg1: reg_ainit_v4
    	GENERIC MAP(	reg_size 	=> num_of_bits,
    			init_val	=> init_val,
    			c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	rst		=> reset,
			clk		=> clk,
			cen		=> vcc,
			din		=> outr,
			qout 		=> bin_reg);
         
END behavioral;

---------------------------------------------------------------------------
--                                                                       --
--  Module      : fifoctlr_ns.vhd                                      --
--  Last modified on 09/23/99                                            --
--  Description : FIFO controller top level.                             --
--                Implements a generic FIFO control with independent     --
--                (potentially asynchronous) read/write clocks.		 --
--	                                                                 --
--  The following VHDL code implements a generic asynchronous FIFO       --
--  controler.  							 --
--									 --
-- 09/23/99: Implemention of two major changes				 --
--		A) Controller support on non-symetric read/write ports   --
--		B) Virtex specific optimization of full/empty/almost flags-
---------------------------------------------------------------------------

LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

LIBRARY XilinxCoreLib;
USE XilinxCoreLib.async_fifo_v4_0_components.ALL;
--USE work.async_fifo_v4_0_components.ALL;

ENTITY fifoctlr_ns_v4 IS
	GENERIC(width			: integer := 8;		--width is the smaller of
		wr_width		: integer := 8;
		rd_width		: integer := 8;
		c_enable_rlocs		: integer := 1;
		c_has_almost_full	: integer := 0;
		c_has_almost_empty	: integer := 0;
		c_has_wrsync_dcount	: integer := 0;
		wrsync_dcount_width	: integer := 2;
		c_has_rdsync_dcount	: integer := 0;
		rdsync_dcount_width	: integer := 4;
		c_has_rd_ack		: integer := 1;
		c_rd_ack_low		: integer := 0;
		c_has_rd_error		: integer := 1;
		c_rd_error_low		: integer := 0;
		c_has_wr_ack		: integer := 1;
		c_wr_ack_low		: integer := 0;
		c_has_wr_error		: integer := 1;
		c_wr_error_low		: integer := 0
		);
   	PORT (	fifo_reset_in	: IN std_logic;
		read_clock_in	: IN std_logic;
         	write_clock_in	: IN std_logic;
         	read_request_in	: IN std_logic;
         	write_request_in: IN std_logic;
         	read_enable_out	: OUT std_logic;
         	write_enable_out: OUT std_logic;
         	full_flag_out	: OUT std_logic;
         	empty_flag_out	: OUT std_logic;
		almost_full_out : OUT std_logic;
		almost_empty_out: OUT std_logic;
	   	read_addr_out	: OUT std_logic_vector (rd_width-1 DOWNTO 0);
	   	write_addr_out	: OUT std_logic_vector (wr_width-1 DOWNTO 0);
		wrsync_count_out: OUT std_logic_vector (wrsync_dcount_width-1 DOWNTO 0);
		rdsync_count_out: OUT std_logic_vector (rdsync_dcount_width-1 DOWNTO 0);
		read_ack	: OUT std_logic;
		read_error	: OUT std_logic;
		write_ack	: OUT std_logic;
		write_error	: OUT std_logic
		);
END fifoctlr_ns_v4 ;

ARCHITECTURE behavioral OF fifoctlr_ns_v4 IS

	CONSTANT no		: integer := 0;
	CONSTANT yes		: integer := 1;
	SIGNAL gnd		: std_logic := '0'; 	
	SIGNAL vcc		: std_logic := '1'; 
	SIGNAL reset		: std_logic;
	SIGNAL rd_clk		: std_logic;
	SIGNAL wr_clk		: std_logic;
	SIGNAL rd_en		: std_logic;
	SIGNAL rd_en_ram	: std_logic;
	SIGNAL wr_en		: std_logic;
	SIGNAL wr_en_ram	: std_logic;		
	SIGNAL full_flag	: std_logic;
	SIGNAL almost_full	: std_logic;
	SIGNAL rdsync_full_flag : std_logic;
	SIGNAL cond_full	: std_logic;
	SIGNAL cond_full_less1	: std_logic;
	SIGNAL cond_full_less2  : std_logic;
	SIGNAL empty_flag	: std_logic;
	SIGNAL almost_empty	: std_logic;
	SIGNAL cond_empty 	: std_logic;
	SIGNAL cond_empty_plus1 : std_logic;
	SIGNAL cond_empty_plus2 : std_logic;
	--SIGNAL wrsync_empty_pulse	: std_logic;  -- removed 9-26-00 by
                                                      --jogden for CR 126807
	SIGNAL rd_addr_bin		: std_logic_vector (rd_width-1 DOWNTO 0);
	SIGNAL rd_last_bin		: std_logic_vector (rd_width-1 DOWNTO 0);
	SIGNAL rd_last_gray		: std_logic_vector (rd_width-1 DOWNTO 0);
	SIGNAL rd_last_trunc		: std_logic_vector (width-1 DOWNTO 0);		
	SIGNAL rd_dly1_gray		: std_logic_vector (width-1 DOWNTO 0);
	SIGNAL rd_dly2_gray		: std_logic_vector (width-1 DOWNTO 0);
	SIGNAL wrsync_rd_last_gray	: std_logic_vector (rd_width-1 DOWNTO 0);
	SIGNAL wrsync_rd_last_bin	: std_logic_vector (rd_width-1 DOWNTO 0);
	SIGNAL wr_addr_bin		: std_logic_vector (wr_width-1 DOWNTO 0);
	SIGNAL wr_last_bin		: std_logic_vector (wr_width-1 DOWNTO 0);
	SIGNAL wr_last_gray		: std_logic_vector (wr_width-1 DOWNTO 0);
	SIGNAL wr_last_trunc		: std_logic_vector (width-1 DOWNTO 0);		
	SIGNAL wr_dly1_gray		: std_logic_vector (width-1 DOWNTO 0);
	SIGNAL rdsync_wr_last_gray	: std_logic_vector (wr_width-1 DOWNTO 0);
	SIGNAL rdsync_wr_last_bin	: std_logic_vector (wr_width-1 DOWNTO 0);
 	SIGNAL rdsync_data_count	: std_logic_vector (rdsync_dcount_width-1 DOWNTO 0); 
	SIGNAL wrsync_data_count	: std_logic_vector (wrsync_dcount_width-1 DOWNTO 0); 
	SIGNAL fflag_comb	: std_logic;
	SIGNAL eflag_comb	: std_logic;    
----------------------------------------------------------------
--                                                            --
--  FUNCTION gray_tc_string creates a string of appropriate   --
--  lenght for use as a init_val for gray_counters. A terminal--
--  count (tc) is created since the gray_conversion lags the  --
--  address counter by a clock cycle, we want the reset state --
--  of the gray counts to also lag the reset state of the     --
--  address count.					      --
--							      --
----------------------------------------------------------------	
FUNCTION zero_string (length: integer) RETURN string IS
	VARIABLE zeros : string(1 TO length);
	BEGIN
		FOR i IN 1 TO length LOOP
          		zeros(i) := '0';        			
      		END LOOP;
	RETURN zeros;
END zero_string;	

FUNCTION ones_string (length: integer) RETURN string IS
	VARIABLE ones : string(1 TO length);
	BEGIN
		FOR i IN 1 TO length LOOP
          		ones(i) := '1';        			
      		END LOOP;
	RETURN ones;
END ones_string;	

FUNCTION gray_tc_string (length: integer) RETURN string IS
	VARIABLE gray_tc : string(1 TO length);
	BEGIN
		FOR i IN 1 TO length LOOP
			IF (i = 1) THEN
          			gray_tc(i) := '1';
          		ELSE
          			gray_tc(i) := '0';
          		END IF;          			
      		END LOOP;
	RETURN gray_tc;
END gray_tc_string;	

FUNCTION gray_tc_less1 (length: integer) RETURN string IS
	VARIABLE gray_tc_less1a : string(1 TO length);
	BEGIN
		FOR i IN 1 TO length LOOP
			IF (i = 1) THEN
          			gray_tc_less1a(i) := '1';
          		ELSIF (i = length) THEN
          			gray_tc_less1a(i) := '1';
          		ELSE
          			gray_tc_less1a(i) := '0';
          		END IF;          			
      		END LOOP;
	RETURN gray_tc_less1a;
END gray_tc_less1;		

FUNCTION gray_tc_less2 (length: integer) RETURN string IS
	VARIABLE gray_tc_less2a : string(1 TO length);
	BEGIN
		FOR i IN 1 TO length LOOP
			IF (i = 1) THEN
          			gray_tc_less2a(i) := '1';
          		ELSIF (i = length) THEN
          			gray_tc_less2a(i) := '1';
          		ELSIF (i = (length-1)) THEN
          			gray_tc_less2a(i) := '1';
          		ELSE
          			gray_tc_less2a(i) := '0';
          		END IF;          			
      		END LOOP;
	RETURN gray_tc_less2a;
END gray_tc_less2;


FUNCTION gray_tc_less3 (length: integer) RETURN string IS
	VARIABLE gray_tc_less3a : string(1 TO length);
	BEGIN
		FOR i IN 1 TO length LOOP
			IF (i = 1) THEN
          			gray_tc_less3a(i) := '1';
          		ELSIF (i = (length-1)) THEN
          			gray_tc_less3a(i) := '1';
          		ELSE
          			gray_tc_less3a(i) := '0';
          		END IF;          			
      		END LOOP;
	RETURN gray_tc_less3a;
END gray_tc_less3;

FUNCTION get_greater(a: integer; b: integer) RETURN integer IS
	VARIABLE largest : integer;
	BEGIN
		IF (a > b) THEN
          		largest := a;
          	ELSE
          		largest := b;
          	END IF;          			
	RETURN largest; 
END get_greater;	

FUNCTION get_lesser (a: integer; b: integer) RETURN integer IS
	VARIABLE smallest : integer;
	BEGIN
		IF (a < b) THEN
          		smallest := a;
          	ELSE
          		smallest := b;
          	END IF;          			
	RETURN smallest;
END get_lesser;	
----------------------------------------------------------------

BEGIN
	reset 			<= fifo_reset_in;
	rd_clk 			<= read_clock_in;
	wr_clk 			<= write_clock_in;
	read_enable_out 	<= rd_en_ram;
	write_enable_out 	<= wr_en_ram;	
   	full_flag_out 		<= full_flag;
   	empty_flag_out 		<= empty_flag;
	almost_full_out 	<= almost_full;
	almost_empty_out 	<= almost_empty;
	read_addr_out 		<= rd_addr_bin;
	write_addr_out 		<= wr_addr_bin;
	rdsync_count_out 	<= rdsync_data_count;	
	wrsync_count_out 	<= wrsync_data_count;

----------------------------------------------------------------
-- rd/wr_last_gray are truncated for non-symetric FIFOs
----------------------------------------------------------------
rd_trunc:FOR i IN 1 TO width GENERATE
		rd_last_trunc(i-1) <= rd_last_gray((i-1)+(rd_width-width));
	END GENERATE rd_trunc;

wr_trunc:FOR i IN 1 TO width GENERATE
		wr_last_trunc(i-1) <= wr_last_gray((i-1)+(wr_width-width));
	END GENERATE wr_trunc;


read_blk: BLOCK	

BEGIN
----------------------------------------------------------------
--                                                            --
--  Allow flags determine whether FIFO control logic can      --
--  operate.  If read request is driven high, and the FIFO    --
--  is not Empty, then Reads are allowed.  Similarly, if the  --
--  write request SIGNAL is high, and the FIFO is not Full,   --
--  then Writes are allowed.                                  --
--                                                            --
----------------------------------------------------------------
-- rd_en <= (read_request_in AND NOT empty_flag);	      --	
----------------------------------------------------------------
rd_ctlr_blk: BLOCK	
	
	
BEGIN


rd_en_and:and_a_notb_v4	
	GENERIC MAP (
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (
		a_in	=> read_request_in,
		b_in	=> empty_flag,
		and_out	=> rd_en);
		
rd_en_to_ram:and_a_notb_v4
	GENERIC MAP (
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (
		a_in	=> read_request_in,
		b_in	=> empty_flag,
		and_out	=> rd_en_ram
		);
----------------------------------------------------------------
--  Generate read handshake signals (ACK/ERROR) if requested
----------------------------------------------------------------			
rd_error_hi: IF (c_has_rd_error = 1 AND c_rd_error_low = 0) GENERATE

--BEGIN
rd_error_fd:and_fd_v4
	GENERIC MAP (
		init_val	=> "0",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> read_request_in,
		b_in		=> empty_flag,		
		clk		=> rd_clk,
		rst		=> reset,
		q_out		=> read_error);	
END GENERATE;

rd_error_lo: IF (c_has_rd_error = 1 AND c_rd_error_low = 1) GENERATE
--BEGIN
rd_error_fd:nand_fd_v4
	GENERIC MAP (
		init_val	=> "1",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> read_request_in,
		b_in		=> empty_flag,		
		clk		=> rd_clk,
		rst		=> reset,
		q_out		=> read_error
		);	
END GENERATE;	

rd_ack_hi: IF (c_has_rd_ack = 1 AND c_rd_ack_low = 0) GENERATE
--BEGIN
rd_ack_fd:and_a_notb_fd_v4
	GENERIC MAP (
		init_val	=> "0",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> read_request_in,
		b_in		=> empty_flag,		
		clk		=> rd_clk,
		rst		=> reset,
		q_out		=> read_ack
		);	
END GENERATE;

rd_ack_lo: IF (c_has_rd_ack = 1 AND c_rd_ack_low = 1) GENERATE
--BEGIN
rd_ack_fd:nand_a_notb_fd_v4
	GENERIC MAP (
		init_val	=> "1",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> read_request_in,
		b_in		=> empty_flag,		
		clk		=> rd_clk,
		rst		=> reset,
		q_out		=> read_ack
		);	
END GENERATE;
END BLOCK rd_ctlr_blk;
----------------------------------------------------------------	
----------------------------------------------------------------
read_cnt: BLOCK


BEGIN


rd_addr_blk: BLOCK		
----------------------------------------------------------------
--                                                            --
--  Generation of Read address pointers.  The primary one is  --
--  binary (rd_addr_bin), and the Gray-code derivatives are   --
--  generated via pipelining the binary-to-Gray-code result.  --
--  The initial values are important, so they're in sequence. --
--  Gray-code addresses are used so that the registered       --
--  Full and Empty flags are always clean, and never in an    --
--  unknown state due to the asynchonous relationship of the  --
--  Read and Write clocks.  In the worst case scenario, Full  --
--  and Empty would simply stay active one cycle longer, but  --
--  it would not generate an error or give false values.      --
--                                                            --
----------------------------------------------------------------

BEGIN
	

rd_addr_counter:bcount_up_ainit_v4
	GENERIC MAP (
		cnt_size	=> rd_width,
		init_val	=> zero_string(rd_width), --was wr_width
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (
		init		=> reset,
		cen		=> rd_en,
		clk 		=> rd_clk,
		cnt 		=> rd_addr_bin
		);
rd_last_gray_reg:binary_to_gray_v4
	GENERIC MAP (
		reg_size	=> rd_width,
		init_val	=> gray_tc_string(rd_width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		rst 		=> reset,	
		clk 		=> rd_clk,
		cen		=> rd_en,
		bin 		=> rd_addr_bin,
		gray 		=> rd_last_gray
		);
END BLOCK rd_addr_blk;

--empty_blk:BLOCK
---------------------------------------------------------------
--                                                           --
--  Empty flag is set on reset (initial), or when gray       --
--  code counters are equal, or when there is one word in    --
--  the FIFO, and a Read operation will be performed on the  --
--  next read clock					     --
--                                                           --
---------------------------------------------------------------
	
--BEGIN

empty_flag_logic:empty_flag_reg_v4
	GENERIC MAP (
		addr_width	=> width,
		c_enable_rlocs	=> c_enable_rlocs)
   	PORT MAP(rst		=> reset,
		flag_clk	=> rd_clk,
		flag_ce1	=> read_request_in,
		flag_ce2	=> empty_flag,
		reg_clk		=> wr_clk,
		reg_ce		=> wr_en,		
		a_in		=> rd_last_trunc,
		b_in		=> wr_last_trunc,
		dlyd_out	=> wr_dly1_gray,
		flag_out	=> empty_flag,
		to_almost_logic	=> eflag_comb        	
		);		
---------------------------------------------------------------
--                                                           --
--  Almost Empty flag is set on reset (initial). Or when the --
--  read gray code counter (rd_last_gray) is equal or one    --
--  behind the last write gray code address(wr_lasy_gray,    --
--  wr_dly1_gray). Or when the rd_last_gray is equal to      --
--  wr_dly2_gray and a read operation is about to be per-    --
--  formed. (Note that the next two process and              --
--  wr_dly2_gray_grey represent the overhead for this 	     --
--  function 			                             --
--                                                           --
---------------------------------------------------------------
almost_empty_gen: IF (c_has_almost_empty = 1) GENERATE

--BEGIN
almst_empty_logic:almst_empty_v4
	GENERIC MAP (
		addr_width	=> width,
		c_enable_rlocs	=> c_enable_rlocs)
   	PORT MAP(rst		=> reset,
		flag_clk	=> rd_clk,
		flag_ce		=> vcc,
		reg_clk		=> wr_clk,
		reg_ce		=> wr_en,
		a_in		=> rd_last_trunc,
		b_in		=> wr_dly1_gray,
		rqst_in		=> read_request_in,
		flag_comb_in	=> eflag_comb,
		flag_q_in	=> empty_flag,
		flag_out	=> almost_empty        	
		);			
END GENERATE almost_empty_gen;
--END BLOCK empty_blk;
	
END BLOCK read_cnt;

END BLOCK read_blk;

----------------------------------------------------------------
write_blk: BLOCK
BEGIN
----------------------------------------------------------------
--  wr_en <= (write_request_in AND NOT full_flag);
----------------------------------------------------------------
wr_ctlr_blk: BLOCK
BEGIN
wr_en_and:and_a_notb_v4
	GENERIC MAP (
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in	=> write_request_in,
		b_in	=> full_flag,
		and_out	=> wr_en
		);
----------------------------------------------------------------
--  wr_en_ram <= (write_request_in AND NOT full_flag);
--  This is a shadow of wr_en to reduce fanout for performance
----------------------------------------------------------------
wr_en_to_ram:and_a_notb_v4	
	GENERIC MAP (
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in	=> write_request_in,
		b_in	=> full_flag,
		and_out	=> wr_en_ram
		);		
----------------------------------------------------------------
--  Generate write handshake signals (ACK/ERROR) if requested
----------------------------------------------------------------	
wr_error_hi: IF (c_has_wr_error = 1 AND c_wr_error_low = 0) GENERATE
--BEGIN
wr_error_fd:and_fd_v4
	GENERIC MAP (
		init_val	=> "0",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> write_request_in,
		b_in		=> full_flag,		
		clk		=> wr_clk,
		rst		=> reset,
		q_out		=> write_error);	
END GENERATE;

wr_error_lo: IF (c_has_wr_error = 1 AND c_wr_error_low = 1) GENERATE
--BEGIN
wr_error_fd:nand_fd_v4
	GENERIC MAP (
		init_val	=> "1",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> write_request_in,
		b_in		=> full_flag,		
		clk		=> wr_clk,
		rst		=> reset,
		q_out		=> write_error);	
END GENERATE;
		
wr_ack_hi: IF (c_has_wr_ack = 1 AND c_wr_ack_low = 0) GENERATE
--BEGIN
wr_ack_fd:and_a_notb_fd_v4
	GENERIC MAP (
		init_val	=> "0",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> write_request_in,
		b_in		=> full_flag,		
		clk		=> wr_clk,
		rst		=> reset,
		q_out		=> write_ack);	
END GENERATE;

wr_ack_lo: IF (c_has_wr_ack = 1 AND c_wr_ack_low = 1) GENERATE
--BEGIN
wr_ack_fd:nand_a_notb_fd_v4
	GENERIC MAP (
		init_val	=> "1",
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> write_request_in,
		b_in		=> full_flag,		
		clk		=> wr_clk,
		rst		=> reset,
		q_out		=> write_ack);	
END GENERATE;

END BLOCK wr_ctlr_blk;
----------------------------------------------------------------
----------------------------------------------------------------		

write_cnt: BLOCK

	
BEGIN


wr_addr_blk: BLOCK
			
	
BEGIN	
	

wr_addr_counter:bcount_up_ainit_v4
	GENERIC MAP (
		cnt_size	=> wr_width,
		init_val	=> zero_string(wr_width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP ( 
		init		=> reset,
		cen		=> wr_en,
		clk 		=> wr_clk,
		cnt 		=> wr_addr_bin
		);
wr_last_gray_reg:binary_to_gray_v4
	GENERIC MAP (
		reg_size	=> wr_width,
		init_val	=> gray_tc_string(wr_width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		rst 		=> reset,	
		clk 		=> wr_clk,
		cen		=> wr_en,
		bin 		=> wr_addr_bin,
		gray 		=> wr_last_gray
		);
END BLOCK wr_addr_blk;

---------------------------------------------------------------
--                                                           --
--  Full flag is set on reset (initial, but it is cleared    --
--  on the first valid write clock edge after reset is       --
--  de-asserted), or when Gray-code counters are one away    --
--  from being equal (the Write Gray-code address is equal   --
--  to the Last Read Gray-code address), or when the Next    --
--  Write Gray-code address is equal to the Last Read Gray-  --
--  code address, and a Write operation is about to be       --
--  performed.                                               --
--                                                           --
---------------------------------------------------------------
full_blk: BLOCK

		
BEGIN



rd_dly1_gray_reg:reg_ainit_v4
	GENERIC MAP (
		reg_size	=> width,
		init_val	=> gray_tc_less1(width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		rst 		=> reset,	
		clk 		=> rd_clk,
		cen		=> rd_en,
		din 		=> rd_last_trunc,
		qout 		=> rd_dly1_gray
		);
---------------------------------------------------------------
--                                                           --
--  Almost Full flag is set on reset (initial, but it is     --
--  cleared on the first valid write clock edge after reset  --
--  is de-asserted). Or when the write Gray-code address     --
--  (wr_last_gray) is equal one behind the Last Read Gray-   --
--  code address(rd_dly1_gray, rd_dly2_gray). Or when the    --
--  write_last_gray is equal to rd_dly3_gray and a Write     --
--  operation is about to be performed. Note that the next   --
--  two process and rd_dly3_grag_reg represent the overhead  --
--  for this function.                                       --
--                                                           --
---------------------------------------------------------------
gen_almost_full: IF (c_has_almost_full = 1) GENERATE
--BEGIN
almst_full_logic:almst_full_v4
	GENERIC MAP (
		addr_width	=> width,
		c_enable_rlocs	=> c_enable_rlocs)
   	PORT MAP(rst		=> reset,
		flag_clk	=> wr_clk,
		flag_ce		=> vcc,
		reg_clk		=> rd_clk,
		reg_ce		=> rd_en,
		a_in		=> wr_last_trunc,
		b_in		=> rd_dly2_gray,
		rqst_in		=> write_request_in,
		flag_comb_in	=> fflag_comb,
		flag_q_in	=> full_flag,
		flag_out	=> almost_full        	
		);
END GENERATE gen_almost_full;

full_flag_logic:full_flag_reg_v4
	GENERIC MAP (
		addr_width	=> width,
		c_enable_rlocs	=> c_enable_rlocs)
   	PORT MAP(rst		=> reset,
		flag_clk	=> wr_clk,
		flag_ce1	=> write_request_in,
		flag_ce2	=> full_flag,
		reg_clk		=> rd_clk,
		reg_ce		=> rd_en,		
		a_in		=> wr_last_trunc,
		b_in		=> rd_dly1_gray,
		dlyd_out	=> rd_dly2_gray,
		flag_out	=> full_flag,
		to_almost_logic	=> fflag_comb        	
		);			
END BLOCK full_blk;
END BLOCK write_cnt;

END BLOCK write_blk;

----------------------------------------------------------------
--                                                            --
--  Generation of data_count output.  data_count reflects how --
--  full FIFO is, based on how far the Write pointer is ahead --
--  of the Read pointer. data_count will lag true FIFO state  --
--  by a couple of clock cycles, if the enables are inactive  --
--  for a few cycles data_count will converge to match FIFO's --
--  data_count could be made synchronous to either clock      --
--  domain. The following code uses the write clock domain    --
--							      --
----------------------------------------------------------------
wrsync_dcount_blk: BLOCK


BEGIN	

gen_wrsync_dcount: IF (c_has_wrsync_dcount = 1) GENERATE
wr_last_bin_reg:reg_ainit_v4
	GENERIC MAP (
		reg_size	=> wr_width,
		init_val	=> ones_string(wr_width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		rst 		=> reset,	
		clk 		=> wr_clk,
		cen		=> wr_en,
		din 		=> wr_addr_bin,
		qout 		=> wr_last_bin); 

wrsync_rd_last_gray_reg:reg_ainit_v4
	GENERIC MAP (
		reg_size	=> rd_width,
		init_val	=> gray_tc_string(rd_width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		rst 		=> reset,	
		clk 		=> wr_clk,
		cen		=> vcc,
		din 		=> rd_last_gray,
		qout 		=> wrsync_rd_last_gray); 

wrsync_rd_last_bin_reg:gray_to_binary_v4
	GENERIC MAP (
		num_of_bits     => rd_width,
                init_val        => ones_string(rd_width), -- fixed wr_count mismatch , robertle --gray_tc_string(rd_width),
                c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		bin_reg         => wrsync_rd_last_bin,
                grey_reg        => wrsync_rd_last_gray,
                reset           => reset,
                clk             => wr_clk); 

-------------------------------------------------------------------------------
-- This block removed 9/26/00 by jogden to fix CR where empty flag was
--   causing wr_count to reset. (CR 126807)
-------------------------------------------------------------------------------
--wrsync_empty_pulse_fd:pulse_reg_v4	
--	PORT MAP (
--		sclr_in		=> wr_en,
--		sset_in		=> empty_flag,	
--		clk		=> wr_clk,
--		rst		=> reset,
--		q_out		=> wrsync_empty_pulse);

wrsync_data_count_sub:count_sub_reg_v4
	GENERIC MAP (
		width		=> get_greater(wr_width, rd_width),
		a_width		=> wr_width,
		b_width		=> rd_width,
		q_width		=> wrsync_dcount_width,
		c_enable_rlocs 	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> wr_last_bin,
		b_in		=> wrsync_rd_last_bin,
		clk 		=> wr_clk,
		rst_a		=> reset,
		--rst_b		=> wrsync_empty_pulse,
                rst_b           => gnd,  -- Connection removed 9-26-00
                                         -- by jogden to fix CR 126807
                                         -- regarding empty pulse
                                         -- resetting wrsync_data_count
		q_out		=> wrsync_data_count);
		
END GENERATE;
END BLOCK wrsync_dcount_blk;
 
----------------------------------------------------------------
--                                                            --
--  Generation of data_count output.  data_count reflects how --
--  full FIFO is, based on how far the Write pointer is ahead --
--  of the Read pointer. data_count will lag true FIFO state  --
--  by a couple of clock cycles, if the enables are inactive  --
--  for a few cycles data_count will converge to match FIFO's --
--  data_count could be made synchronous to either clock      --
--  domain. The following code uses the read clock domain     --
--							      --
----------------------------------------------------------------
rdsync_dcount_blk: BLOCK

BEGIN
gen_rdsync_dcount: IF (c_has_rdsync_dcount = 1) GENERATE
rd_last_bin_reg:reg_ainit_v4
	GENERIC MAP (
		reg_size	=> rd_width,
		init_val	=> ones_string(rd_width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		rst 		=> reset,	
		clk 		=> rd_clk,
		cen		=> rd_en,
		din 		=> rd_addr_bin,
		qout 		=> rd_last_bin); 

rdsync_wr_last_gray_reg:reg_ainit_v4
	GENERIC MAP (
		reg_size	=> wr_width,
		init_val	=> gray_tc_string(wr_width),
		c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		rst 		=> reset,	
		clk 		=> rd_clk,
		cen		=> vcc,
		din 		=> wr_last_gray,
		qout 		=> rdsync_wr_last_gray); 
		

rdsync_wr_last_bin_reg:gray_to_binary_v4
	GENERIC MAP (
		num_of_bits     => wr_width,
                init_val        => ones_string(wr_width),
                c_enable_rlocs	=> c_enable_rlocs)
	PORT MAP (	
		bin_reg         => rdsync_wr_last_bin,
                grey_reg        => rdsync_wr_last_gray,
                reset           => reset,
                clk             => rd_clk); 

rdsync_data_count_sub:count_sub_reg_v4
	GENERIC MAP (
		width	 	=> get_greater(wr_width, rd_width),
		a_width		=> wr_width,
		b_width		=> rd_width,
		q_width		=> rdsync_dcount_width,
		c_enable_rlocs 	=> c_enable_rlocs)
	PORT MAP (	
		a_in		=> rdsync_wr_last_bin,
		b_in		=> rd_last_bin,
		clk 		=> rd_clk,			
		rst_a		=> reset,
		rst_b		=> reset,
		q_out		=> rdsync_data_count);
		
END GENERATE;
END BLOCK rdsync_dcount_blk;
		
----------------------------------------------------------------
--                                                            --
--  The four conditions decoded with special carry logic are  --
--  cond_empty, cond_empty_plus1, cond_full, cond_full_less1. --
--  These are used to determine the next state of the         --
--  Full/Empty flags.                                         --
--                                                            --
--  When the Write/Read Gray-code addresses are equal, the    --
--  FIFO is Empty, and cond_empty (combinatorial) is asserted.--
--  When the Write Gray-code address is equal to the Next     --
--  Read Gray-code address (1 word in the FIFO), then the     --
--  FIFO potentially could be going Empty (if rd_en is        --
--  asserted, which is used in the logic that generates the   --
--  registered version of Empty(empty_flag)).                 --
--                                                            --
--  Similarly, when the Write Gray-code address is equal to   --
--  the Last Read Gray-code address, the FIFO is full.  To    --
--  have utilized the full address space (512 addresses)      --
--  would have required extra logic to determine Full/Empty   --
--  on equal addresses, and this would have slowed down the   --
--  overall performance.  Lastly, when the Next Write Gray-   --
--  code address is equal to the Last Read Gray-code address  --
--  the FIFO is Almost Full, with only one word left, and     --
--  it is conditional on write_enable being asserted.         --
--                                                            --
----------------------------------------------------------------

END behavioral;

---------------------------------------------------------------------------
--                                                                       --
--  Module      : async_fifo.vhd                                         --
--  Last modified on 08/25/99                                            -- 
--  By	        : veena                                                  --
-- 		: Added ccdir library and attribute statements           --
--  Description : Async FIFO top level.                                  --
--                Implements a generic Asynchronous FIFO independent     --
--                (potentially asynchronous) read/write clocks.		 --
--	                                                                 --
--  The following VHDL code implements a generic asynchronous FIFO.      --
---------------------------------------------------------------------------
--  Last modified on 09/08/99                                            -- 
--  By	        : cde                                                    --
-- 		: Added c_enable_rlocs generic to memory(.vhd)           --
---------------------------------------------------------------------------
--  Last modified on 09/23/99                                            -- 
--  By	        : cde                                                    --
-- 		: Changed instantiation of fifoctlr_bb to fifoctlr_ns    --
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--  Last modified on 10/21/99                                            -- 
--  By	        : veena                                                  --
-- 		: Removed refs to backup ports and generics              --
---------------------------------------------------------------------------
--  Last modified on 10/25/99                                            -- 
--  By	        : veena(cde)                                             --
-- 		: Memory has three new generics				 --
--		: fifoctlr_ns modified (widths)	 --
---------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
LIBRARY XilinxCoreLib;
USE XilinxCoreLib.PRIMS_CONSTANTS_V4_0.ALL;
USE XilinxCoreLib.PRIMS_COMPS_V4_0.ALL;
USE XilinxCoreLib.async_fifo_v4_0_pkg.ALL;
USE XilinxCoreLib.async_fifo_v4_0_components.ALL;
--USE work.async_fifo_v4_0_components.ALL;

ENTITY async_fifo_v4_0 IS
    GENERIC (c_enable_rlocs         : integer := 0;
             c_data_width           : integer := 16;
             c_fifo_depth           : integer := 63;
             c_has_almost_full      : integer := 1;
             c_has_almost_empty     : integer := 1;
             c_has_wr_count         : integer := 1;
             c_has_rd_count         : integer := 1;             
             c_wr_count_width       : integer := 2;
	     c_rd_count_width       : integer := 2;
	     c_has_rd_ack	    : integer := 0;
	     c_rd_ack_low	    : integer := 0;
	     c_has_rd_err	    : integer := 0;
             c_rd_err_low	    : integer := 0;
	     c_has_wr_ack	    : integer := 0;
	     c_wr_ack_low	    : integer := 0;
	     c_has_wr_err	    : integer := 0;
	     c_wr_err_low	    : integer := 0;
             c_use_blockmem         : integer := 1   
            );
 
       PORT (din            : IN std_logic_vector(c_data_width-1 DOWNTO 0) := (OTHERS => '0');  
             wr_en          : IN std_logic := '0';
             wr_clk         : IN std_logic := '0';
             rd_en          : IN std_logic := '0';
             rd_clk         : IN std_logic := '0';
             ainit          : IN std_logic := '0';   
	     dout           : OUT std_logic_vector(c_data_width-1 DOWNTO 0);		
             full           : OUT std_logic; 
             empty          : OUT std_logic; 
             almost_full    : OUT std_logic;  
             almost_empty   : OUT std_logic;  
             wr_count       : OUT std_logic_vector(c_wr_count_width-1 DOWNTO 0);
             rd_count       : OUT std_logic_vector(c_rd_count_width-1 DOWNTO 0);
             rd_ack	    : OUT std_logic;
             rd_err  	    : OUT std_logic;
             wr_ack	    : OUT std_logic;
             wr_err         : OUT std_logic
             );



END async_fifo_v4_0;

ARCHITECTURE behavioral OF async_fifo_v4_0 IS

  SIGNAL write_address           : std_logic_vector(log2roundup(c_fifo_depth+1)-1 DOWNTO 0);
  SIGNAL read_address            : std_logic_vector(log2roundup(c_fifo_depth+1)-1 DOWNTO 0);	
  SIGNAL qualified_read_enable   : std_logic;
  SIGNAL qualified_write_request : std_logic;
  

BEGIN               

mem: memory_v4 GENERIC MAP (
                         use_blockmem	=> c_use_blockmem=1,
			 c_enable_rlocs	=> c_enable_rlocs,		
                         address_width 	=> log2roundup(c_fifo_depth+1),
			 rd_addr_width	=> log2roundup(c_fifo_depth+1),		
                         depth		=> c_fifo_depth+1,
			 rd_depth	=> c_fifo_depth+1,			
                         data_width	=> c_data_width,
                         rd_data_width	=> c_data_width)  			
           PORT MAP     (
                         d    => din,
                         wa   => write_address,
                         we   => qualified_write_request,
                         wclk => wr_clk,
                         re   => qualified_read_enable,
                         rclk => rd_clk,
                         ra   => read_address,
                         q    => dout);

control: fifoctlr_ns_v4 GENERIC MAP (
				width			=> log2roundup(c_fifo_depth+1),
				wr_width		=> log2roundup(c_fifo_depth+1),
                                rd_width                => log2roundup(c_fifo_depth+1),
				c_enable_rlocs          => c_enable_rlocs,
				c_has_almost_full	=> c_has_almost_full,
				c_has_almost_empty	=> c_has_almost_empty,
				c_has_wrsync_dcount	=> c_has_wr_count,
				wrsync_dcount_width	=> c_wr_count_width,
				c_has_rdsync_dcount	=> c_has_rd_count,
				rdsync_dcount_width	=> c_rd_count_width,
                                c_has_rd_ack            => c_has_rd_ack,
                                c_rd_ack_low            => c_rd_ack_low,
                                c_has_rd_error          => c_has_rd_err,
                                c_rd_error_low          => c_rd_err_low,
                                c_has_wr_ack            => c_has_wr_ack,
                                c_wr_ack_low            => c_wr_ack_low,
                                c_has_wr_error          => c_has_wr_err,
                                c_wr_error_low          => c_wr_err_low
                                )
   	              PORT MAP (fifo_reset_in	=> ainit,
		               read_clock_in	=> rd_clk,
         	               write_clock_in	=> wr_clk,
         	               read_request_in	=> rd_en,
         	               write_request_in => wr_en,
         	               read_enable_out	=> qualified_read_enable, 
         	               write_enable_out => qualified_write_request,
         	               full_flag_out	=> full,
         	               empty_flag_out	=> empty,
		               almost_full_out  => almost_full,
		               almost_empty_out => almost_empty,
	   	               read_addr_out	=> read_address,
	   	               write_addr_out	=> write_address,
	   	               wrsync_count_out => wr_count,
		               rdsync_count_out => rd_count,
                               read_ack         => rd_ack,
                               read_error       => rd_err,
                               write_ack        => wr_ack,
                               write_error      => wr_err
                               ); 
END behavioral;    


