--$Id: c_dds_v4_0_pack.vhd,v 1.1 2010-07-10 21:42:42 mmartinez Exp $

package c_dds_v4_0_pack is
	
	function max_int(integer_a, integer_b : integer) return integer;
	function has_const(inputval : integer) return integer;
	function has_q(inputval : integer) return integer;
	function has_s(inputval : integer) return integer;
	function getPipestages(inputA, inputB : integer) return integer;
	function hasOffset(inputval : integer) return integer; 
	function hasNoiseShaping(inputvalA : integer; inputvalB : boolean) return integer;
	
	constant NONE : integer := 0;
	constant REG : integer := 1;
	constant CONST : integer := 2;
	
	constant PHASE_DITHERING : integer := 1;
	
	constant ONE_CYCLE : integer := 1;
	constant ZERO_CYCLE : integer := 0;
	
end c_dds_v4_0_pack;

package body c_dds_v4_0_pack is
	
	function hasOffset(inputval : integer) return integer is
	begin
		if inputval/=NONE then return 1;
		else return 0;
		end if;
	end hasOffset; 
	
	function hasNoiseShaping(inputvalA : integer; inputvalB : boolean) return integer is
	begin
		if inputvalA/=NONE and inputvalB=true then return 1;
		else return 0;
		end if;
	end hasNoiseShaping;
	
	
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
	
	
end c_dds_v4_0_pack;
