library xilinxcorelib;
	use xilinxcorelib.vfft_utils.all;
	

-------------------------------------------------------------------------------
--$Id: vfft256.vhd,v 1.1 2010-07-10 21:43:26 mmartinez Exp $
-------------------------------------------------------------------------------
--
-- vfft256 behv model
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
-- Filename: vfft256.vhd
--
-- Description: 
--  This is the behv model for the 256-point complex forward/inverse FFT 
--	This Core is a point solution.	
--                      
-------------------------------------------------------------------------------

library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;
	
library xilinxcorelib;
	use xilinxcorelib.fft_defsx_256.all;	

-- synopsys translate_off 	
library xilinxcorelib;
	use xilinxcorelib.ul_utils.all;

library unisim;
	use unisim.vcomponents.all;
-- synopsys translate_on
	
entity vfft256 is
	port(
		clk		: in std_logic;
		rs		: in std_logic;
		start		: in std_logic;
		ce		: in std_logic;
		scale_mode	: in std_logic;				-- rank 0 scaling								-- control
		di_r		: in std_logic_vector(B-1 downto 0);
		di_i		: in std_logic_vector(B-1 downto 0);
		fwd_inv		: in std_logic;				-- forward/inverse (1/0) FFT
		io_mode0	: in std_logic;	
		io_mode1	: in std_logic;
		mwr		: in std_logic;
		mrd		: in std_logic;
		ovflo		: out std_logic;			-- internal arithmetic overflow
		result		: out std_logic;			-- indicates final processing pass
		mode_ce		: out std_logic;
		done		: out std_logic;			-- end FFT clk pulse
		edone		: out std_logic;	
		io		: out std_logic;
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
		addrr_y		: out std_logic_vector(log2_nfft-1 downto 0);	-- mem write addr bus		
		addrw_x		: out std_logic_vector(log2_nfft-1 downto 0);
		addrw_y		: out std_logic_vector(log2_nfft-1 downto 0);		
		xk_r		: out std_logic_vector(B-1 downto 0);	-- xform output bus - Re
		xk_i		: out std_logic_vector(B-1 downto 0);	-- xform output bus - Im
		yk_r		: out std_logic_vector(B-1 downto 0);	-- xform wrk mem  bus - Re
		yk_i		: out std_logic_vector(B-1 downto 0)	-- xform wrk mem  bus - Im		
	    );
end; 

architecture behavioral of vfft256 is

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
	signal xk_r_tmp			: std_logic_vector(B downto 0);
	signal xk_i_tmp			: std_logic_vector(B downto 0);
	signal rank_eq_0		: std_logic;
	signal scale_enable		: std_logic;
	-- controls conjugation of the dragonfly output
	signal dragonfly_conj		: std_logic;
	signal	tmp_result		: std_logic;
	signal dfly_conj		: std_logic;
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
	signal	io_i			: std_logic;
	signal	eresult			: std_logic;	-- early (1 clk) result
	signal	null0,null1		: std_logic;
	-- outp. from butterfly #1	
	signal	xka_r,xka_i		: std_logic_vector(B-1 downto 0);
	signal	xxk_r,xxk_i		: std_logic_vector(B-1 downto 0);
	signal	ykr,yki			: std_logic_vector(B-1 downto 0);			
	-- outp. from butterfly #2	
	signal	xkb_r,xkb_i		: std_logic_vector(B-1 downto 0);	
	signal	start_b1		: std_logic;
	signal	xk_mux_sel		: std_logic;
	signal	mode			: std_logic;
	signal	dma			: std_logic;
	signal	nxt_addr		: std_logic;
	signal	bank_i			: std_logic;
	signal	ebank			: std_logic;	
	signal	addrwx_i		: std_logic_vector(log2_nfft-1 downto 0);
					
component SRL16E
	port (
		q		: out std_logic;	
		d		: in std_logic;
		ce		: in std_logic;
		clk   		: in std_logic;
 		a0		: in std_logic;			
 		a1		: in std_logic;
 		a2		: in std_logic;
 		a3		: in std_logic
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

component xmux2w16r
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

component fft_cntrlx_256
	port(
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		mode		: in std_logic;		
		start		: in std_logic;
		dma		: in std_logic;
		mwr		: in std_logic;
		addrw		: in std_logic_vector(log2_nfft-1 downto 0);
		busy		: out std_logic;
		wren		: out std_logic;
		--wren1		: out std_logic;		
		wrenx		: out std_logic;
		wreny		: out std_logic;
		web_x		: out std_logic;
		web_y		: out std_logic;
		enax		: out std_logic;
		enay		: out std_logic;
		rank_eq_0	: out std_logic;
		rank_eq_nm1	: out std_logic;			
		result		: out std_logic;
		eresult		: out std_logic;		
		io		: out std_logic;
		eio		: out std_logic;
		mode_ce		: out std_logic;		
		done		: out std_logic;
		edone		: out std_logic;
		bank		: out std_logic;
		ebank		: out std_logic;
		nxt_addr	: out std_logic
	);
	
end component;
			
-- operand read address generator
component fft_rd_agenx_256 
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
		fft_rd_addr_y	: out std_logic_vector(log2_nfft-1 downto 0)		
	);
end component;
			
-- result write address generator
component fft_wr_agenx_256
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		start		: in std_logic;		-- xform start
		gstart		: in std_logic;
		io_mode0	: in std_logic;		
		io_mode1	: in std_logic;
		dma		: in std_logic;
		result		: in std_logic;
		nxt_addr	: in std_logic;
		bank		: in std_logic;
		mwr		: in std_logic;
		--fft_wr_addr	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addrx	: out std_logic_vector(log2_nfft-1 downto 0);
		fft_wr_addry	: out std_logic_vector(log2_nfft-1 downto 0)
	);
end component;

component index_map_256
	port(
		clk		: in std_logic;		-- global clock
		ce		: in std_logic;		-- master clock enable
		rs		: in std_logic;		-- master reset
		index		: out std_logic_vector(log2_nfft-1 downto 0) -- outp. index bus
	);
end component;

-- phase factor generator
component phase_factors_256
    port (
    	    clk			: in std_logic;		-- global clock
    	    ce			: in std_logic;		-- global clock enable
    	    start		: in std_logic;		-- system start
    	    rs			: in std_logic;
    	    result              : in std_logic;
    	    dma			: in std_logic;
    	    io			: in std_logic;	    	    
    	    sinn		: out std_logic_vector(B-1 downto 0);	-- cos()
    	    coss		: out std_logic_vector(B-1 downto 0);	-- sin()
    	    comp		: out std_logic
    );
end component;

component dragonfly_256
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

component fft4_engine
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		fwd_inv		: in std_logic;
		fwd_inv_ce	: in std_logic;
		xnr		: in std_logic_vector(B-1 downto 0);
		xni		: in std_logic_vector(B-1 downto 0);
		xkr		: out std_logic_vector(B-1 downto 0);
		xki		: out std_logic_vector(B-1 downto 0)
	      );
end component;
	      
-- The 2's complementor is used in conjunction with the cmplx mul for handling
-- multiplication by 1

component xdsp_tcompw17
 port( 	a		: in   std_logic_vector( B downto 0 );
        bypass		: in   std_logic;
        clk		: in   std_logic;
        ce		: in   std_logic;
        q		: out  std_logic_vector( B+1 downto 0 ));
end component;

component z19w1
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

attribute RLOC : string;
attribute RLOC of omega : label is "R12C16";
attribute RLOC of dfly_r_2comp : label is "R0C31";
attribute RLOC of dfly_i_2comp : label is "R14C31";
attribute RLOC of dfly : label is "R0C4";		   
attribute RLOC of b1 : label is "R6C33";
attribute RLOC of xk_mux : label is "R6C32"; 
attribute RLOC of xa_mux : label is "R6C31";

begin

rd_agen: fft_rd_agenx_256
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		start		=> start,
		mrd		=> mrd,
		mwr		=> mwr,
		io_mode0	=> io_mode0,
		io_mode1	=> io_mode1,
		bank		=> ebank,
		nxt_addr	=> nxt_addr,
		fft_rd_addr	=> addrr_x,
		fft_rd_addr_y	=> addrr_y
	);

wr_agen: fft_wr_agenx_256
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		start		=> wr_agen_start,
		gstart		=> start,
		io_mode0	=> io_mode0,
		io_mode1	=> io_mode1,
		dma		=> dma,
		result		=> edone_i,
		nxt_addr	=> nxt_addr,
		bank		=> bank_i,
		mwr		=> mwr,		
		--fft_wr_addr	=> addrw,
		fft_wr_addrx	=> addrwx_i,
		fft_wr_addry	=> addrw_y
	);

indx_agen : index_map_256
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> edone_i,
		index		=> index
	);
		
omega : phase_factors_256
	port map(
		clk		=> clk,
		ce		=> ce,
		start		=> start,
		rs		=> rs,
		result          => result_i,
		dma		=> dma,
		io		=> io_i,
		sinn		=> wi,
		coss		=> wr,
		comp		=> dfly_2comp
	);

-- primary dragonfly processor

dfly: dragonfly_256 
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

cntrl : fft_cntrlx_256
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		mode		=> mode,
		start		=> start,
		dma		=> dma,
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
		rank_eq_0	=> rank_eq_0,
		result		=> result_i,
		eresult		=> eresult,		
		io		=> io_i,
		eio		=> eio,
		mode_ce		=> mode_ce_i,
		done		=> done_i,
		edone		=> edone_i,
		bank		=> bank_i,
		ebank		=> ebank,
		nxt_addr	=> nxt_addr
	);

wr_addr_start : z19w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> wr_agen_start
	);
	
xa_mux : xmux2w16r 
	port map (
		clk		=> clk,				-- system clock
		ce		=> ce,				-- global clk enable
		s0		=> scale_enable,		-- mux select
		x0r		=> xk_r_tmp(B-1 downto 0),	-- mux inputs Re and Im
		x0i		=> xk_i_tmp(B-1 downto 0),
		x1r		=> xk_r_tmp(B downto 1),	
		x1i		=> xk_i_tmp(B downto 1),
		yr		=> xka_r,			-- mux outputs
		yi		=> xka_i
	      );

b1_start_proc : process(clk,ce,start)
begin

	if clk'event and clk = '1' then
		if ce = '1' then
			start_b1 <= start;
		end if;
	end if;
end process;
	      
b1 : fft4_engine 
	port map (
		clk		=> clk,
		rs		=> rs,
		start		=> start_b1,
		ce		=> ce,
		fwd_inv		=> dfly_conj,
		fwd_inv_ce	=> mode_ce_i,
		xnr		=> xka_r,
		xni		=> xka_i,
		xkr		=> ykr,
		xki		=> yki
	      );

xk_mux : xmux2w16r 
	port map (
		clk		=> clk,				
		ce		=> ce,				
		s0		=> xk_mux_sel, 			
		x0r		=> xka_r,			
		x0i		=> xka_i,
		x1r		=> ykr,	
		x1i		=> yki,
		yr		=> xk_r,							
		yi		=> xk_i					
	      );
	      	      
-- delay the registered forward/inv. FFT control signal 'fwd_inv' for use
-- with the complementor located at the back of the complex multiplier

fwd_inv_dly : z17w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> fwd_inv_r,
		dout	=> fwd_inv_rz
	);
		
-- register the fwd_inv signal presented by the user

fwd_inv_proc : process(clk,ce,fwd_inv)
-- registration is qualified by start to handle the very first FFT
begin
    if clk'event and clk = '1' then
      if ce = '1' and (mode_ce_i = '1' or start = '1') then
          fwd_inv_r <= fwd_inv;
      end if;
    end if;
end process;

-- register the scale_mode pin presented by the user

scale_mode_proc : process(clk,ce,scale_mode)
-- registration is qualified by start to handle the very first FFT
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
end process;
 			     
    scale_enable <= scale_mode_r and rank_eq_0;
    dragonfly_conj <= not (dfly_2comp xor fwd_inv_rz); 
    dfly_conj <= not fwd_inv_r;
    mode_ce <= mode_ce_i;
    result <= result_i;
    done <= done_i;
    edone <= edone_i;
    busy <= busy_i;  
    io <= io_i;
    yk_r <= ykr;
    yk_i <= yki;    
    xk_mux_sel <= not mode and result_i;
    mode <= io_mode0;
    dma <= io_mode1;
    bank <= bank_i;
    addrw_x <= addrwx_i;
    logic0 <= '0';
    logic1 <= '1';   
    
end behavioral;
