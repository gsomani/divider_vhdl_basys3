library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity div8 is 
port(clk,key:in std_logic;
dividend,divisor:in unsigned(7 downto 0);
quotient,remainder:out std_logic_vector(7 downto 0));
end div8;

architecture arch_div8 of div8 is 

type statetype is (s0, s1, s2, s3); 
signal pr_state, nx_state: statetype;

signal rst,load,shift,max,done: std_logic; 
signal diff:signed(8 downto 0); 
signal divisor_r,r_update: unsigned(7 downto 0);
signal count: unsigned(2 downto 0) ;
signal r: unsigned(15 downto 0);

begin

quotient <= std_logic_vector(r(7 downto 0)) when done='1' else (others=>'U');
remainder <= std_logic_vector(r(15 downto 8)) when done='1' else (others=>'U');

fsm: process (pr_state, key, max) 
begin 
case pr_state is 
when s0 => 
	rst <= '1'; load <= '0'; shift <= '0'; done <= '0'; 
	if (key = '1') then nx_state <= s1; 
	else nx_state <= s0; 
	end if;

when s1 => 
	rst <= '1'; load <= '1'; shift <= '0'; done <= '0'; 
	nx_state <= s2; 

when s2 => 
	rst <= '0'; load <= '0'; shift <= '1'; done <= '0'; 
	if (max = '1') then nx_state <= s3; 
	else nx_state <= s2; 
	end if;

when s3 => 
	rst <= '0'; load <= '0'; shift <= '0'; done <= '1'; 
	if (key = '1') then nx_state <= s0; 
	else nx_state <= s3; 
	end if;
end case;
end process fsm;


divreg: process (rst, clk)
begin
if (rst = '1') then
	r <= (others => '0'); 
elsif (rising_edge(clk)) then
	if (load = '1') then
		r <= "00000000" & dividend; 
	elsif (shift = '1') then
		r <= r_update & r(6 downto 0) & '0';
	end if; 
end if;
end process divreg;


-- Counter
counter: process (clk, rst) 
begin
if (rst = '1') then
	count <= (others => '0');
elsif (rising_edge(clk)) then 
	if (shift = '1') then
		count <= count + 1; 
	end if;
end if;
end process;

-- Max decoder 
max <= '1' when (count = 7) else '0';

-- Subtracter 
diff <= signed( ('0' & r(14 downto 7)) - ('0' & divisor_r) ) ;
r_update<= unsigned(diff(7 downto 0)) when diff(8) = '0' else r(14 downto 7);

divisor_reg: process (clk, rst) 
begin
if (rising_edge(clk)) then 
	if (load = '1') then
		divisor_r <= divisor; 
	end if;
end if;
end process divisor_reg;

fsmff: process (rst, clk) 
begin 
	if (rst = '1') then pr_state <= s0; 
	elsif (rising_edge(clk)) then pr_state <= nx_state; end if; 
end process; 

end arch_div8;

