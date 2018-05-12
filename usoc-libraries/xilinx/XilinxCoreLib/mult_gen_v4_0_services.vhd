-------------------------------------------------------------------------------
-- mult_gen_v4_0 Intelligent Functions Package
-------------------------------------------------------------------------------
-- The purpose of this package, is to make
-- 'intelligent' functions available to VHDL
-- and XCC developers, that used to be available
-- to JAVA developers alone.
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
--use IEEE.numeric_std.all;

library XilinxCoreLib;
use XilinxCoreLib.parm_v4_0_services.all;
use XilinxCoreLib.ccm_v4_0_services.all;
use XilinxCoreLib.sqm_v4_0_services.all;

package mult_gen_v4_0_services is

   -- See below for a description of each function

   function get_mult_gen_v4_0_latency(c_a_width        : integer;
                                      c_b_width        : integer;
                                      c_b_type         : integer;
                                      c_has_a_signed   : integer;
                                      c_reg_a_b_inputs : integer;
                                      c_mem_type       : integer;
                                      c_pipeline       : integer;
                                      c_mult_type      : integer;
                                      c_has_loadb      : integer;
                                      c_baat           : integer;
                                      c_b_value        : string;
                                      c_a_type         : integer;
                                      c_has_swapb      : integer;
                                      c_sqm_type       : integer;
                                      bram_addr_width  : integer) return integer;

    function calc_clocks(c_a_width, c_baat : integer) return integer;
    
    function get_mult_gen_v4_0_registers(c_a_width        : integer;
                                      c_b_width        : integer;
                                      c_b_type         : integer;
                                      c_has_a_signed   : integer;
                                      c_reg_a_b_inputs : integer;
                                      c_mem_type       : integer;
                                      c_pipeline       : integer;
                                      c_mult_type      : integer;
                                      c_has_loadb      : integer;
                                      c_baat           : integer;
                                      c_b_value        : string;
                                      c_a_type         : integer;
                                      c_has_swapb      : integer;
                                      c_sqm_type       : integer;
                                      bram_addr_width  : integer
                                      ) return integer;
    
end mult_gen_v4_0_services;

package body mult_gen_v4_0_services is

-------------------------------------------------------------------------------
-- Calls calc_latency function, which is defined within the sqm_pack_v4_0 package.
-- Inputs:

   function get_mult_gen_v4_0_latency(c_a_width        : integer;
                                      c_b_width        : integer;
                                      c_b_type         : integer;
                                      c_has_a_signed   : integer;
                                      c_reg_a_b_inputs : integer;
                                      c_mem_type       : integer;
                                      c_pipeline       : integer;
                                      c_mult_type      : integer;
                                      c_has_loadb      : integer;
                                      c_baat           : integer;
                                      c_b_value        : string;
                                      c_a_type         : integer;
                                      c_has_swapb      : integer;
                                      c_sqm_type       : integer;
                                      bram_addr_width  : integer
                                      ) return integer is

      variable latency       : integer;
      variable c_b_constant  : integer;

   begin

      if (c_has_loadb = 0) then
         c_b_constant := 1;
      else
         c_b_constant := 0;
      end if;

      if (c_baat = c_a_width) then
         -- non sqm multiplier
         if (c_mult_type < 2) then
            -- parm_v4_0 based multiplier
            latency := get_parm_v4_0_latency(c_mult_type, c_a_width, c_a_type, c_b_width,
                                             c_b_type, c_reg_a_b_inputs, c_pipeline, c_has_a_signed);
         else
            --ccm_v4_0 based multiplier
            latency :=
               get_ccm_v4_0_latency(c_a_width, c_has_a_signed, c_a_type, c_reg_a_b_inputs,
                                    c_has_swapb, c_mem_type, bram_addr_width, c_pipeline,
                                    c_b_constant, c_b_type, c_b_value, c_b_width);
         end if;

      else
         --sqm based multiplier
         
         latency := get_sqm_v4_0_latency(c_reg_a_b_inputs, c_sqm_type, c_baat, c_mult_type,
                                         c_pipeline, c_a_width, c_has_a_signed, c_a_type,
                                         c_has_swapb, c_mem_type, bram_addr_width, c_b_width,
                                         c_has_loadb, c_b_type, c_b_value); 
                                         --- calc_clocks(c_a_width, c_baat) - 1;
         
      end if;

      return latency;

   end get_mult_gen_v4_0_latency;
   
   function calc_clocks(c_a_width, c_baat : integer) return integer is
      variable width  : integer := c_a_width;
      variable clocks : integer := 0;
   begin
      for i in 0 to c_a_width loop
         if (width > 0) then
            width  := width-c_baat;
            clocks := clocks+1;
         end if;
      end loop;
      return clocks;
   end calc_clocks;
   
   -- Latency function for the behavioural model. This returns the number of register 
   -- levels in the design.
   function get_mult_gen_v4_0_registers(c_a_width        : integer;
                                      c_b_width        : integer;
                                      c_b_type         : integer;
                                      c_has_a_signed   : integer;
                                      c_reg_a_b_inputs : integer;
                                      c_mem_type       : integer;
                                      c_pipeline       : integer;
                                      c_mult_type      : integer;
                                      c_has_loadb      : integer;
                                      c_baat           : integer;
                                      c_b_value        : string;
                                      c_a_type         : integer;
                                      c_has_swapb      : integer;
                                      c_sqm_type       : integer;
                                      bram_addr_width  : integer
                                      ) return integer is

      variable latency       : integer;
      variable c_b_constant  : integer;
      variable sqm_hack      : integer;

   begin

      if (c_has_loadb = 0) then
         c_b_constant := 1;
      else
         c_b_constant := 0;
      end if;

      if (c_reg_a_b_inputs = 1 and c_sqm_type = 1) then
         sqm_hack := 1;
      else
         sqm_hack := 0;
      end if;
      
      if (c_baat = c_a_width) then
         -- non sqm multiplier
         if (c_mult_type < 2) then
            -- parm_v4_0 based multiplier
            latency := get_parm_v4_0_latency(c_mult_type, c_a_width, c_a_type, c_b_width,
                                             c_b_type, c_reg_a_b_inputs, c_pipeline, c_has_a_signed);
         else
            --ccm_v4_0 based multiplier
            latency :=
               get_ccm_v4_0_latency(c_a_width, c_has_a_signed, c_a_type, c_reg_a_b_inputs,
                                    c_has_swapb, c_mem_type, bram_addr_width, c_pipeline,
                                    c_b_constant, c_b_type, c_b_value, c_b_width);
         end if;

      else
         --sqm based multiplier
         
         latency := get_sqm_v4_0_latency(c_reg_a_b_inputs, c_sqm_type, c_baat, c_mult_type,
                                         c_pipeline, c_a_width, c_has_a_signed, c_a_type,
                                         c_has_swapb, c_mem_type, bram_addr_width, c_b_width,
                                         c_has_loadb, c_b_type, c_b_value)
                                         - sqm_hack - calc_clocks(c_a_width, c_baat) - 1;
         
      end if;

      return latency;

   end get_mult_gen_v4_0_registers;

end mult_gen_v4_0_services;
