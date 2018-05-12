-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/c_sin_cos_v4_0.vhd,v 1.1 2010-07-10 21:42:56 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.math_real.all;

library XilinxCoreLib;
use XilinxCoreLib.c_shift_fd_v5_0_comp.all;
use XilinxCoreLib.c_reg_fd_v5_0_comp.all;
use XilinxCoreLib.c_sin_cos_v4_0_pack.all;
use XilinxCoreLib.pipe_bhv_v4_0_comp.all;

entity C_SIN_COS_V4_0 is
	generic (
		C_ENABLE_RLOCS : integer	:= 0;		 
		C_HAS_ACLR : integer 		:= 0;
		C_HAS_CE : integer		:= 0;		 
		C_HAS_CLK : integer 		:= 0;
		C_HAS_ND : integer 		:= 1;
		C_HAS_RFD : integer 		:= 1;
		C_HAS_RDY : integer 		:= 1;
		C_HAS_SCLR : integer 		:= 0;
		C_LATENCY : integer			:= 0;
		C_MEM_TYPE : integer 		:= 0; --DIST_ROM;
		C_NEGATIVE_COSINE : integer 	:= 0;
		C_NEGATIVE_SINE : integer 	:= 0;
		C_OUTPUTS_REQUIRED : integer 	:= 0; --SINE_ONLY;
		C_OUTPUT_WIDTH : integer	:= 16;
		C_PIPE_STAGES : integer 	:= 0;
		C_REG_INPUT : integer 		:= 0;
		C_REG_OUTPUT : integer 		:= 0;
		C_THETA_WIDTH : integer 	:= 4		 
		);
	port (
		theta : in std_logic_vector (C_THETA_WIDTH-1 downto 0) := (others=>'0');
		sine : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
		cosine : out std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
		nd : in std_logic := '0';
		rfd : out std_logic;
		rdy : out std_logic;	  
		clk : in std_logic := '0';
		ce : in std_logic := '1';
		aclr : in std_logic := '0';
		sclr : in std_logic := '0'     
		);
end C_SIN_COS_V4_0;

architecture behavioral of C_SIN_COS_V4_0 is
	
	signal theta_int : integer := 0;
	signal sin_pipe, cos_pipe : std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
	signal sin_outreg, cos_outreg : std_logic_vector (C_OUTPUT_WIDTH-1 downto 0);
	signal zero : std_logic;
	-- C_PIPE_STAGES + C_REG_OUTPUT + C_REG_INPUT was replaced by C_LATENCY
	signal ce_delay_zero_vector : std_logic_vector (C_LATENCY - 2 downto 0);
	signal zero_vector : std_logic_vector (C_LATENCY - 1 downto 0);
	signal intNd : std_logic := '1';
	signal delayedCe : std_logic;
	signal outputRegCe : std_logic;
	
	constant depth : integer := 2**C_THETA_WIDTH;
	constant sine_table : table_array(0 to depth-1) := trig_array(sin_table, depth, C_OUTPUT_WIDTH, C_NEGATIVE_SINE);
	constant cosine_table : table_array(0 to depth-1) := trig_array(cos_table, depth, C_OUTPUT_WIDTH, C_NEGATIVE_COSINE);
	
begin
	
	zero <= '0';
	zero_vector <= (others=>'0');
	theta_int <= conv_integer(theta);
	sin_pipe <= conv_std_logic_vector(integer(sine_table(theta_int)), C_OUTPUT_WIDTH);
	cos_pipe <= conv_std_logic_vector(integer(cosine_table(theta_int)), C_OUTPUT_WIDTH);
	
	hasNd1 : if (C_HAS_ND=1) generate
		intNd <= nd;
	end generate;
	
	hasNd0 : if (not(C_HAS_ND=1)) generate
		intNd <= '1';
	end generate;
	
	hasRfd1 : if C_HAS_RFD=1 generate
		RFD <= '1';
	end generate;
	
	hasRfd0 : if not(C_HAS_RFD=1) generate
		RFD <= 'U';
	end generate;
	
	hasRdy1 : if (C_HAS_RDY=1 and (C_LATENCY>0)) generate
		u1 : c_shift_fd_v5_0 generic map (
			C_WIDTH=>C_LATENCY,
			C_HAS_SDOUT=>1,
			C_HAS_Q=>0,
			C_HAS_CE=>C_HAS_CE,
			C_HAS_ACLR=>C_HAS_ACLR * C_REG_OUTPUT,
			C_HAS_SCLR=>C_HAS_SCLR * C_REG_OUTPUT
			)
		port map (
			LSB_2_MSB=>zero,
			SDIN=>intNd,
			D=>zero_vector,
			P_LOAD=>zero,
			CLK=>clk,
			CE=>Ce,
			ACLR=>aclr,
			ASET=>zero,
			AINIT=>zero,
			SCLR=>sclr,
			SSET=>zero,
			SINIT=>zero,
			SDOUT=>rdy,
			Q=>open
			);
	end generate;
	
	hasRdy1NoLatency : if (C_HAS_RDY=1 and (C_LATENCY=0))generate
		rdy <= intNd;
	end generate; 
	
	hasRdy0 : if not(C_HAS_RDY=1) generate
		rdy <= 'U';
	end generate;
	
	hasSin1 : if (C_OUTPUTS_REQUIRED = SINE_ONLY) or
		(C_OUTPUTS_REQUIRED = SINE_AND_COSINE) generate
		
		u1 : PIPE_BHV_V4_0 generic map (
			C_HAS_ACLR=>C_HAS_ACLR * C_REG_OUTPUT,
			C_HAS_CE=>C_HAS_CE,
			C_HAS_SCLR=>C_HAS_SCLR * C_REG_OUTPUT,
			C_PIPE_STAGES=>C_LATENCY - C_REG_OUTPUT,
			C_WIDTH=>C_OUTPUT_WIDTH)
		port map (
			D=>sin_pipe,
			CLK=>clk,
			CE=>Ce,
			ACLR=>aclr,
			SCLR=>sclr,
			Q=>sin_outreg
			);
		
		hasSinRegOut1 : if (C_REG_OUTPUT=1) generate
			
			u1 : c_reg_fd_v5_0 generic map (
			C_WIDTH=>C_OUTPUT_WIDTH,
			C_HAS_CE=>hasOutputRegCe(C_HAS_CE, C_HAS_ACLR, C_HAS_SCLR, C_LATENCY),
			C_HAS_ACLR=>C_HAS_ACLR * C_REG_OUTPUT,
			C_HAS_SCLR=>C_HAS_SCLR * C_REG_OUTPUT)
			port map (
			D=>sin_outreg,
			CLK=>clk,
			CE=>outputRegCe,
			ACLR=>aclr,
			ASET=>zero,
			AINIT=>zero,
			SCLR=>sclr,
			SSET=>zero,
			SINIT=>zero,
			Q=>Sine
			);
		end generate;
		
		hasSinRegOut0 : if not(C_REG_OUTPUT=1) generate
			
			Sine <= sin_outreg;                      
			
		end generate;
		
	end generate;
	
	hasSin0 : if not((C_OUTPUTS_REQUIRED = SINE_ONLY) or
		(C_OUTPUTS_REQUIRED = SINE_AND_COSINE)) generate
		Sine <= (others=>'U');
	end generate;
	
	hasOutRegCe1 : if ((C_HAS_ACLR=1 or C_HAS_SCLR=1) and (C_LATENCY>1)) generate
		u1 : c_shift_fd_v5_0 generic map (
			C_WIDTH=>C_LATENCY - 1,
			C_SHIFT_TYPE=>1,
			C_HAS_SDOUT=>1,
			C_HAS_Q=>0,
			C_HAS_CE=>C_HAS_CE,
			C_HAS_ACLR=>C_HAS_ACLR*C_REG_OUTPUT,
			C_HAS_SCLR=>C_HAS_SCLR*C_REG_OUTPUT
			)
		port map (
			LSB_2_MSB=>zero,
			SDIN=>intNd,
			D=>ce_delay_zero_vector,
			P_LOAD=>zero,
			CLK=>clk,
			CE=>Ce,
			ACLR=>aclr,
			ASET=>zero,
			AINIT=>zero,
			SCLR=>sclr,
			SSET=>zero,
			SINIT=>zero,
			SDOUT=>delayedCe,
			Q=>open
			);
	end generate;
	
	ceAnd: process(CE, delayedCe)
		
	begin
		if C_HAS_ACLR=1 or C_HAS_SCLR=1 then
			if C_HAS_CE=1 and (C_LATENCY > 1) then
				outputRegCe <= CE and delayedCe;
			elsif (C_LATENCY > 1) then
				outputRegCe <= delayedCe;
			elsif C_HAS_CE=1 then
				outputRegCe <= CE;
			end if;
		elsif C_HAS_CE=1 then
			outputRegCe <= CE;
		end if;
	end	process;
	
	hasCos1 : if (C_OUTPUTS_REQUIRED = COSINE_ONLY) or
		(C_OUTPUTS_REQUIRED = SINE_AND_COSINE) generate
		
		u2 : PIPE_BHV_V4_0 generic map (
			C_HAS_ACLR=>C_HAS_ACLR*C_REG_OUTPUT,
			C_HAS_CE=>C_HAS_CE,
			C_HAS_SCLR=>C_HAS_SCLR*C_REG_OUTPUT,
			C_PIPE_STAGES=>C_LATENCY - C_REG_OUTPUT,
			C_WIDTH=>C_OUTPUT_WIDTH)
		port map (
			D=>cos_pipe,
			CLK=>clk,
			CE=>Ce,
			ACLR=>aclr,
			SCLR=>sclr,
			Q=>cos_outreg
			);
		
		hasCosRegOut1 : if (C_REG_OUTPUT=1) generate
			
			u1 : c_reg_fd_v5_0 generic map (
			C_WIDTH=>C_OUTPUT_WIDTH,
			C_HAS_CE=>hasOutputRegCe(C_HAS_CE, C_HAS_ACLR, C_HAS_SCLR, C_LATENCY),
			C_HAS_ACLR=>C_HAS_ACLR*C_REG_OUTPUT,
			C_HAS_SCLR=>C_HAS_SCLR*C_REG_OUTPUT)
			port map (
			D=>cos_outreg,
			CLK=>clk,
			CE=>outputRegCe,
			ACLR=>aclr,
			ASET=>zero,
			AINIT=>zero,
			SCLR=>sclr,
			SSET=>zero,
			SINIT=>zero,
			Q=>Cosine
			);
		end generate;
		
		hasCosRegOut0 : if not(C_REG_OUTPUT=1) generate
			
			Cosine <= cos_outreg;                      
			
		end generate;
	end generate;
	
	hasCos0 : if not((C_OUTPUTS_REQUIRED = COSINE_ONLY) or
		(C_OUTPUTS_REQUIRED = SINE_AND_COSINE)) generate
		Cosine <= (others=>'U');
	end generate;
	
end behavioral;


