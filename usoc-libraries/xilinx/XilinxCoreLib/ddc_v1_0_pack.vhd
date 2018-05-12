library ieee;
use ieee.std_logic_1164.all;
use ieee.STD_LOGIC_SIGNED.all;

library XilinxCoreLib;
use XilinxCoreLib.ul_utils.all;


package ddc_v1_0_pack is

	constant NONE    : integer := 0;
	constant FIXED   : integer := 2;
	constant REG     : integer := 1;
	
	FUNCTION getPhaseAccumWidth(inputSampleFreq, freqResolution: real) return integer; 
	FUNCTION getRateChangeRegWidth(decimationHighRateChange: integer) return integer;
	FUNCTION getLdDinWidth(PeakDetect, c_phase_increment_type, c_phase_accum_width, c_phase_offset_type, c_cic_decimate_type, c_cic_decimation_range_high, c_gain_type, c_cfir_coef_width, c_pfir_coef_width, c_cfir_reload, c_pfir_reload: integer) return integer;
	FUNCTION getThresholdWidth(peakDetect: integer) return integer;

end;
	
package body ddc_v1_0_pack is

	FUNCTION getPhaseAccumWidth(inputSampleFreq, freqResolution: real) return	integer is
		variable phaseAccumWidth: integer := 1;
		variable compareValue: real := 2.0;
		variable ratio: real := (inputSampleFreq * 1000000.0 / freqResolution);
	begin
		
		while (compareValue < ratio) loop
			phaseAccumWidth := phaseAccumWidth + 1;
			compareValue := compareValue * 2.0;
		end loop;
		
	  return phaseAccumWidth;	

	end getPhaseAccumWidth;


	FUNCTION getRateChangeRegWidth(decimationHighRateChange: integer) return integer is
  	variable rateChangeBits: integer := 1;
  	variable compareValue: integer := 1;
	begin

  	while (decimationHighRateChange > compareValue) loop
    	rateChangeBits := rateChangeBits + 1;
    	compareValue := compareValue * 2;
  	end loop;
		
  	return rateChangeBits;
		
	end getRateChangeRegWidth;


	FUNCTION getLdDinWidth(PeakDetect, c_phase_increment_type, c_phase_accum_width, c_phase_offset_type, c_cic_decimate_type, c_cic_decimation_range_high, c_gain_type, c_cfir_coef_width, c_pfir_coef_width, c_cfir_reload, c_pfir_reload: integer) return integer is
	  variable ld_din_width: integer := 0;
	begin

  	if (PeakDetect > 0) then
    	ld_din_width := 2;
  	end if;

  	if (c_phase_increment_type = REG) then
    	if (c_phase_accum_width > ld_din_width) then
      	ld_din_width := c_phase_accum_width;
    	end if;
  	end if;
	
  	if (c_phase_offset_type = REG) then
    	if (c_phase_accum_width > ld_din_width) then
      	ld_din_width := c_phase_accum_width;
    	end if;
  	end if;

  	if (c_cic_decimate_type = REG) then
    	if (getRateChangeRegWidth(c_cic_decimation_range_high) > ld_din_width ) then
      	ld_din_width := getRateChangeRegWidth(c_cic_decimation_range_high);
    	end if;
  	end if;
	
		if (c_gain_type = REG) then
    	if (ld_din_width < 3) then
      	ld_din_width := 3;
    	end if;
  	end if;

  	if (c_cfir_reload = 1) then
    	if (c_cfir_coef_width > ld_din_width) then
      	ld_din_width := c_cfir_coef_width;
    	end if;
  	end if;

  	if (c_pfir_reload = 1) then
    	if (c_pfir_coef_width > ld_din_width) then
      	ld_din_width := c_pfir_coef_width;
    	end if;
  	end if;

  	return ld_din_width;

	end getLdDinWidth;


	FUNCTION getThresholdWidth(peakDetect: integer) return integer is
  	variable thresholdMonitorReadPortWidth: integer := 8;
	begin

  	if (peakDetect > 1) then
    	thresholdMonitorReadPortWidth := 16;
  	end if;

  	return thresholdMonitorReadPortWidth;

	end getThresholdWidth;

end ddc_v1_0_pack;

