library IEEE;
use IEEE.std_logic_1164.all;

 



entity fifoController is 
	port(
	reset,rdclk,wrclk,r_req,w_req : in  std_logic;
	write_valid, read_valid, empty, full : out std_logic;
	wr_ptr, rd_ptr : out std_logic_vector(2 downto 0)
);
end entity ;





architecture behav of fifoController is 
component counter is

  PORT (Clock, Reset, En: IN std_logic;
        Count_output: OUT std_logic_vector (3 DOWNTO 0));

end component;



component Converter is 
port( gray_in: IN std_logic_vector(3 downto 0);
bin_out: out std_logic_vector (3 downto 0));
end component;




SIGNAL readConverter: STD_LOGIC_VECTOR(3 DOWNTO 0);--gray to binary read
SIGNAL writeConverter: STD_LOGIC_VECTOR(3 DOWNTO 0);--gray to binary write
SIGNAL rdBinaryout : STD_LOGIC_VECTOR(3 DOWNTO 0); 
SIGNAL wrBinaryout : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL readvalid, writevalid : STD_LOGIC;


begin
	rd_counter : counter
    PORT MAP(
        Clock => rdclk,
        En => readvalid,
        Reset => reset,
        Count_output => readConverter
    );
---------------------------------------------

wr_counter : counter
    	PORT MAP(
        Clock => wrclk,
        En => writevalid,
        Reset => reset,
        Count_output => writeConverter
    );


-------------------------------------------

   	read_Converter : Converter
    	PORT MAP(
        gray_in => readConverter,
        bin_out => rdBinaryout
    );

    	 
    	write_Coverter : Converter
    	PORT MAP(
        gray_in => writeConverter,
        bin_out => wrBinaryout
    );
---------------------------------------------
 p1: process(r_req,w_req,rdBinaryout,wrBinaryout,reset)
  variable tmp,tmp0,tmp1 : std_logic;  -- for full and empty checking

   begin 
        tmp0 := wrBinaryout(2) XNOR rdBinaryout(3);
        tmp1 := wrBinaryout(3) XOR rdBinaryout(2);   
        tmp  := tmp0 AND tmp1; -- check for full


        if(reset = '1') THEN  
            full <= '0';
            empty <= '1';
            readvalid <= '0';
            writevalid <= '1';

        else
            if(tmp='1') then --full
		full <='1';
		writevalid <='0'; -- no access to write
	    else
		full <='0'; 
 	        if(w_req='1') then -- access to write
		   writevalid <='1';

		else
		  writevalid <='0';
                end if;

            end if;

            if(wrBinaryout = rdBinaryout) then -- empty --modified
                empty <='1';
		readvalid <= '0';
            else
               empty <= '0';
               if(r_req = '1') then
  		 readvalid <= '1';
               else
                readvalid <= '0';
               end if;
            end if;
        end if;
end process p1;
-- update read and write
 read_valid <= readvalid;
 write_valid <= writevalid; 
-----------------------------
-- update ptrs
rd_ptr <= rdBinaryout(2 downto 0);
wr_ptr <= wrBinaryout(2 downto 0);

  
end  behav;	
