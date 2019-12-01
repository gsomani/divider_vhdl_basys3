library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity div_tb is
end div_tb;

architecture arch of div_tb is

signal dividend,divisor:unsigned(7 downto 0);
signal quotient,remainder:std_logic_vector(7 downto 0);
signal clk,key,done:std_logic;

component div8 is 
port(clk,key:in std_logic;
dividend,divisor:in unsigned(7 downto 0);
quotient,remainder:out std_logic_vector(7 downto 0);
done:out std_logic
);
end component;

constant period:time:= 10 ns;

begin

div:div8 port map(clk,key,dividend,divisor,quotient,remainder,done);

process

begin

wait for 100 ns;

cloop: loop

clk <= '0';
wait for (period/2);
clk <= '1';
wait for (period/2);

end loop;

end process;

process

begin

wait for 100 ns;
key<='0';
wait for 10*period;
wait for period/2;
dividend <= "00001110";
divisor <= "00000011";
wait for 10*period;
key<='1';
wait for period;
key<='0';
wait for 12*period;

key<='1';
wait for period;
key<='0';
wait for 10*period;

dividend <= "00001010";
divisor <= "00000011";
wait for 10*period;
key<='1';
wait for period;
key<='0';
wait for 12*period;

key<='1';
wait for period;
key<='0';
wait for 10*period;

dividend <= "00001011";
divisor <= "00000101";
wait for 10*period;
key<='1';
wait for period;
key<='0';
wait for 12*period;

key<='1';
wait for period;
key<='0';

wait;

end process;


end arch;
