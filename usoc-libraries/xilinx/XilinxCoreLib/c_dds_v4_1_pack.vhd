--$Id: c_dds_v4_1_pack.vhd,v 1.1 2010-07-10 21:42:42 mmartinez Exp $

library XilinxCoreLib, IEEE;
use XilinxCoreLib.mult_gen_v5_0_services.all;
use XilinxCoreLib.mult_const_pkg_v5_0.all; 
use IEEE.math_real.all;
use IEEE.std_logic_1164.all;
use XilinxCoreLib.ul_utils.all;

package c_dds_v4_1_pack is
	
	function max_int(integer_a, integer_b : integer) return integer;
	function has_const(inputval : integer) return integer;
	function has_q(inputval : integer) return integer;
	function has_s(inputval : integer) return integer;
	function getPipestages(inputA, inputB : integer) return integer;
	function hasOffset(inputval : integer) return integer; 
	function hasDithering(inputvalA : integer; inputvalB : boolean) return integer;
	function hasEff(inputval : integer) return integer;
	function getMultLatency(aWidth, bWidth, bType, pipelined, aType, hasCe, hasQ : integer) return integer;
	function multPipelined(lookupLatency : integer) return integer;
	function multHasQ(lookupLatency : integer) return integer;
	function errorDelayValue(lookupLatency, multLatency : integer) return integer;
	function errorConstant(phaseWidth, constWidth : integer) return std_logic_vector;
	function hasSinCosRdy (inputvalA, inputvalB : integer) return integer; 
	function lookupOutputWidth(inputvalA, inputvalB : integer) return integer;
	
	constant NONE : integer := 0;
	constant REG : integer := 1;
	constant CONST : integer := 2;
	
	constant PHASE_DITHERING : integer := 1;
	constant EFF : integer := 2;
	
	constant ONE_CYCLE : integer := 1;
	constant ZERO_CYCLE : integer := 0;
	
end c_dds_v4_1_pack;   

package body c_dds_v4_1_pack is
	
	function lookupOutputWidth (inputvalA, inputvalB : integer) return integer is
	begin
		if inputvalA = EFF then return 18;
		else return inputvalB;
		end if;
	end lookupOutputWidth;
	
	function hasSinCosRdy (inputvalA, inputvalB : integer) return integer is
	begin
		if inputvalA = 1 or hasEff(inputvalB) = 1 then return 1;
		else return 0;
		end if;
	end hasSinCosRdy;
	
	function errorConstant(phaseWidth, constWidth : integer) return std_logic_vector is 
		variable constReal : real;
		variable const : integer;
	begin
        -- CR 170237 - constant math_2_pi not supported by vhdlan
		constReal := 6.28318_53071_79586_47693/2.0**phaseWidth;
		const := integer(constReal * 2.0**constWidth);
		return int_2_std_logic_vector( const, constWidth);
	end errorConstant;
	
	function errorDelayValue(lookupLatency, multLatency : integer) return integer is
		variable result : integer;
	begin 
		result := lookupLatency - multLatency;
		if result < 1 then result := 1;
		end if;
		return result;
	end errorDelayValue;
	
	function multHasQ(lookupLatency : integer) return integer is
	begin
		if lookupLatency > 0 then return 1;
		else return 0;
		end if;
	end multHasQ;
	
	function multPipelined(lookupLatency : integer) return integer is
	begin
		if lookupLatency > 1 then return 1;
		else return 0;
		end if;
	end	multPipelined;
	
	function getMultLatency(aWidth, bWidth, bType, pipelined, aType, hasCe, hasQ : integer) return integer is
	begin
		return get_mult_gen_v5_0_latency(aWidth, bWidth, bType, 0, 0, DEFAULT_MEM_TYPE, pipelined, V2_PARALLEL, 0, DEFAULT_BAAT,
		"0", aType, 0, 0, 0, 0, hasCe, 0, 0, 0, hasQ);
	end getMultLatency;
	
	function hasOffset(inputval : integer) return integer is
	begin
		if inputval/=NONE then return 1;
		else return 0;
		end if;
	end hasOffset; 
	
	function hasDithering(inputvalA : integer; inputvalB : boolean) return integer is
	begin
		if inputvalA=PHASE_DITHERING and inputvalB=true then return 1;
		else return 0;
		end if;
	end hasDithering; 
	
	function hasEff(inputval : integer) return integer is
	begin
		if inputval=EFF then return 1;
		else return 0;
		end if;
	end hasEff;	
	
	function getPipestages(inputA, inputB : integer) return integer is
		
	begin 
		
		if inputA=0 then return inputB;
		else return inputA;
		end if;
		
	end getPipestages;
	
	function has_q(inputval : integer) return integer is
		
		variable result : integer := inputval;
		
	begin
		return result;
	end has_q;
	
	function has_s(inputval : integer) return integer is
		
		variable result : integer := 0;
		
	begin
		if inputval=0 then
			result := 1;
		end if;
		return result;
	end has_s;	
	
	function max_int(integer_a, integer_b : integer) return integer is
		
		variable result : integer := integer_a;
		
	begin
		
		if integer_b > integer_a then
			result := integer_b;
		end if;
		
		return result;
		
	end max_int;
	
	function has_const(inputval : integer) return integer is
		
		variable result : integer := 0;
		
	begin
		if inputval = CONST then
			result := 1;
		end if;
		return result;
	end has_const;
	
	
end c_dds_v4_1_pack;
