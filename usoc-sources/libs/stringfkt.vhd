--============================================================================
-- A set of some useful (String) functions to enhance the textoutput routines 
-- for testbenches (not for synthesis)
--
-- (C)Copyright Klaus Ruzicka, 2001
-- feel free to use/modify, absolutely no warranty
--============================================================================
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use ieee.numeric_std.all;

-- synopsys translate_off


package stringfkt is
  function i2s(i:integer; st:integer) return string;
  -- converts an integer into a string, st is the number of characters, one 
  -- character is added for the sign: <space> for positive <-> for negative

  function s2s(s: string) return string;
  -- convert string constant "blabla" to string, needed for thumb textoutput
  -- via assert statement

  function sl2c(sl: std_logic) return character;
  -- convert std_logic to character

  function slv2hexS(slv: std_logic_vector) return string;
  -- convert a std_logic_vector into a hex-string

  function slv2s(slv: std_logic_vector) return string;
  -- convert std_logic_vector to string (bitstream)

  function slv2bcd(slv: std_logic_vector) return string;
  -- convert a std_logic_vector into a binary bcd code-string

  function slv2dec(slv: std_logic_vector) return string;
  -- convert a std_logic_vector into a decimal-string

  function slvs2dec(slv: std_logic_vector) return string;
  -- convert a std_logic_vector (2th complement)into a 
  -- decimal-string with signum 

  function slvb2dec(slv: std_logic_vector) return string;
  -- convert a std_logic_vector (binary offset)into a 
  -- decimal-string with signum

  function s2is(s:string) return string;
  -- string ( vv.nnnnnnnE+mmm ) to integer-string ( vvnn fuer mmm=2)
  -- ACHTUNG: NUR POSTIVE EXPONENTEN SIND DERZEIT MÖGLICH! -------------------

  function is2slv(s:string; len:integer) return std_logic_vector;
  -- convert integer string (no exp) to std_logic_vector, but only len LSB
  -- s:string(1 to nnn)
  -- result: std_logic_vector(len downto 0)

  function k2_bo(k:std_logic_vector) return std_logic_vector;
  -- change 2th-complement to binary-offset and vice versa

  function HexString2slv ( constant s : string) return std_logic_vector;

  -- Converts Hex string to an integer
  function HexString2integer(constant s : string) return integer;

end;
--============================================================================
--============================================================================


package body stringfkt is

  function i2s(i:integer; st:integer) return string is
  -- converts an integer into a string, st is the number of characters, one 
  -- character is added for the sign: <space> for positive <-> for negative
-- synopsys translate_off

  variable result : string(1 to st+1);
  variable akt	  : integer;
  variable ii	  : integer :=i ;
-- synopsys translate_on
  begin
-- synopsys translate_off
    if i<0 then result(1):='-'; ii:=ii*(-1); else result(1):=' '; end if;
    for z in st-1 downto 0 loop
      akt:=ii/(10**z);
      case akt is
        when 1	=> result(st-z+1):='1';
        when 2	=> result(st-z+1):='2';
        when 3	=> result(st-z+1):='3';
        when 4	=> result(st-z+1):='4';
        when 5	=> result(st-z+1):='5';
        when 6	=> result(st-z+1):='6';
        when 7	=> result(st-z+1):='7';
        when 8	=> result(st-z+1):='8';
        when 9	=> result(st-z+1):='9';
        when others => result(st-z+1):='0';
      end case;
      ii:=ii-akt*(10**z);
    end loop;
    return result;

-- synopsys translate_on

  end; -- i2s
--============================================================================
  function s2s(s: string) return string is
  -- convert string constant "blabla" to string, needed for thumb textoutput
  -- via assert statement
-- synopsys translate_off
  variable result: string(1 to s'length);
-- synopsys translate_on
  begin
-- synopsys translate_off
    for i in 1 to s'length  loop
      result(i):=s(i);
    end loop;
    return result;
-- synopsys translate_on
  end; --s2s
--============================================================================
  function sl2c(sl: std_logic) return character is
-- synopsys translate_off
  -- convert std_logic to character
  variable result: character;
-- synopsys translate_on
  begin
-- synopsys translate_off
    case sl is
      when 'U' => result:='U';
      when 'X' => result:='X';
      when '0' => result:='0';
      when '1' => result:='1';
      when 'Z' => result:='Z';
      when 'W' => result:='W';
      when 'L' => result:='L';
      when 'H' => result:='H';
      when '-' => result:='-';
    end case;
    return result;
-- synopsys translate_on
  end; --sl2c
--============================================================================
  function slv2hexS1(slv: std_logic_vector) return integer is
-- synopsys translate_off
  -- used and described in slv2hexS (how many 4bit blocks)
  variable result : integer :=slv'length/4;
-- synopsys translate_on
  begin
-- synopsys translate_off
    if slv'length mod 4 > 0 then
      result:=result+1;
    end if;
    return result;
-- synopsys translate_on
  end; -- slv2hexS1

  function slv2hexS2(slv: std_logic_vector(3 downto 0)) return character is
-- synopsys translate_off
  -- used and described in slv2hexS (translate one 4bit block)
  variable result: character;
  variable work: std_logic_vector(3 downto 0):=slv;
-- synopsys translate_on
  begin
-- synopsys translate_off
    for i in 0 to 3 loop
      case work(i) is		-- no weak states
        when 'L' => work(i):='0';
        when 'H' => work(i):='1';
        when others =>
      end case;
    end loop;
    case work is
	when "0000" => result:='0';
	when "0001" => result:='1';
	when "0010" => result:='2';
	when "0011" => result:='3';
	when "0100" => result:='4';
	when "0101" => result:='5';
	when "0110" => result:='6';
	when "0111" => result:='7';
	when "1000" => result:='8';
	when "1001" => result:='9';
	when "1010" => result:='A';
	when "1011" => result:='B';
	when "1100" => result:='C';
	when "1101" => result:='D';
	when "1110" => result:='E';
	when "1111" => result:='F';
        when "ZZZZ" => result:='Z';
        when "XXXX" => result:='X';
        when "UUUU" => result:='U';
        when "WWWW" => result:='W';
        when "----" => result:='-';
        when others => result:='?';
    end case;
-- synopsys translate_on
    return result;
  end; -- slv2hexS2

  function slv2hexS(slv: std_logic_vector) return string is
-- synopsys translate_off

  -- convert a std_logic_vector into a hex-string
  -- split in 4bit blocks and translate each
  variable b     : integer := slv2hexS1(slv); 	-- nr of hex symbols
  variable result: string(1 to b);	 	-- reslut string	
  variable j     : integer;			-- counting index
  variable c     : std_logic_vector(slv'high+3 downto slv'low);
-- synopsys translate_on
  begin
-- synopsys translate_off
    c:="000"&slv; -- make sure that always 4bit avaliable for one hex symbol
    for i in 1 to b loop
      j:=(i-1)*4+slv'low;
      result(b-i+1):=slv2hexS2(c(j+3 downto j));    
    end loop;
-- synopsys translate_on
    return result;
  end; --slv2hexS
--============================================================================
  function slv2s(slv: std_logic_vector) return string is
-- synopsys translate_off
  -- convert std_logic_vector to string (bitstream)
  variable result: string(slv'range); 
-- synopsys translate_on
  begin
-- synopsys translate_off
    for i in slv'low to slv'high loop
      case slv(i) is
        when 'U' => result(i):='U';
        when 'X' => result(i):='X';
        when '0' => result(i):='0';
        when '1' => result(i):='1';
        when 'Z' => result(i):='Z';
        when 'W' => result(i):='W';
        when 'L' => result(i):='L';
        when 'H' => result(i):='H';
        when '-' => result(i):='-';
      end case;
    end loop;
    return result;
-- synopsys translate_on
  end; --slv2s
--============================================================================

  function slv2dec1(slv: std_logic_vector(3 downto 0)) return std_logic_vector is
-- synopsys translate_off
  -- dual to bcd correction table
  variable result : std_logic_vector(3 downto 0);
-- synopsys translate_on
  begin
-- synopsys translate_off
    case slv is
      when "0000" => result:="0000";	-- 0 -> 0
      when "0001" => result:="0001";	-- 1 -> 1
      when "0010" => result:="0010";	-- 2 -> 2
      when "0011" => result:="0011";	-- 3 -> 3
      when "0100" => result:="0100";	-- 4 -> 4
      when "0101" => result:="1000";	-- 5 -> 8
      when "0110" => result:="1001";	-- 6 -> 9
      when "0111" => result:="1010";	-- 7 ->10
      when "1000" => result:="1011";	-- 8 ->11
      when "1001" => result:="1100";	-- 9 ->12
      when others => result:="XXXX";
    end case;
    return result;
-- synopsys translate_on
  end; -- slvdec1

  function slv2dec2(slv: std_logic_vector) return integer is
-- synopsys translate_off
  -- how many bcd symbols
  variable value : integer := 2**slv'length;
  variable result: integer;
-- synopsys translate_on
  begin
-- synopsys translate_off
    result:=1;
    while value>(10**result) loop
      result:=result+1;
    end loop;
    return result;
-- synopsys translate_on
  end; -- slv2dec2
--============================================================================
  function slv2bcd(slv: std_logic_vector) return string is
-- synopsys translate_off
  -- convert a std_logic_vector into a binary bcd code-string
  variable b     : integer := slv2dec2(slv);	-- nr of bcd symbols
  variable c	 : std_logic_vector(b*4-1 downto 0);
-- synopsys translate_on
  begin
-- synopsys translate_off
    c := (others =>'0');
    for i in slv'high downto slv'low loop
      for j in 1 to b loop	-- correct
        c(j*4-1 downto (j-1)*4):=slv2dec1(c(j*4-1 downto (j-1)*4));
      end loop; --j
      c:=shl(c,"1");		-- shift
      c(0):= slv(i);
    end loop; --i 
    return slv2s(c);
-- synopsys translate_on
  end; --slv2bcd
--============================================================================
  function slv2dec(slv: std_logic_vector) return string is
-- synopsys translate_off
  -- convert a std_logic_vector into a decimal-string
  variable b     : integer := slv2dec2(slv);	-- nr of bcd symbols
  variable c	 : std_logic_vector(b*4-1 downto 0);
-- synopsys translate_on
  begin
-- synopsys translate_off
    c := (others =>'0');
    for i in slv'high downto slv'low loop
      for j in 1 to b loop	-- correct
        c(j*4-1 downto (j-1)*4):=slv2dec1(c(j*4-1 downto (j-1)*4));
      end loop; --j
      c:=shl(c,"1");		-- shift
      c(0):= slv(i);
    end loop; --i 
    return slv2hexS(c);
-- synopsys translate_on
  end; --slv2dec
--============================================================================
  function slvs2dec(slv: std_logic_vector) return string is
-- synopsys translate_off
  -- convert a std_logic_vector into a decimal-string with signum (2th complement)
-- synopsys translate_on
  begin
-- synopsys translate_off
    if slv(slv'high)='0' then 	-- "+"
      return "+"&slv2dec(slv);
    else
      return "-"&slv2dec(not slv+1);
    end if;
-- synopsys translate_on
  end; --slvs2dec
--============================================================================
  function slvb2dec(slv: std_logic_vector) return string is
-- synopsys translate_off
  -- convert a std_logic_vector into a decimal-string with signum (binary offset)
  variable c:std_logic_vector(slv'range):=slv;
-- synopsys translate_on
  begin
-- synopsys translate_off
    c(c'high):=not c(c'high);
    return slvs2dec(c);
-- synopsys translate_on
  end; --slvb2dec
--============================================================================
  function s2is(s:string) return string is
-- synopsys translate_off
  -- string ( vv.nnnnnnnE+mmm ) to integer-string ( vvnn fuer mmm=2)
  variable v:	string(s'range);  --result: Vorkomma (Daten)
  variable vp:	integer:=0;	  --result: Vorkomma (Bearbeitungsposition)
  variable n:	string(s'range):=(others => '0'); --result: Nachkomma (Daten)
  variable np:	integer:=0;       --result: Nachkomma (Bearbeitungsposition)
  variable e:	integer:=0;	  --result: Exponent
  variable dd:  boolean:=false;   -- Dezimalpunkt gefunden
  variable ee:  boolean:=false;   -- Exponentialsymbol (e oder E) gefunden
  variable vz:  character:='+';	  -- Vorzeichen des Exponenten
-- ACHTUNG: NUR POSTIVE EXPONENTEN SIND DERZEIT MÖGLICH----------------------
-- synopsys translate_on
  begin
-- synopsys translate_off
    for i in s'range  loop
      if s(i)='.' then
        dd:=true;
      else	-- not "."
        if s(i)='e' or s(i)='E' then
          ee:=true;
        else	-- not "E"
            if ee=false then
              if dd=false then
                if s(i)/=' ' then
                  vp:=vp+1;
                  np:=vp;
                  v(vp):=s(i);
                end if;
              else	-- dd=false
                np:=np+1;
                n(np):=s(i);
              end if;	-- dd=false
            else  -- ee=false
              if s(i)='+' or s(i)='-' then 
                if s(i)='-' then
                  vz:='-';
                end if;
              else  -- e: not +/-
                case s(i) is
                  when '0' => e:=e*10;
                  when '1' => e:=e*10+1;
                  when '2' => e:=e*10+2;
                  when '3' => e:=e*10+3;
                  when '4' => e:=e*10+4;
                  when '5' => e:=e*10+5;
                  when '6' => e:=e*10+6;
                  when '7' => e:=e*10+7;
                  when '8' => e:=e*10+8;
                  when '9' => e:=e*10+9;
                  when others => 
  	        end case;
              end if;	-- e:+/-
            end if;	-- ee=false
        end if;		-- E
      end if; 		-- .	
    end loop;
    if vz='+' then
      for i in vp+1 to vp+e  loop
        v(i):=n(i);
      end loop;
--assert false report "S2IS*"&s&"=>"&v(1 to vp+e)&"***" severity error;--debug
      return v(1 to vp+e );
    else
      assert false report "S2IS*"&s&"=> ERROR!" severity error;
      return "ERROR";
    end if;    
-- synopsys translate_on
  end;
--============================================================================
  function bcd2d(slv:std_logic_vector(3 downto 0)) return std_logic_vector is
-- synopsys translate_off
  -- bcd to binary conversion table
  variable result : std_logic_vector(3 downto 0);
-- synopsys translate_on
  begin
-- synopsys translate_off
    case slv is
      when "0000" => result:="0000";	-- 0 -> 0
      when "0001" => result:="0001";	-- 1 -> 1
      when "0010" => result:="0010";	-- 2 -> 2
      when "0011" => result:="0011";	-- 3 -> 3
      when "0100" => result:="0100";	-- 4 -> 4
      when "0101" => result:="0101";	-- 5 -> 5
      when "0110" => result:="0110";	-- 6 -> 6
      when "0111" => result:="0111";	-- 7 -> 7
      when "1000" => result:="0101";	-- 8 -> 5
      when "1001" => result:="0110";	-- 9 -> 6
      when "1010" => result:="0111";	--10 -> 7
      when "1011" => result:="1000";	--11 -> 8
      when "1100" => result:="1001";	--12 -> 9
      when "1101" => result:="1010";	--13 ->10
      when "1110" => result:="1011";	--14 ->11
      when "1111" => result:="1100";	--15 ->12
      when others => result:="XXXX";
    end case;
    return result;
-- synopsys translate_on
  end;
--============================================================================
  function m_ax(a,b:integer) return integer is
-- synopsys translate_off
  -- returns the maximum of two integer values
-- synopsys translate_on
  begin
-- synopsys translate_off
    if a>=b then
       return a;
    else
       return b;
    end if;
-- synopsys translate_on
  end;	-- max
-- ===========================================================================
  function is2slv(s:string; len:integer) return std_logic_vector is
-- synopsys translate_off
  -- convert integer string (no exp) to std_logic_vector, but only len LSB
  -- s:string(1 to nnn)
  -- result: std_logic_vector(len downto 0)
  variable L: integer:=s'length*4-1;
  variable result: std_logic_vector(m_ax(len,s'length*4-1) downto 0):=(others=>'0');
  variable n:integer;
  variable neg:boolean:=false;
 
-- synopsys translate_on
  begin
-- synopsys translate_off
--assert false report "IS2SLV<"&s&"d string" severity error;  -- check input string
    for i in s'range loop		-- decimal string to bcd vectors
      case s(s'length+1-i) is
        when '0' => result(i*4-1 downto (i-1)*4):="0000";	
        when '1' => result(i*4-1 downto (i-1)*4):="0001";	
        when '2' => result(i*4-1 downto (i-1)*4):="0010";	
        when '3' => result(i*4-1 downto (i-1)*4):="0011";	
        when '4' => result(i*4-1 downto (i-1)*4):="0100";	
        when '5' => result(i*4-1 downto (i-1)*4):="0101";	
        when '6' => result(i*4-1 downto (i-1)*4):="0110";	
        when '7' => result(i*4-1 downto (i-1)*4):="0111";	
        when '8' => result(i*4-1 downto (i-1)*4):="1000";	
        when '9' => result(i*4-1 downto (i-1)*4):="1001";	
        when '-' => neg:=true;	
        when '+' => neg:=false;	
        when others => result((i+1)*4-1 downto i*4):="XXXX";
      end case;
    end loop;
--assert false report "IS2SLV<"&slv2s(result)&"b" severity error;  -- check vector
    if L>4 then	-- full bcd to binary conversion
      for i in 1 to L-4 loop
--assert false report "      "&i2s(i,2)&">"&slv2s(result(i+3 downto i))&"=>"&slv2s(bcd2d(result(i+3 downto i))) severity error;
        result(i+3 downto i):=bcd2d(result(i+3 downto i));
        n:=i+4;
        while n<=L-4 loop
--assert false report "      "&i2s(n,2)&">"&slv2s(result(n+3 downto n))&"=>"&slv2s(bcd2d(result(n+3 downto n))) severity error;
          result(n+3 downto n):=bcd2d(result(n+3 downto n));
          n:=n+4;
        end loop;
--assert false report "IS2SLV>"&slv2s(result)&"***"&slv2s(result(i downto 0)) severity error;
      end loop;
    end if;

    if neg then    -- 2th complement
--assert false report "IS2SLV*"&s&"=>"&slv2s(result)&"* len="&i2s(len,2) severity error;
      result(len downto 0):=not result(len downto 0)+1;
--assert false report "IS2SLV*"&s&"=>"&slv2s(result)&"**" severity error;
    end if;
--assert false report "IS2SLV*"&s&"=>"&slv2s(result)&"##################"&slv2dec(result) severity error;
    return result(len downto 0);
-- synopsys translate_on
  end;
--============================================================================
  function k2_bo(k:std_logic_vector) return std_logic_vector is
-- synopsys translate_off
  -- change 2th-complement to binary-offset and vice versa
  variable result:std_logic_vector(k'range):=k;
-- synopsys translate_on
  begin
-- synopsys translate_off
    result(k'high):=not result(k'high);
    return result;
-- synopsys translate_on
  end;
--============================================================================
  function HexString2slv(constant s : string) return std_logic_vector is
-- synopsys translate_off

-- synopsys translate_off

    variable result: std_logic_vector(s'length*4-1 downto 0):=(others=>'0');

-- synopsys translate_on
  begin
-- synopsys translate_off
    for i in s'range loop		-- decimal string to bcd vectors
      case s(s'length+1-i) is
        when '0' => result(i*4-1 downto (i-1)*4):="0000";	
        when '1' => result(i*4-1 downto (i-1)*4):="0001";	
        when '2' => result(i*4-1 downto (i-1)*4):="0010";	
        when '3' => result(i*4-1 downto (i-1)*4):="0011";	
        when '4' => result(i*4-1 downto (i-1)*4):="0100";	
        when '5' => result(i*4-1 downto (i-1)*4):="0101";	
        when '6' => result(i*4-1 downto (i-1)*4):="0110";	
        when '7' => result(i*4-1 downto (i-1)*4):="0111";	
        when '8' => result(i*4-1 downto (i-1)*4):="1000";	
        when '9' => result(i*4-1 downto (i-1)*4):="1001";	
        when 'a' => result(i*4-1 downto (i-1)*4):="1010";	
        when 'b' => result(i*4-1 downto (i-1)*4):="1011";	
        when 'c' => result(i*4-1 downto (i-1)*4):="1100";	
        when 'd' => result(i*4-1 downto (i-1)*4):="1101";	
        when 'e' => result(i*4-1 downto (i-1)*4):="1110";	
        when 'f' => result(i*4-1 downto (i-1)*4):="1111";	
        when ',' => null;
        when others => result((i+1)*4-1 downto i*4):="XXXX";
      end case;
    end loop;

    return result;
-- synopsys translate_on
  end;

--============================================================================
  function HexString2integer(constant s : string) return integer is
-- synopsys translate_off

-- synopsys translate_off

    --variable result: std_logic_vector(s'length*4-1 downto 0):=(others=>'0');
    variable result: std_logic_vector(s'length*4 downto 0):=(others=>'0');
    variable result_int: integer := 0;


-- synopsys translate_on
  begin

--    assert false report s severity note;

-- synopsys translate_off
    for i in s'range loop		-- decimal string to bcd vectors
      case s(s'length+1-i) is
        when '0' => result(i*4-1 downto (i-1)*4):="0000";	
        when '1' => result(i*4-1 downto (i-1)*4):="0001";	
        when '2' => result(i*4-1 downto (i-1)*4):="0010";	
        when '3' => result(i*4-1 downto (i-1)*4):="0011";	
        when '4' => result(i*4-1 downto (i-1)*4):="0100";	
        when '5' => result(i*4-1 downto (i-1)*4):="0101";	
        when '6' => result(i*4-1 downto (i-1)*4):="0110";	
        when '7' => result(i*4-1 downto (i-1)*4):="0111";	
        when '8' => result(i*4-1 downto (i-1)*4):="1000";	
        when '9' => result(i*4-1 downto (i-1)*4):="1001";	
        when 'a' => result(i*4-1 downto (i-1)*4):="1010";	
        when 'b' => result(i*4-1 downto (i-1)*4):="1011";	
        when 'c' => result(i*4-1 downto (i-1)*4):="1100";	
        when 'd' => result(i*4-1 downto (i-1)*4):="1101";	
        when 'e' => result(i*4-1 downto (i-1)*4):="1110";	
        when 'f' => result(i*4-1 downto (i-1)*4):="1111";	
        when 'A' => result(i*4-1 downto (i-1)*4):="1010";	
        when 'B' => result(i*4-1 downto (i-1)*4):="1011";	
        when 'C' => result(i*4-1 downto (i-1)*4):="1100";	
        when 'D' => result(i*4-1 downto (i-1)*4):="1101";	
        when 'E' => result(i*4-1 downto (i-1)*4):="1110";	
        when 'F' => result(i*4-1 downto (i-1)*4):="1111";	
        when ',' => null;
        when others => result((i+1)*4-1 downto i*4):="XXXX";
      end case;
--    assert false report slv2hexS(result) severity note;
    end loop;

    result_int := to_integer(unsigned(result));
    return result_int;

--    variable result_int: integer := 0;

---- synopsys translate_on
--  begin
---- synopsys translate_off
--    for i in s'range loop		-- decimal string to bcd vectors
--      case s(s'length+1-i) is
--        when '0' => result_int := result_int + (0 * 2**i)*16;
--        when '1' => result_int := result_int + (1 * 2**i)*16;
--        when '2' => result_int := result_int + (2 * 2**i)*16;
--        when '3' => result_int := result_int + (3 * 2**i)*16;
--        when '4' => result_int := result_int + (4 * 2**i)*16;
--        when '5' => result_int := result_int + (5 * 2**i)*16;
--        when '6' => result_int := result_int + (6 * 2**i)*16;
--        when '7' => result_int := result_int + (7 * 2**i)*16;
--        when '8' => result_int := result_int + (8 * 2**i)*16;
--        when '9' => result_int := result_int + (9 * 2**i)*16;
--        when 'A' => result_int := result_int + (10 * 2**i)*16;
--        when 'B' => result_int := result_int + (11 * 2**i)*16;
--        when 'C' => result_int := result_int + (12 * 2**i)*16;
--        when 'D' => result_int := result_int + (13 * 2**i)*16;
--        when 'E' => result_int := result_int + (14 * 2**i)*16;
--        when 'F' => result_int := result_int + (15 * 2**i)*16;
--        when others => null;
--      end case;
--    end loop;

--    return result_int;
-- synopsys translate_on
  end;
--============================================================================
end;

-- synopsys translate_on
--============================================================================
-- End Of File
--============================================================================
