library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
port ( clk,key: in std_logic;
key_pressed : out std_logic);
end debouncer;

architecture arch of debouncer is

signal last_key,cur_key,cur_key_slow:std_logic;
signal slow_clock:std_logic;
constant counter_width:integer:= 21;
signal counter:unsigned(counter_width-1 downto 0):=(others=>'0');

begin

slow_clock<=counter(counter_width-1);
counter<=counter+1 when rising_edge(clk);
cur_key<=key when rising_edge(slow_clock);
last_key<=cur_key when rising_edge(clk);

key_pressed<='1' when (last_key='0' and cur_key='1') else 
             '0';

end arch;
