
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
entity  blockram is 
port ( 
	d_in : in std_logic_vector(7 downto 0); --input
	d_out : out std_logic_vector(7 downto 0); --output
	wea : in std_logic ; --enable write
	rea : in std_logic ; --enable read
	addra : in std_logic_vector(2 downto 0); --plsce to write
	addrb : in std_logic_vector(2 downto 0); --place to read
	clka : in std_logic ; --write clock
	clkb : in std_logic  --read clock
		);
end blockram;
Architecture ram of blockram is 
	type ram_type is ARRAY(0 to 7) of std_logic_vector(7 downto 0);
	signal my_memory :ram_type;
begin 
process (clka) is 
begin
	if(rising_edge(clka)) then 
		if(wea='1') then
			my_memory(conv_integer(addra)) <= d_in;
		end if;
	end if;
end process;
process (clkb) is 
begin
	if(rising_edge(clkb)) then 
                 
		if(rea='1') then
		d_out <= my_memory(conv_integer(addrb));
		
 		end if;
	end if;
end process;

end ram ;