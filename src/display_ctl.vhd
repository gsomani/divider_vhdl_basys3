library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity display_ctl is
port ( clk: in std_logic;
data: in std_logic_vector(15 downto 0);
cathode_pattern : out std_logic_vector(7 downto 0);
anode_pattern:out std_logic_vector(3 downto 0));
end display_ctl;

architecture arch of display_ctl is

signal char0,char1,char2,char3:std_logic_vector(7 downto 0);

component display is
port ( clk: in std_logic;
char0,char1,char2,char3: in std_logic_vector(7 downto 0);
cathode_pattern : out std_logic_vector(7 downto 0);
anode_pattern:out std_logic_vector(3 downto 0));
end component;

component hex_encoder_display is
port ( data_in: in std_logic_vector(3 downto 0);
display_out: out std_logic_vector(7 downto 0));
end component;

begin

to_char0:hex_encoder_display port map(data(3 downto 0),char0);
to_char1:hex_encoder_display port map(data(7 downto 4),char1);
to_char2:hex_encoder_display port map(data(11 downto 8),char2);
to_char3:hex_encoder_display port map(data(15 downto 12),char3);

display_seg:display port map(clk,char0,char1,char2,char3,cathode_pattern,anode_pattern);

end arch;
