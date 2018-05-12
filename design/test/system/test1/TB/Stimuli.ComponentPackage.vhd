-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Creates stimuli for the simulation
--
-- $Author: mmartinez $
-- $Date: 2010-07-01 16:59:25 $
-- $Name:  $
-- $Revision: 1.2 $
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

----------------------------------
-- COMPONENT PACKAGE DEFINITION --
----------------------------------

package StimuliComponentPackage is

--------------------------
-- COMPONENT DEFINITION --
--------------------------

  component Stimuli is
    port(

      -- Clock/Reset
      clk           : in  std_logic;
      reset         : in  std_logic;

    -- Button interface
      p_ButtonCaption1 : out std_logic;
      p_ButtonCaption2 : out std_logic;
      p_ButtonCaption3 : out std_logic

      );      
  end component;

end StimuliComponentPackage;
   
-------------------------------------------------------------------------------
-- $Log: Stimuli.ComponentPackage.vhd,v $
-- Revision 1.2  2010-07-01 16:59:25  mmartinez
-- File changes
--
-- Revision 1.1  2010-06-13 19:07:15  mmartinez
-- File creation
--
-------------------------------------------------------------------------------
