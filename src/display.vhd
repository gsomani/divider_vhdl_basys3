library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display is
port ( clk: in std_logic;
char0,char1,char2,char3: in std_logic_vector(7 downto 0);
cathode_pattern : out std_logic_vector(7 downto 0);
anode_pattern:out std_logic_vector(3 downto 0));
end display;

architecture arch of display is

signal output:std_logic_vector(11 downto 0);
signal char_select:std_logic_vector(1 downto 0);
constant counter_width:integer:= 20;
signal counter:unsigned(counter_width-1 downto 0):=(others=>'0');

begin

counter<=counter+1 when rising_edge(clk);

char_select <= std_logic_vector(counter(counter_width-1 downto counter_width-2));		    

with char_select select
     output <= "1110" & char0  when "00",
               "1101" & char1  when "01" ,
               "1011" & char2  when "10" ,
               "0111" & char3  when "11",
	       "1111" & "11111111" when others;        
                      
cathode_pattern<=output(7 downto 0);
anode_pattern<=output(11 downto 8);


end arch;
