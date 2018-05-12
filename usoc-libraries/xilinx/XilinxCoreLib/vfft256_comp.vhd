
Library IEEE;
Use IEEE.std_logic_1164.all;

package vfft256_comp is
component vfft256
	port(
		clk			: in std_logic;
		rs			: in std_logic;
		start		: in std_logic;
		ce			: in std_logic;
		scale_mode	: in std_logic;											-- control
		di_r		: in std_logic_vector(15 downto 0);
		di_i		: in std_logic_vector(15 downto 0);
		fwd_inv		: in std_logic;			
		io_mode0	: in std_logic;	
		io_mode1	: in std_logic;
		mwr			: in std_logic;
		mrd			: in std_logic;
		ovflo		: out std_logic;		
		result		: out std_logic;		
		mode_ce		: out std_logic;
		done		: out std_logic;		
		edone		: out std_logic;	
		io			: out std_logic;
		eio			: out std_logic;
		bank		: out std_logic;
		busy		: out std_logic;		
		wea			: out std_logic;			
		wea_x		: out std_logic;
		wea_y		: out std_logic;
		web_x		: out std_logic;
		web_y		: out std_logic;
		ena_x		: out std_logic;
		ena_y		: out std_logic;
		index		: out std_logic_vector(7 downto 0);	
		addrr_x		: out std_logic_vector(7 downto 0);	
		addrr_y 	: out std_logic_vector(7 downto 0);
		addrw_x		: out std_logic_vector(7 downto 0);		
		addrw_y		: out std_logic_vector(7 downto 0);		
		xk_r		: out std_logic_vector(15 downto 0);	
		xk_i		: out std_logic_vector(15 downto 0);	
		yk_r		: out std_logic_vector(15 downto 0);	
		yk_i		: out std_logic_vector(15 downto 0));
end component;

END vfft256_comp;
