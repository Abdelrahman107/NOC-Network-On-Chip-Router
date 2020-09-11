
library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.ALL;

entity tb is
end entity;

architecture behav of tb is
SIGNAL datai1 : std_logic_vector(7 DOWNTO 0);
SIGNAL datai2 : std_logic_vector(7 DOWNTO 0);
SIGNAL datai3 : std_logic_vector(7 DOWNTO 0);
SIGNAL datai4 : std_logic_vector(7 DOWNTO 0);
------------

SIGNAL datao1 : std_logic_vector(7 DOWNTO 0);
SIGNAL datao2 : std_logic_vector(7 DOWNTO 0);
SIGNAL datao3 : std_logic_vector(7 DOWNTO 0);
SIGNAL datao4 : std_logic_vector(7 DOWNTO 0);
--------------
SIGNAL wr1 : std_logic;
SIGNAL wr2 : std_logic;
SIGNAL wr3 : std_logic;
SIGNAL wr4 : std_logic;	 
-----------
SIGNAL wclock : std_logic;
SIGNAL rclock : std_logic;
SIGNAL rst : std_logic;



component router 

port(
	datai1,datai2,datai3,datai4 : in std_logic_vector(7 downto 0);
	datao1,datao2,datao3,datao4 :out std_logic_vector(7 downto 0);
	wr1,wr2,wr3,wr4,wclock,rclock,rst : in std_logic);

end component;




begin


--Porting--
 dut: Router port map (datai1,datai2,datai3,datai4,datao1,datao2,datao3,datao4,
   wr1,wr2,wr3,wr4,wclock,rclock,rst);
------



p1: process is
begin

wclock <= '0', '1' after 50 ns;
wait for 100 ns;

end process;

--------

p2: process is
begin

rclock <= '0', '1' after 50 ns;
wait for 100 ns;
end process;

------------

p3: process is 
begin 

rst <= '1';
wait for 100 ns;


----Select --> 00 ----
datai1 <= "11001000";datai2 <= "10010000";datai3 <= "01010100";datai4 <= "10001000";
rst <= '0';wr1 <= '1';wr2 <= '1';wr3 <= '1';wr4 <= '1';
wait for 100 ns;
-- assert datao1=datai1 report " diferrent data 1" severity error;
------------------



----Select --> 01 ----
datai1 <= "10100001";datai2 <= "01110001";datai3 <= "10100101";datai4 <= "11100001";
wait for 100 ns;

-- assert datao2=datai2 report " diferrent data 2" severity error;


----Select --> 10 ----
datai1 <= "10111010";datai2 <= "10110010";datai3 <= "10110110";datai4 <= "10100010";
wait for 100 ns;




----Select --> 11 ----
datai1 <= "10101111";datai2 <= "01100111";datai3 <= "01110011";datai4 <= "01100111";
wait for 100 ns;
-------------------
--wait for 1100 ns;
--rst <='1';
--wait for 100 ns;

wait;
end process;
end architecture; 