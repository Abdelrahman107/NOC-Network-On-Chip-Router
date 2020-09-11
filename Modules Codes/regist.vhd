library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity eight_reg is
    Port ( 
	    Data_in  : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           Clock : in  STD_LOGIC;
           Clock_En  : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Data_out    : out  STD_LOGIC_VECTOR (7 DOWNTO 0));

end eight_reg;
architecture Behavioral of eight_reg is
begin
     PROCESS(Clock,Reset)
       BEGIN
       IF(Reset='1') THEN
        Data_out <=(others =>'0');
       ELSIF(Clock'event AND Clock='1')THEN
          IF(Clock_En ='1') THEN
             Data_out <= Data_in;
          END IF;
       END IF;
     END PROCESS;
end Behavioral;


