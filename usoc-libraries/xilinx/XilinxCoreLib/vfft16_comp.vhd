
Library IEEE;
Use IEEE.std_logic_1164.all;

package vfft16_comp is

component vfft16  port (
   di_r : in std_logic_vector(15 downto 0);
   di_i : in std_logic_vector(15 downto 0);
   clk : in std_logic;
   rs  : in std_logic;
   start : in std_logic;
   ce   : in std_logic;
   scale_mode : in std_logic;
   fwd_inv : in std_logic;
   ovflo    : out std_logic;
   mode_ce : out std_logic;
   xk_r : out std_logic_vector(15 downto 0);
   xk_i : out std_logic_vector(15 downto 0);
   done : out std_logic  );
end component;

END vfft16_comp;
