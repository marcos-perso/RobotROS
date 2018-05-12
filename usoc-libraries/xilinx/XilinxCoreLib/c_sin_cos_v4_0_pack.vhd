-- $Header: /local/Projects/CVS/P1/zpu_SoC/sources/xilinx/XilinxCoreLib/c_sin_cos_v4_0_pack.vhd,v 1.1 2010-07-10 21:42:56 mmartinez Exp $

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

package c_sin_cos_v4_0_pack is
	
	type table_array is array (natural range <>) of real;
	type func_type is (sin_table, cos_table);
	--type outputs_required_type is (SINE_ONLY, COSINE_ONLY, SINE_AND_COSINE);
	constant SINE_ONLY : integer := 0;
	constant COSINE_ONLY : integer := 1;
	constant SINE_AND_COSINE : integer := 2;
	constant DIST_ROM : integer := 0;
	constant BLOCK_ROM : integer := 1;
	
	function trig_array(trig_func : func_type;
	depth, width : integer; negative : integer) return table_array;
	
	function sin_val(theta : real) return real;
	function cos_val(theta : real) return real;
	
	function getWave(memType, thetaWidth, outputWidth : integer) return integer; 
	function getPipeStagesMax(memType, thetaWidth, outputWidth : integer) return integer;
	function getLatency(hasRegIn, hasRegOut, pipeStages : integer) return integer;
	function hasOutputRegCe(hasCe, hasAclr, hasSclr, latency : integer) return integer;
	
end c_sin_cos_v4_0_pack;


library ieee;
use ieee.math_real.all;
use ieee.std_logic_arith.all;

package body c_sin_cos_v4_0_pack is
	
	function hasOutputRegCe(hasCe, hasAclr, hasSclr, latency : integer) return integer is
		
	begin			   
		if hasCe=1 or ((hasAclr=1 or hasSclr=1) and latency > 1) then
			return 1;
		else return 0;
		end if;
	end hasOutputRegCe;	
	
	function trig_array(trig_func : func_type;
		depth, width : integer; negative : integer) return table_array is
		
		constant scale : real := 2.0**(width-1);
		constant delta_theta : real := (2.0 * math_pi) / real(depth);
		
		variable result : table_array( 0 to depth-1);
		variable theta, trig_real, trig_real_scaled, trig_rounded : real := 0.0;
		
	begin
		for i in 0 to depth-1 loop
			if trig_func = sin_table then
				trig_real := sin_val(theta);
				if negative = 1 then
					trig_real := -trig_real;
				end if;
			elsif trig_func = cos_table then
				trig_real := cos_val(theta);
				if negative = 1 then
					trig_real := -trig_real;
				end if;
			end if;
			trig_real_scaled := trig_real * scale;
			trig_rounded := round(trig_real_scaled);
			if trig_rounded = scale then
				trig_rounded := trig_rounded - 1.0;
			end if;
			result(i) := trig_rounded;
			theta := theta + delta_theta;
		end loop;
		return result;
	end trig_array;
	
	function sin_val(theta : real) return real is
		
		variable term, sum : real;
		variable n : integer;
		
	begin
		term := theta;
		sum := theta;
		n := 1;
		
		for i in 0 to 99 loop
			n := n + 2;
			term := -term*theta**2/real((n-1)*n);
			sum := sum + term;
		end loop;
		return sum;
	end sin_val;
	
	function cos_val(theta : real) return real is
		
		variable term, sum : real;
		variable n : integer;
		
	begin
		term := 1.0;
		sum := 1.0;
		n := 0;
		
		for i in 0 to 99 loop
			n := n + 2;
			term := -term*theta**2/real((n-1)*n);
			sum := sum + term;
		end loop;
		return sum;
	end cos_val;
	
	function getWave(memType, thetaWidth, outputWidth : integer) return integer is
		
		variable result : integer := 0;
		
	begin
		if memType=BLOCK_ROM then
			if (thetaWidth>10 or outputWidth>16) or
				(thetaWidth=10 and outputWidth>4) or
				(thetaWidth=9 and outputWidth>8) then
				result := 1;
			end if;
		elsif (thetaWidth>=7) then
			result := 1;
		end if;
		return result;
	end getWave;
	
	function getPipeStagesMax(memType, thetaWidth, outputWidth : integer) return integer is
		
		variable  result : integer := 0;
		
	begin
		if memType=DIST_ROM then
			if getWave(memType, thetaWidth, outputWidth)=1 then
				if thetaWidth<9 then
					result := 2;
				else result := 3;
				end if;
			end if;
		else
			result := 1;
			if getWave(memType, thetaWidth, outputWidth)=1 then
				result := 2;
			end if;	
		end if;
		return result;
	end getPipeStagesMax;
	
	function getLatency(hasRegIn, hasRegOut, pipeStages : integer) return integer is
		
		variable result : integer := 0;
		
	begin
		result := hasRegIn + hasRegOut + pipeStages;
		return result;		
	end getLatency;
	
end c_sin_cos_v4_0_pack;  

