library ieee;
use ieee.std_logic_1164.all;

entity roundrobin is

  port (
    din1 : in  std_logic_vector(7 downto 0);  
    din2 : in  std_logic_vector(7 downto 0);  
    din3 : in  std_logic_vector(7 downto 0);  
    din4 : in  std_logic_vector(7 downto 0);  
    dout : out  std_logic_vector(7 downto 0);  
    Clock :  in  std_logic);                                      
    
end roundrobin;


architecture arch of roundrobin is

type state is (s1,s2,s3,s4);      
signal present_state,next_state : state;  
begin  

  cs: process (Clock)
   
  begin  

  if(rising_edge(Clock))THEN
      present_state <=next_state;
end if;
end process cs ;
 ns: process (present_state)  
begin
case present_state is

when s1 => 
 next_state <=s2; 
when s2 => 
 next_state <=s3; 
when s3 => 
 next_state <=s4; 
when s4 => 
 next_state <=s1; 

end case;
end process ns ;

op: process (present_state)
begin
case present_state is

when s1 => 
dout <= din1;

when s2 => 
dout <= din2;

when s3 => 
dout <= din3;

when s4=> 
dout <= din4;

end case;
end process op ;
end architecture arch;
