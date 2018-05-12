-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Wishbone arbiter
--
-- NOTES:
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

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use work.zpu_config.all;
use work.zpupkg.all;
-- synopsys translate off
use work.txt_util.all;
-- synopsys translate on
use work.WishboneConstantsPackage.all;

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package wbArbiterComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------

  component wbArbiter is

    generic (
      log_file:       string -- Debug file
      );

    port(

      MASTER_1_CYC  : in std_logic;
      MASTER_2_CYC  : in std_logic;
      p_GRANT_1     : out std_logic;
      p_GRANT_2     : out std_logic;
      p_CYC         : out std_logic

    );      
  end component;

end wbArbiterComponentPackage;
   


-------------------------------------------------------------------------------
-- $Log: wbArbiterComponentPackage.vhd,v $
-- Revision 1.1  2010-07-10 21:56:03  mmartinez
-- Files imported
--
-- Revision 1.5  2010-07-10 08:21:36  mmartinez
-- Separation between FLASH and DRAM
--
-- Revision 1.4  2010-07-08 14:57:14  mmartinez
-- Addition to WB system of the external single port ram
--
-- Revision 1.3  2010-06-17 22:41:32  mmartinez
-- Basic behaviour completed
--
-- Revision 1.2  2010-06-10 21:10:34  mmartinez
-- *** empty log message ***
--
-- Revision 1.1  2010-06-07 20:58:30  mmartinez
-- Module creation
--
-------------------------------------------------------------------------------
