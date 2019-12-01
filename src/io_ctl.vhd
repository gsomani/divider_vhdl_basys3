library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity io_ctl is
    Port ( clk,button:in std_logic;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           LED : out STD_LOGIC_VECTOR (15 downto 0);
           SSEG_CA : out STD_LOGIC_VECTOR (7 downto 0);
           SSEG_AN : out STD_LOGIC_VECTOR (3 downto 0));
end io_ctl;

architecture arch of io_ctl is

signal dividend,divisor:unsigned(7 downto 0);
signal quotient,remainder:std_logic_vector(7 downto 0);
signal key,done:std_logic;
signal data:std_logic_vector(15 downto 0);

component display_ctl is
port ( clk: in std_logic;
data: in std_logic_vector(15 downto 0);
cathode_pattern : out std_logic_vector(7 downto 0);
anode_pattern:out std_logic_vector(3 downto 0));
end component;

component div8 is 
port(clk,key:in std_logic;
dividend,divisor:in unsigned(7 downto 0);
quotient,remainder:out std_logic_vector(7 downto 0);
done:out std_logic);
end component;

component debouncer is
port ( clk,key: in std_logic;
key_pressed : out std_logic);
end component;

begin

LED <= SW;
dividend<=unsigned(SW(15 downto 8));
divisor<=unsigned(SW(7 downto 0));

data<= (quotient & remainder) when done='1' else std_logic_vector(dividend & divisor);

debounce:debouncer port map(clk,button,key);

div:div8 port map(clk,key,dividend,divisor,quotient,remainder,done);

display:display_ctl port map(clk,data,SSEG_CA,SSEG_AN);

end arch;
