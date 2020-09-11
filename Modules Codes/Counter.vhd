LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
	

ENTITY counter IS
  
  PORT (Clock, Reset, En: IN std_logic;
        Count_output: OUT std_logic_vector (3 DOWNTO 0));
END counter;

ARCHITECTURE GreyCounter_beh OF counter IS
  SIGNAL CurResetate,Nextstate, hold, next_hold: std_logic_vector (3 DOWNTO 0);
BEGIN

  StateReg: PROCESS (Clock)
  BEGIN
    IF (Clock = '1' AND Clock'EVENT) THEN
      IF (Reset = '1') THEN
        CurResetate <= (OTHERS =>'0');
      ELSIF (En = '1') THEN
        CurResetate <= Nextstate;
      END IF;
    END IF;
  END PROCESS;

  hold <= CurResetate XOR ('0' & hold(3 DOWNTO 1));
  next_hold <= std_logic_vector(unsigned(hold) + 1);
  Nextstate <= next_hold XOR ('0' & next_hold(3 DOWNTO 1)); 
  Count_output <= CurResetate;

END GreyCounter_beh;
