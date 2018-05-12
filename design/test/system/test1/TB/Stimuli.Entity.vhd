-------------------------------------------------------------------------------
-- DESCRIPTION: 
-- Creates stimuli for the simulation
--
-- $Author: mmartinez $
-- $Date: 2010-06-13 19:07:15 $
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

-----------------------
-- ENTITY DEFINITION --
-----------------------
 
entity Stimuli is
  port(

    -- Clock / Reset signals
    clk           : in  std_logic;
    reset         : in  std_logic;

    -- Button interface
    p_ButtonCaption1 : out std_logic;
    p_ButtonCaption2 : out std_logic;
    p_ButtonCaption3 : out std_logic

    );      
end Stimuli;
   

-------------------------------------------------------------------------------
-- $Log: Stimuli.Entity.vhd,v $
-- Revision 1.1  2010-06-13 19:07:15  mmartinez
-- File creation
--
-------------------------------------------------------------------------------
