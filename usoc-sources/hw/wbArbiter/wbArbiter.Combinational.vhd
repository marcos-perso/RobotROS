-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- 
-- Wishbone arbiter
-- 
-- NOTES:
--   * It handles 2 masters
--   * Masterr 1 has always priority
-- 
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:56:03 $
-- $Name:  $
-- $Revision: 1.1 $
-- 
-------------------------------------------------------------------------------


---------------
-- LIBRARIES --
---------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.zpu_config.all;
use work.zpupkg.all;
use work.WishboneConstantsPackage.all;
use work.RegisterMapPackage.all;

-----------------------------
-- ARCHITECTURE DEFINITION --
-----------------------------
 
architecture combinational of wbArbiter is


  -- CONSTANTS DEFINITION --

  -- SIGNAL DEFINITION --
  signal s_GRANT_1 : std_logic;
  signal s_GRANT_2 : std_logic;

  -- DEBUG

  -- ARCHITECTURE --

begin

  -- purpose: Grants access to only one master
  -- type   : combinational
  -- inputs : MASTER_1_CYC
  -- outputs: GRANT
  p_Grant: process (MASTER_1_CYC, MASTER_2_CYC)
  begin  -- process p_Grant

    s_GRANT_1 <= MASTER_1_CYC;
    s_GRANT_2 <= not(MASTER_1_CYC) and (MASTER_2_CYC);
    
  end process p_Grant;

  -- Continuous assignments
  p_GRANT_1 <= s_GRANT_1;
  p_GRANT_2 <= s_GRANT_2;
  p_CYC     <= MASTER_1_CYC or MASTER_2_CYC;

end combinational;

-------------------------------------------------------------------------------
-- $Log$
-------------------------------------------------------------------------------
