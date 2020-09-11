 library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.ALL;

entity router is 
	port(
		datai1,datai2,datai3,datai4 : in std_logic_vector(7 downto 0);
		datao1,datao2,datao3,datao4 :out std_logic_vector(7 downto 0);
		wr1,wr2,wr3,wr4,wclock,rclock,rst : in std_logic);
end entity;
architecture router_behav of router is 

component eight_reg is
	
   	Port ( 
	    Data_in  : in  STD_LOGIC_VECTOR (7 DOWNTO 0);
           Clock : in  STD_LOGIC;
           Clock_En  : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Data_out    : out  STD_LOGIC_VECTOR (7 DOWNTO 0));
end component;

component demux is 
	port(
         d_in : in std_logic_vector(7 downto 0);
         Sel : in std_logic_vector(1 downto 0);
         En: in std_logic;
         ------------------------------------------------
         d_out1 : out std_logic_vector(7 downto 0);
         d_out2 : out std_logic_vector(7 downto 0);
         d_out3 : out std_logic_vector(7 downto 0);
         d_out4 : out std_logic_vector(7 downto 0)
         ); 
end component;

component roundrobin is 
	
  port (
    din1 : in  std_logic_vector(7 downto 0);  
    din2 : in  std_logic_vector(7 downto 0);  
    din3 : in  std_logic_vector(7 downto 0);  
    din4 : in  std_logic_vector(7 downto 0);  
    dout : out  std_logic_vector(7 downto 0);  
    Clock :  in  std_logic);   
end component;

component fifo is 
port (
	reset,rclk,wclk,rreq,wreq : in std_logic;
	empty,full : out std_logic;
	datain :in std_logic_vector (7 downto 0);
	dataout : out std_logic_vector(7 downto 0)
		);
end component;

component counter is 

PORT(Clock, Reset, En: IN std_logic;
        Count_output: OUT std_logic_vector (3 DOWNTO 0));
end component;
---signals 
type arrayofvectors is array(0 to 3) of std_logic_vector (7 downto 0);  --2d array vector
type vectors2darray is array (0 to 3,0 to 3) of std_logic_vector(7 downto 0);  --2d array vector
type logic2darray is array(0 to 3,0 to 3) of std_logic; --2d array logic 
signal RegisterOut : arrayofvectors;
signal wr_arr : std_logic_vector (3 downto 0);   --array logic
signal demuxcarr : vectors2darray;
signal wreq : logic2darray;
signal rdreq : logic2darray;
signal datain : arrayofvectors;
signal fifoWriteReq : logic2darray;
signal dataout : vectors2darray;
signal empty : logic2darray;
signal full : logic2darray;


begin
--registermapping
--using direct mapping depending on port places 

InputBuffer1 : eight_reg 
port map(datai1,wclock,wr1,rst,RegisterOut(0));
InputBuffer2 : eight_reg 
port map(datai2,wclock,wr2,rst,RegisterOut(1));
InputBuffer3 : eight_reg
port map(datai3,wclock,wr3,rst,RegisterOut(2));
InputBuffer4 : eight_reg 
port map(datai4,wclock,wr4,rst,RegisterOut(3));

--Demuxes mapping 
--using direct mapping depending on port places 
demux1 :demux
port map(RegisterOut(0),(RegisterOut(0)(1 downto 0)),wr1,demuxcarr(0,0),demuxcarr(0,1),
demuxcarr(0,2),demuxcarr(0,3));
demux2 :demux
port map(RegisterOut(1),(RegisterOut(1)(1 downto 0)),wr2,demuxcarr(1,0),demuxcarr(1,1),
demuxcarr(1,2),demuxcarr(1,3));
demux3 :demux
port map(RegisterOut(2),(RegisterOut(2)(1 downto 0)),wr3,demuxcarr(2,0),demuxcarr(2,1),
demuxcarr(2,2),demuxcarr(2,3));
demux4 :demux
port map(RegisterOut(3),(RegisterOut(3)(1 downto 0)),wr4,demuxcarr(3,0),demuxcarr(3,1),
demuxcarr(3,2),demuxcarr(3,3));



write_process :process(rclock,wr1,wr2,wr3,wr4)
begin 
if (rising_edge(wclock))then
fifoWriteReq <=wreq;
end if;
end process;

datain <=(datai1,datai2,datai3,datai4);
wr_arr <=(wr1,wr2,wr3,wr4);

scheduler1 : roundrobin
Port map( dataout(0,0),dataout(0,1),dataout(0,2),dataout(0,3),datao1,rclock);
scheduler2 : roundrobin
Port map( dataout(1,0),dataout(1,1),dataout(1,2),dataout(1,3),datao2,rclock);
scheduler3 : roundrobin
Port map( dataout(2,0),dataout(2,1),dataout(2,2),dataout(2,3),datao3,rclock);
scheduler4 : roundrobin
Port map( dataout(3,0),dataout(3,1),dataout(3,2),dataout(3,3),datao4,rclock);




process (empty,full,wr_arr,datain,wclock,rclock,rst)
begin
for i in 0 to 3 loop
for j in 0 to 3 loop
IF empty(i,j)= '0' THEN
        rdreq(i,j) <= '1';
    ELSE 
        rdreq(i,j) <= '0';
    END IF;
    IF full(i,j)='0' AND wr_arr(j) = '1' AND (conv_integer(unsigned(datain(j)(1 DOWNTO 0))) = i) THEN
        wreq(i,j) <= '1';
        ELSE 
        wreq(i,j) <= '0';
    END IF;
end loop;
end loop;
end process;

       outer_GENERATE_FOR : FOR i IN 0 TO 3 GENERATE

          inner_GENERATE_FOR : FOR j IN 0 TO 3 GENERATE
		   routerfifo : fifo port map(rst,rclock,wclock,rdreq(i,j),fifoWriteReq(i,j),empty(i,j),
		    full(i,j),demuxcarr(j,i),dataout(i,j));

	  end generate;
	end generate;
end architecture;