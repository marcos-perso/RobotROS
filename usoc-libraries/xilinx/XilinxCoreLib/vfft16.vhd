library xilinxcorelib;
	use xilinxcorelib.vfft_utils.all;
	

-------------------------------------------------------------------------------
--$Id: vfft16.vhd,v 1.1 2010-07-10 21:43:25 mmartinez Exp $
-------------------------------------------------------------------------------
--
-- vfft16 behv model
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
-- Filename: vfft16.vhd
--
-- Description: 
--  This is the behv model for the 16-point complex forward/inverse FFT 
--	This Core is a point solution.	
--                      
-------------------------------------------------------------------------------





library ieee;
	use ieee.std_logic_1164.all;
	use ieee.std_logic_arith.all;
	use ieee.std_logic_unsigned.all;
	use std.textio.all;

library xilinxcorelib;
	use xilinxcorelib.fft_defs_16.all;
		
library unisim;
	use unisim.vcomponents.all;
	
entity vfft16 is
	port (
		clk		: in std_logic;		-- system clock
		rs		: in std_logic;		-- reset
		start		: in std_logic;		-- start transform
		ce		: in std_logic;		-- master clk enable
		scale_mode	: in std_logic;
		di_r		: in std_logic_vector(B-1 downto 0);
		di_i		: in std_logic_vector(B-1 downto 0);
		fwd_inv		: in std_logic;
		done		: out std_logic;	-- transform ready
		mode_ce		: out std_logic;
		ovflo		: out std_logic;
		xk_r		: out std_logic_vector(B-1 downto 0);
		xk_i		: out std_logic_vector(B-1 downto 0)
	      );
end vfft16;

architecture behavioral of vfft16 is

	constant mode_ce_cnt	: integer := 0;
	constant done_cnt	: integer := 1;
	
	-- phase factor LUT signals
	
	-- phase factor LUT addr.
	signal	phase_lut_addr		: std_logic_vector(3 downto 0);
	
	-- phase factors Re and Im
	signal	wr			: std_logic_vector(B-1 downto 0);
	signal	wi			: std_logic_vector(B-1 downto 0);
		
	-- start signal for phase factor lut
	signal	start_phase_agen	: std_logic;
	
	-- 2's complement control for output of dragonfly complex multiplier
	signal	dfly_2comp		: std_logic;
	signal	dfly_2comp_x		: std_logic;	
	signal	dfly_2compu		: std_logic;
	signal	dfly_2comp_tmp		: std_logic;
	
	-- output from dragonfly complex multiplier
	signal	dfly_r_tmp			: std_logic_vector(16 downto 0);
	signal	dfly_i_tmp			: std_logic_vector(16 downto 0);
	-- fft4 output mux selects
	signal	fft4_omux_s0		: std_logic;
	signal	fft4_omux_s1		: std_logic;
	signal	fft4_omux_state_cntr	: std_logic_vector(1 downto 0);	

	signal	we			: std_logic;
	signal	ram_ce			: std_logic;
	signal	xnr			: std_logic_vector(B-1 downto 0);
	signal	xni			: std_logic_vector(B-1 downto 0);
	
	-- completed dragonfly outputs
	-- The result from the complex multiplier must be sign-corrected to
	-- precisely handle multiplcation by 1	
	signal	dfly_r			: std_logic_vector(B downto 0);
	signal	dfly_i			: std_logic_vector(B downto 0);
	
	-- 2's complement control for complementor at output of dragonfly
	-- complex multiplier
	signal	dfly_tcomp		: std_logic;
	signal	dfly_tcompu		: std_logic;	
	
	-- output from the data re-ordering buffer between the rank 0 and
	-- rank 1 dragonfly processors
	signal	xka_r			: std_logic_vector(B-1 downto 0);
	signal	xka_i			: std_logic_vector(B-1 downto 0);
	signal	xkc_r			: std_logic_vector(B-1 downto 0);
	signal	xkc_i			: std_logic_vector(B-1 downto 0);	
	-- output from mux located after dragonfly 2's complementor
	signal	xkk_r			: std_logic_vector(B-1 downto 0);
	signal	xkk_i			: std_logic_vector(B-1 downto 0);
	

	-- start signal for FFT re-ordering buffer between ranks 0 and 1
	signal	start_fft_dbl_bufr	: std_logic;
	
	-- rank 1 4-point FFT output samples
	signal	y0ar			: std_logic_vector(B-1 downto 0);
	signal	y0ai			: std_logic_vector(B-1 downto 0);
	signal	y1ar			: std_logic_vector(B-1 downto 0);
	signal	y1ai			: std_logic_vector(B-1 downto 0);
	signal	y2ar			: std_logic_vector(B-1 downto 0);
	signal	y2ai			: std_logic_vector(B-1 downto 0);
	signal	y3ar			: std_logic_vector(B-1 downto 0);
	signal	y3ai			: std_logic_vector(B-1 downto 0);
	
	-- start signal for rank 1 dragonfly (i.e. 4-point FFT) processor
	signal	start_rank1_dfly	: std_logic;
	
	-- rank 1 dragonfly output multiplexor signals
	signal	xkb_r			: std_logic_vector(B-1 downto 0);
	signal	xkb_i			: std_logic_vector(B-1 downto 0);
	
	-- start signal for output re-ordering buffer
	signal	start_output_reordering	: std_logic;
	
	-- start FFT done LUT address generator
	signal	start_done_agen		: std_logic;
	-- FFT done LUT address generator
	signal	done_lut_addr		: std_logic_vector(3 downto 0);
	signal	state			: std_logic_vector(3 downto 0);
	
	signal 	null0			: std_logic;
	signal	null1			: std_logic;
	signal	null2			: std_logic;
	signal	null3			: std_logic;
	signal	null4			: std_logic;
	signal	logic0			: std_logic;
	signal	logic1			: std_logic;	
	signal 	scale_enable		: std_logic;
	signal 	xk_r_tmp		: std_logic_vector(B downto 0);
	signal 	xk_i_tmp		: std_logic_vector(B downto 0);
	signal	dragonfly_conj		: std_logic;
	signal	done_valid		: std_logic;
	signal	fft4_fwd_inv		: std_logic;
	signal	omux_conj		: std_logic;	
	signal	mode_ce_i		: std_logic;
	signal	scale_mode_r		: std_logic;
	signal	fwd_inv_r		: std_logic;
	signal	fwd_inv_2		: std_logic;	
	signal	fwd_inv_rz		: std_logic;	
	signal	dfly_conj		: std_logic;
	signal	done_i			: std_logic;
	signal	scale_mode_rz		: std_logic;
	
-- srl16/FF based delay
component z4w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;


-- srl16/FF based delay
component z16w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;
	
-- srl16/FF based delay
component z17w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;

-- srl16/FF based delay
component z18w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;

-- srl16/FF based delay
component z36w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;

-- srl16/FF based delay
component z46w1
	port (
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		din		: in std_logic;
		dout		: out std_logic
	);
end component;
	 
component dragonfly_16
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

component fft4_16
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- global start
		ce		: in std_logic;
		conj		: in std_logic;
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		y0r		: out std_logic_vector(B-1 downto 0);
		y0i		: out std_logic_vector(B-1 downto 0);
		y1r		: out std_logic_vector(B-1 downto 0);
		y1i		: out std_logic_vector(B-1 downto 0);
		y2r		: out std_logic_vector(B-1 downto 0);
		y2i		: out std_logic_vector(B-1 downto 0);
		y3r		: out std_logic_vector(B-1 downto 0);
		y3i		: out std_logic_vector(B-1 downto 0)
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

component cmplx_reg16_conj
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		conj		: in std_logic;				-- conjugation control
									-- forms conjugation when ==1
		dr		: in std_logic_vector(B-1 downto 0);	-- Re/Im data in
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);	-- Re/Im data out
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

component fft_cntrl_16
	port(
		clk		: in std_logic;
		ce		: in std_logic;
		rs		: in std_logic;
		start		: in std_logic;
		done		: in std_logic;		
		done_valid	: out std_logic
	);
end component;

-- ROM for handling complement operation at output of complex mult.
component xdsp_triginv 
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        c	: IN STD_LOGIC;
        ce	: IN STD_LOGIC;
        clr	: IN STD_LOGIC;
        q	: OUT STD_LOGIC);
END component;
	
component input_dbl_bufr
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

component fft_dbl_bufr_16
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

-- output re-ordering double buffer
component bitrev_bufr
	port (
		clk		: in std_logic;				-- system clock
		rs		: in std_logic;				-- reset
		start		: in std_logic;				-- start transform
		ce		: in std_logic;				-- clk enable
		dr		: in std_logic_vector(B-1 downto 0);
		di		: in std_logic_vector(B-1 downto 0);
		qr		: out std_logic_vector(B-1 downto 0);
		qi		: out std_logic_vector(B-1 downto 0)
	      );
end component;


-- The 2's complementor is used in conjunction with the cmplx mult for handling
-- multiplication by 1

component xdsp_tcompw17
 port(  a	: in   std_logic_vector( 16 downto 0 );
        bypass	: in   std_logic;
        clk	: in   std_logic;
        ce	: in   std_logic;
        q	: out  std_logic_vector( 17 downto 0 ));
end component;

component xdsp_coss16 
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC;
        --clr	: IN STD_LOGIC;
        qspo	: OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0));
END component;

-- sine LUT
component xdsp_sinn16
  PORT (a	: IN STD_LOGIC_VECTOR(4-1 DOWNTO 0);
        clk	: IN STD_LOGIC;
        qspo_ce	: IN STD_LOGIC ;
        --clr	: IN STD_LOGIC ;
        qspo	: OUT STD_LOGIC_VECTOR(16-1 DOWNTO 0));
END component;

component xmux4w16r
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(B-1 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(B-1 downto 0);
		x1r		: in std_logic_vector(B-1 downto 0);	
		x1i		: in std_logic_vector(B-1 downto 0);
		x2r		: in std_logic_vector(B-1 downto 0);	
		x2i		: in std_logic_vector(B-1 downto 0);
		x3r		: in std_logic_vector(B-1 downto 0);	
		x3i		: in std_logic_vector(B-1 downto 0);
		yr		: out std_logic_vector(B-1 downto 0);	-- mux outputs
		yi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

component xmux4w16br
	port (
		clk		: in std_logic;				-- system clock
		ce		: in std_logic;				-- global clk enable
		s0		: in std_logic;				-- mux select inputs
		s1		: in std_logic;
		x0r		: in std_logic_vector(B-1 downto 0);	-- mux inputs Re and Im
		x0i		: in std_logic_vector(B-1 downto 0);
		x1r		: in std_logic_vector(B-1 downto 0);	
		x1i		: in std_logic_vector(B-1 downto 0);
		x2r		: in std_logic_vector(B-1 downto 0);	
		x2i		: in std_logic_vector(B-1 downto 0);
		x3r		: in std_logic_vector(B-1 downto 0);	
		x3i		: in std_logic_vector(B-1 downto 0);
		yr		: out std_logic_vector(B-1 downto 0);	-- mux outputs
		yi		: out std_logic_vector(B-1 downto 0)
	      );
end component;

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

attribute RLOC : string;
attribute RLOC of wr_lut : label is "R5C20";
attribute RLOC of wi_lut : label is "R5C20";
attribute RLOC of inbuf : label is "R8C0";
attribute RLOC of dfly_r_2comp : label is "R0C31";
attribute RLOC of dfly_i_2comp : label is "R14C31";
attribute RLOC of xfft4_rank1 : label is "R11C11"; 
attribute RLOC of dfly : label is "R0C4";
attribute RLOC of dfly_buf : label is "R19C6";
attribute RLOC of bitrev_obufr : label is "R19C2";
attribute RLOC of dfly1_omux : label is "R12C17";
attribute RLOC of xk_mux : label is "R12C17";
attribute RLOC of omux_reg : label is "R11C10";
attribute RLOC of cntrl : label is "R7C10";

begin

-- port mappings for cosine LUT

wr_lut : xdsp_coss16   
	port map (
		a	=> phase_lut_addr,
        	clk	=> clk,
        	qspo_ce	=> ce,
        	qspo	=> wr				
        );


wi_lut : xdsp_sinn16   
	port map (
		a	=> phase_lut_addr,
        	clk	=> clk,
        	qspo_ce	=> ce,
        	qspo	=> wi				
        );
  	
-- generate start signal for phase factor addr. gen.  
phase_agen_start_z : SRL16E 
	port map(
		q		=> start_phase_agen,	-- global start signal
		d		=> start,
		ce		=> ce,
		clk   		=> clk,
 		a0		=> logic0,		-- 11 stage delay line (addr = dec 10)
 		a1		=> logic1,
 		a2		=> logic0,
 		a3		=> logic1
	);

fft_dbl_bufr_start_z : z4w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> start_fft_dbl_bufr
	);
		
rank1_fft_start_z : z16w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> start_rank1_dfly
	);
	
	
cntrl : fft_cntrl_16
	port map(
		clk		=> clk,
		ce		=> ce,
		rs		=> rs,
		start		=> start,
		done		=> done_i,
		done_valid	=> done_valid 
	);

-- The 2's complementor is connected to the back-end of the complex multiplier.
-- It is used for handling multiplication by 1.
      	
xmul_tcomp_lut :  xdsp_triginv  
  	port map (
  		a		=> phase_lut_addr,
        	c		=> clk,
        	ce		=> ce,
        	clr		=> rs,
        	q		=> dfly_2comp_tmp	
       );

-- generate start signal for output re-ordering buffer

out_reorder_start_z : z16w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> start,
		dout	=> start_output_reordering
	);
	
-- input double buffer port mappings
inbuf : input_dbl_bufr
	port map (
		clk		=> clk,
		rs		=> rs,
		start		=> start,
		ce		=> ce,
		dr		=> di_r,
		di		=> di_i,
		qr		=> xnr,
		qi		=> xni
	);
	
dfly: dragonfly_16 
	port map (
		clk		=> clk,
		rs		=> rs,
		start		=> start,
		ce		=> ce,
		conj		=> dfly_conj,			--fft4_inv,		
		xnr		=> xnr,
		xni		=> xni,
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
        	bypass		=> dfly_2compu,
        	clk		=> clk,
        	ce		=> ce,
        	q(16 downto 0)	=> dfly_r,
        	q(17)		=> null3
	);
	
dfly_i_2comp: xdsp_tcompw17 
	port map (
		a		=> dfly_i_tmp,
        	bypass		=> dragonfly_conj, 
        	clk		=> clk,
        	ce		=> ce,
        	q(B downto 0)	=> dfly_i,
        	q(B+1)		=> null4
	);

xk_mux : xmux2w16r 
	port map (
		clk		=> clk,				
		ce		=> ce,				
		s0		=> scale_mode_rz,		
		x0r		=> dfly_r(B-1 downto 0),	
		x0i		=> dfly_i(B-1 downto 0),
		x1r		=> dfly_r(B downto 1),	
		x1i		=> dfly_i(B downto 1),
		yr		=> xkk_r,			
		yi		=> xkk_i
	      );
	      
-- double buffer between ranks 0 and 1
dfly_buf : fft_dbl_bufr_16
	port map (
		clk		=> clk,
		rs		=> rs,
		start		=> start_fft_dbl_bufr,
		ce		=> ce,
		dr		=> xkk_r,
		di		=> xkk_i,
		qr		=> xka_r,
		qi		=> xka_i
	);	

fwd_inv_dlyb : z36w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> dfly_conj,
		dout	=> fft4_fwd_inv
	);

		
-- final rank dragonfly processor	
xfft4_rank1 : fft4_16
	port map (
		clk		=> clk,				-- system clock
		rs		=> rs,				-- reset
		start		=> start_rank1_dfly,		-- global start
		ce		=> ce,				-- master clk enable
		conj		=> fft4_fwd_inv,
		dr		=> xka_r,			-- Re/Im input sample
		di		=> xka_i,
		y0r		=> y0ar,			-- output samples
		y0i		=> y0ai,
		y1r		=> y1ar,
		y1i		=> y1ai,
		y2r		=> y2ar,
		y2i		=> y2ai,
		y3r		=> y3ar,
		y3i		=> y3ai		
	);

dfly1_omux : xmux4w16br
	port map (
		clk		=> clk,			-- system clock
		ce		=> ce,			-- global clk enable
		s0		=> fft4_omux_s0,	-- mux select inputs
		s1		=> fft4_omux_s1,
		x0r		=> y1ar,	
		x0i		=> y1ai,
		x1r		=> y2ar,	
		x1i		=> y2ai,
		x2r		=> y3ar,	
		x2i		=> y3ai,
		x3r		=> y0ar,	
		x3i		=> y0ai,
		yr		=> xkb_r,		-- sample presented to outp.
		yi		=> xkb_i		-- re-ordering buffer
	);


omux_reg : cmplx_reg16_conj 
	port map (
		clk		=> clk,			-- system clock
		ce		=> ce,			-- global clk enable
		conj		=> omux_conj,		-- conjugation control
							-- forms conjugation when ==1
		dr		=> xkb_r,		-- Re/Im data in
		di		=> xkb_i,
		qr		=> xkc_r,		-- Re/Im data out
		qi		=> xkc_i
	      );

-- output re-ordering double buffer
bitrev_obufr: bitrev_bufr 
	port map (
		clk		=> clk,			
		rs		=> rs,			
		start		=> start_output_reordering,		
		ce		=> ce,			
		dr		=> xkc_r, 
		di		=> xkc_i, 
		qr		=> xk_r,		-- in-order output samples	
		qi		=> xk_i
	      );
		      			
-- rank-1 4-point FFT state machine
fft4_omux_state_mach : process(clk,rs,ce,start)
begin
	if rs = '1' or start = '1' then
		fft4_omux_state_cntr <= (others => '0');
	elsif clk'event and clk='1' then
		if ce = '1' then
			fft4_omux_state_cntr <= fft4_omux_state_cntr + 1;
		end if;	
	end if;
end process;
		
addr_gen : process(clk,rs,ce,start_phase_agen)
begin
	if rs = '1' or start_phase_agen = '1' then
		phase_lut_addr <= (others => '0');
	elsif clk'event and clk = '1' then
	    if ce = '1' then
		phase_lut_addr <= phase_lut_addr + 1;
	    end if;
	end if;
end process;

done_addr_gen : process(clk,rs,ce,start_done_agen)
begin
	if rs = '1' or start_done_agen = '1' then
		done_lut_addr <= (others => '0');
	elsif clk'event and clk = '1' then
	    if ce = '1' then
		done_lut_addr <= done_lut_addr + 1;
	    end if;
	end if;
end process;

done_proc : process(clk,ce,rs,state)
begin
	if clk'event and clk = '1' then
		if rs = '1' then
			done_i <= '0';
		elsif ce = '1' then
			if state = done_cnt then
				done_i <= '1';
			else 
				done_i <= '0';
			end if;
		end if;
	end if;
	
end process;

mode_ce_proc : process(clk,ce,rs)
begin
	if clk'event and clk= '1' then
		if rs = '1' then
			mode_ce_i <= '0';
		elsif ce = '1' then
			if state = mode_ce_cnt then
				mode_ce_i <= '1';
			else
				mode_ce_i <= '0';
			end if;	
		end if;
	end if;
end process;

state_proc : process(clk,ce,start,rs)
begin
	if clk'event and clk = '1' then
		if start = '1' or rs = '1' then
			state <= (others => '0');
		elsif ce = '1' then
			state <= state + 1;	
		end if;
	end if;
end process;

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

scale_mode_dly : z18w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> scale_mode_r,
		dout	=> scale_mode_rz
	);
		
-- register the fwd_inv signal presented by the user

fwd_inv_proc : process(clk,ce,rs,fwd_inv)
-- registration is qualified by start to handle the very first FFT
begin
    if clk'event and clk = '1' then
        if rs = '1' then  
            fwd_inv_r <= '0';
        elsif ce = '1' and (mode_ce_i = '1' or start = '1') then
            fwd_inv_r <= fwd_inv;
        end if;
    end if;
end process;

-- register the scale_mode pin presented by the user

scale_mode_proc : process(clk,ce,rs,scale_mode)
-- registration is qualified by start to handle the very first FFT
begin
    if clk'event and clk = '1' then
      if rs = '1' then
          scale_mode_r <= '0';
      elsif ce = '1' and (mode_ce_i = '1' or start = '1') then
          scale_mode_r <= scale_mode;
      end if;
    end if;
end process;

-- overflow detection process

overflow : process(clk,rs,ce,start,done_i,scale_enable)
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
        elsif ce = '1' then 
            if ovf = '1' then
                ovflo <= '1';     
            end if;
        end if;
    end if;
end process;

-- conjugation control for second butterfly processor

fwd_inv_balance : z46w1 
	port map (
		clk	=> clk,
		ce	=> ce,
		rs	=> rs,
		din	=> dfly_conj,	
		dout	=> omux_conj
	);
	
	fft4_omux_s0 <= fft4_omux_state_cntr(0);
	fft4_omux_s1 <= fft4_omux_state_cntr(1);
	
	dfly_2comp <= dfly_2comp_tmp;
	dfly_2compu <= dfly_2comp_tmp;
	
	start_done_agen <= start;
	done <= done_i and done_valid;		    
    	
    	-- cmplx mult conjugation cntrl
    	dragonfly_conj <= not (dfly_2comp xor fwd_inv_rz);
    	
    	-- conjugation control for dragonfly (input)
    	dfly_conj <= not fwd_inv_r;  
    	
    	mode_ce <= mode_ce_i;
    	logic0 <= '0';
    	logic1 <= '1';
	
end behavioral;


