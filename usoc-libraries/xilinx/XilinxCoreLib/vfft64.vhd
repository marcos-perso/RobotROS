library xilinxcorelib;
	use xilinxcorelib.vfft_utils.all;
	

-------------------------------------------------------------------------------
--$Id: vfft64.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
--
-- vfft64 behv model
--
-------------------------------------------------------------------------------
--                                                                       
-- This file is owned and controlled by Xilinx and must be used solely   
-- for design, simulation, implementation and creation of design files   
-- limited to Xilinx devices or technologies. Use with non-Xilinx        
-- devices or technologies is expressly prohibited and immediately       
-- terminates your license.                                              
--                                                                       
-- Xilinx products are not intended for use in life support              
-- appliances, devices, or systems. Use in such applications is          
-- expressly prohibited.                                                 
--
--            **************************************
--            ** Copyright (C) 2000, Xilinx, Inc. **
--            ** All Rights Reserved.             **
--            **************************************
--
-------------------------------------------------------------------------------
--
-- Filename: vfft64.vhd
--
-- Description: 
--  This is the behv model for the 64-point complex forward/inverse FFT 
--	This Core is a point solution.	
--                      
-------------------------------------------------------------------------------



library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;	
	use xilinxcorelib.fft_defs_64.all;
	
-- synopsys translate_off 	
library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on

entity vfft64 is
	port(
		clk		: in std_logic;
		rs		: in std_logic;
		start		: in std_logic;
		ce		: in std_logic;
		scale_mode	: in std_logic;				-- rank 0 scaling  cntrl									
		di_r		: in std_logic_vector(B-1 downto 0);
		di_i		: in std_logic_vector(B-1 downto 0);
		fwd_inv		: in std_logic;				-- forward/inverse (1/0) FFT
		io_mode0	: in std_logic;				-- =0 -> one-time event									-- =1 -> continuous back-to-back							
		io_mode1	: in std_logic;	
		mwr		: in std_logic;
		mrd		: in std_logic;
		ovflo		: out std_logic;			-- internal arithmetic overflow
		result		: out std_logic;			-- indicates final processing pass
		mode_ce		: out std_logic;
		done		: out std_logic;			-- end FFT clk pulse
		edone		: out std_logic;			-- early done strb
		io		: out std_logic;			-- IO cycle pending
		eio		: out std_logic;		
		bank		: out std_logic;
		busy		: out std_logic;			-- core activity indicator
		wea		: out std_logic;			-- mem. wr enable	
		wea_x		: out std_logic;
		wea_y		: out std_logic;
		web_x		: out std_logic;
		web_y		: out std_logic;
		ena_x		: out std_logic;
		ena_y		: out std_logic;
		index		: out std_logic_vector(log2_nfft-1 downto 0);	-- out re-ordering index
		addrr_x		: out std_logic_vector(log2_nfft-1 downto 0);	-- mem read addr bus		
		addrr_y		: out std_logic_vector(log2_nfft-1 downto 0);		
		addrw_x		: out std_logic_vector(log2_nfft-1 downto 0);
		addrw_y		: out std_logic_vector(log2_nfft-1 downto 0);		
		xk_r		: out std_logic_vector(B-1 downto 0);	-- xform output bus - Re
		xk_i		: out std_logic_vector(B-1 downto 0)	-- xform output bus - Im
	    );
end vfft64; 

architecture behavioral of vfft64 is

	-- operand read address generation
	-- This counter supplies a series of multiplexors that are used to generate

	signal	fft_rd_addr		: std_logic_vector(log2_nfft-1 downto 0);	-- FFT input data rd addr

	signal	fft_wr_addr		: std_logic_vector(log2_nfft-1 downto 0); -- FFT result write addr

	signal	wr			: std_logic_vector(B-1 downto 0); -- Re(phase factor)
	signal	wi			: std_logic_vector(B-1 downto 0); -- Im(phase factor)

	-- output from dragonfly processor
	signal	dfly_r_tmp		: std_logic_vector(B downto 0);
	signal	dfly_i_tmp		: std_logic_vector(B downto 0);
	-- 2's complement control for output of dragonfly complex multiplier
	signal	dfly_2comp		: std_logic;	

	signal wr_agen_start		: std_logic; -- start for FFT write addr. generator
	signal wr_agen_start_tmp	: std_logic;
	signal xk_r_tmp			: std_logic_vector(B downto 0);
	signal xk_i_tmp			: std_logic_vector(B downto 0);
	signal rank_eq_0		: std_logic;
	signal scale_enable		: std_logic;
	-- controls conjugation of the dragonfly output
	signal dragonfly_conj		: std_logic;

	signal xk_r_muxo		: std_logic_vector(B-1 downto 0);
	signal xk_i_muxo		: std_logic_vector(B-1 downto 0);
	
	signal phase_agen_ce		: std_logic;	-- ce for phase factor generator module
	signal dragan_stall		: std_logic;
	signal r			: std_logic;
	
	signal dfly_conj		: std_logic;
	signal null0			: std_logic;
	signal null1			: std_logic;
	signal logic0			: std_logic;
	signal logic1			: std_logic;

	-- registered 'fwd_in' signal. ('fwd_inv' is presented by the user)
	signal	fwd_inv_r		: std_logic;	
		
	-- used for building the 2's comp logic that controls the post
	--  cmplx mult complementor
	signal	fwd_inv_r_tmp		: std_logic;
	-- the post cmplx mult comp. control signal	
	signal	fwd_inv_rz		: std_logic;
	-- registered scale_mode pin used internally by the core
	signal	scale_mode_r		: std_logic;	
	
	-- internal signals
	signal	mode_ce_i		: std_logic;	
	signal	result_i		: std_logic;
	signal	done_i			: std_logic;
	signal	edone_i			: std_logic;
	signal	busy_i			: std_logic;
	signal	nxt_addr		: std_logic;
	signal	bank_i			: std_logic;
	signal	ebank_i			: std_logic;	
	signal	addrwx_i		: std_logic_vector(log2_nfft-1 downto 0);
	
component z16w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;

component z17w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;
					
component cmplx_reg16
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		dr		: in std_logic_vector(B-1 downto 0);	-- Re/Im data in
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);	-- Re/Im data out
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end component;
	
component xmux2w16
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		x0r		: in std_logic_vector(B-1 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(B-1 downto 0);
		x1r		: in std_logic_vector(B-1 downto 0);	
		x1i		: in std_logic_vector(B-1 downto 0);
		yr		: out std_logic_vector(B-1 downto 0);	-- mux outputs
		yi		: out std_logic_vector(B-1 downto 0)
	      );
end component;
			
-- i/O control signal generation

component fft_cntrl_64
	port(
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		start		: in std_logic;
		mode		: in std_logic;
		mwr		: in std_logic;
		addrw		: in std_logic_vector(log2_nfft-1 downto 0);
		busy		: out std_logic;
		wren		: out std_logic;
		wren1		: out std_logic;
		wrenx		: out std_logic;
		wreny		: out std_logic;		
		web_x		: out std_logic;
		web_y		: out std_logic;
		enax		: out std_logic;
		enay		: out std_logic;
		io		: out std_logic;
		eio		: out std_logic;		
		result		: out std_logic;
		mode_ce		: out std_logic;
		done		: out std_logic;
		edone		: out std_logic;	-- early done strobe
		bank		: out std_logic;
		ebank		: out std_logic;
		nxt_addr	: out std_logic;
		rank_eq_0	: out std_logic		-- true when rank == 0
							-- *** FROM THE MEMORY WRITE	
							-- perspective						-- PERSPECTIVE **								
	);
end component;
	
-- operand read address generator
component fft_rd_agen_64
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		mrd		: in std_logic;
		mwr		: in std_logic;	
		io_mode0	: in std_logic;
		io_mode1	: in std_logic;
		bank		: in std_logic;
		nxt_addr	: in std_logic;	
		fft_rd_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_rd_addry	: out std_logic_vector(log2_nfft-1 downto 0)
	);
end component;
			
-- result write address generator
component fft_wr_agen_64
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		gstart		: in std_logic;
		busy		: in std_logic;
		nxt_addr	: in std_logic;
		io_mode1	: in std_logic;
		mwr		: in std_logic;
		bank		: in std_logic;
		fft_wr_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addrx	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addry	: out std_logic_vector(log2_nfft-1 downto 0);				
		index		: out std_logic_vector(log2_nfft-1 downto 0)
	);
end component;

-- phase factor generator
component phase_factors_64
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;
    	    result		: in std_logic;	    	    
    	    sinn		: out std_logic_vector(B-1 downto 0);	-- cos()
    	    coss		: out std_logic_vector(B-1 downto 0);	-- sin()
    	    comp		: out std_logic
    );
end component;

component dragonfly_64
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		start		: in std_logic;		-- start transform
		ce		: in std_logic;		-- master clk enable
		conj		: in std_logic;
		xnr		: in std_logic_vector(B-1 downto 0);
		xni		: in std_logic_vector(B-1 downto 0);
		wr		: in std_logic_vector(B-1 downto 0);	-- phase factors
		wi		: in std_logic_vector(B-1 downto 0);
		xk_r		: out std_logic_vector(B downto 0);
		xk_i		: out std_logic_vector(B downto 0)
	      );
end component;

-- The 2's complementor is used in conjunction with the cmplx mul for handling
-- multiplication by 1

component xdsp_tcompw17
 port( 	a		: in   std_logic_vector(B downto 0);
        bypass		: in   std_logic;
        clk		: in   std_logic;
        ce		: in   std_logic;
        q		: out  std_logic_vector(B+1 downto 0));
end component;

attribute RLOC : string;
--attribute RLOC of omega : label is "R5C20";
attribute RLOC of dfly_r_2comp : label is "R0C31";
attribute RLOC of dfly_i_2comp : label is "R14C31";
attribute RLOC of dfly : label is "R0C4";
--attribute RLOC of xk_mux : label is "R12C17";

begin

fft_cntrl_proc : fft_cntrl_64
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		start		=> start,
		mode		=> io_mode0,
		mwr		=> mwr,
		addrw		=> addrwx_i,
		busy		=> busy_i,
		wren		=> wea,
		wrenx		=> wea_x,
		wreny		=> wea_y,		
		web_x		=> web_x,
		web_y		=> web_y,
		enax		=> ena_x,
		enay		=> ena_y,
		io		=> io,
		eio		=> eio,		
		result		=> result_i,
		mode_ce		=> mode_ce_i,
		done		=> done_i,
		edone		=> edone_i,
		bank		=> bank_i,
		ebank		=> ebank_i,
		nxt_addr	=> nxt_addr,
		rank_eq_0	=> rank_eq_0
	);
	 		
rd_agen: fft_rd_agen_64
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		start		=> start,
		mrd		=> mrd,
		mwr		=> mwr,
		io_mode0	=> io_mode0,
		io_mode1	=> io_mode1,
		bank		=> ebank_i,
		nxt_addr	=> nxt_addr,
		fft_rd_addr	=> addrr_x,
		fft_rd_addry	=> addrr_y
	);

wr_agen: fft_wr_agen_64
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		start		=> wr_agen_start,
		gstart		=> start,
		busy		=> busy_i,
		nxt_addr	=> nxt_addr,
		io_mode1	=> io_mode1,
		mwr		=> mwr,
		bank		=> bank_i,
		fft_wr_addrx	=> addrwx_i,
		fft_wr_addry	=> addrw_y,				
		index		=> index
	);

wr_addr_start : z16w1 
	port map (
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		din		=> start,
		dout		=> wr_agen_start
	);
		
omega : phase_factors_64
	port map(
		clk		=> clk,
		ce		=> ce,		--phase_agen_ce,
		start		=> start,
		rs		=> rs,
		result		=> result_i,
		sinn		=> wi,
		coss		=> wr,
		comp		=> dfly_2comp
	);

-- dragonfly processor

dfly: dragonfly_64 
	port map (
		clk		=> clk,
		rs		=> rs,
		start		=> start,
		ce		=> ce,
		conj		=> dfly_conj,		
		xnr		=> di_r,
		xni		=> di_i,
		wr		=> wr,
		wi		=> wi,
		xk_r		=> dfly_r_tmp,
		xk_i		=> dfly_i_tmp
	      );

-- The 2's complementor is connected to the back-end of the complex multiplier.
-- It is used for handling multiplication by 1.
		 
dfly_r_2comp: xdsp_tcompw17 
	port map (
		a		=> dfly_r_tmp,
        	bypass		=> dfly_2comp,
        	clk		=> clk,
        	ce		=> ce,
        	q(B downto 0)	=> xk_r_tmp,
        	q(B+1)		=> null0
	);
	
dfly_i_2comp: xdsp_tcompw17 
	port map (
		a		=> dfly_i_tmp,
        	bypass		=> dragonfly_conj, 
        	clk		=> clk,
        	ce		=> ce,
        	q(B downto 0)	=> xk_i_tmp,
        	q(B+1)		=> null1
	);
			 	
xk_mux : xmux2w16 
	port map (
		clk		=> clk,				-- system clock
		ce		=> ce,				-- global clk enable
		s0		=> scale_enable,		-- mux select
		x0r		=> xk_r_tmp(B-1 downto 0),	-- mux inputs Re and Im
		x0i		=> xk_i_tmp(B-1 downto 0),
		x1r		=> xk_r_tmp(B downto 1),	
		x1i		=> xk_i_tmp(B downto 1),
		yr		=> xk_r,			-- mux outputs
		yi		=> xk_i
	      );
		
-- register the fwd_inv signal presented by the user

scale_mode_proc : process(clk,ce,fwd_inv)
-- registration is qualified by start to handle the start-up process
begin
    if clk'event and clk = '1' then
      if ce = '1' and (mode_ce_i = '1' or start = '1') then
          fwd_inv_r <= fwd_inv;
      end if;
    end if;
end process;

-- delay the registered forward/inv. FFT control signal 'fwd_inv' for use
-- with the complementor located at the back of the complex multiplier

fwd_inv_pipe_balance : z16w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> fwd_inv_r,
		dout	=> fwd_inv_rz
	);
	
-- register the scale_mode pin presented by the user

fwd_inv_proc : process(clk,ce,scale_mode)
-- registration is qualified by start to handle start-up process
begin
    if clk'event and clk = '1' then
      if ce = '1' and (mode_ce_i = '1' or start = '1') then
          scale_mode_r <= scale_mode;
      end if;
    end if;
end process;

-- overflow detection process

overflow : process(clk,rs,start,done_i,scale_enable)
    variable r	 : std_logic;
    variable ovf : std_logic;    
begin
    r := rs or start or done_i;
    if scale_enable = '0' and ((xk_r_tmp(B-1) /= xk_r_tmp(B)) 
        or (xk_i_tmp(B-1) /= xk_i_tmp(B))) then
        ovf := '1';
    else
        ovf := '0';
    end if;
    if clk'event and clk = '1' then
        if r = '1' then
            ovflo <= '0';
        elsif ovf = '1' then
            ovflo <= '1';     
        end if;
    end if;
end process overflow;

    scale_enable <= scale_mode_r and rank_eq_0;
    
    -- 'dragonfly_conj' complements (or not) the dragonfly output
    -- (ie the output of the cmplx mult)
    
    dragonfly_conj <= not (dfly_2comp xor fwd_inv_rz);
    phase_agen_ce <= ce; 
    r <= rs or start;
    dfly_conj <= not fwd_inv_r;
    mode_ce <= mode_ce_i;
    result <= result_i;
    done <= done_i;
    edone <= edone_i;
    busy <= busy_i;
    bank <= bank_i;
    addrw_x <= addrwx_i;
    logic0 <= '0';
    logic1 <= '1';
    
end behavioral;
