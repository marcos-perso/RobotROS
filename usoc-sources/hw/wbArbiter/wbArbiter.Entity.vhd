-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Wishbone Arbiter
--
-- NOTES:
--
-- $Author: mmartinez $
-- $Date: 2010-07-10 21:56:03 $
-- $Name:  $
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library work;
use work.zpu_config.all;
use work.zpupkg.all;
-- $Revision: 1.1 $
--
-------------------------------------------------------------------------------


---------------
-- LIBRARIES --
---------------

use work.WishboneConstantsPackage.all;

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity wbArbiter is

  generic (
    log_file:       string -- Debug file
    );

  port(

    -- MASTER 1 interface
    MASTER_1_CYC   : in std_logic;

    -- MASTER 2 interface
    MASTER_2_CYC   : in std_logic;

    -- GRANTS
    p_GRANT_1     : out std_logic;
    p_GRANT_2     : out std_logic;
    -- Global CYC
    p_CYC         : out std_logic

    );      
end wbArbiter;
   

-------------------------------------------------------------------------------
-- $Log: wbArbiterEntity.vhd,v $
--
-------------------------------------------------------------------------------
