library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity timeout is
    port(
        clock: in std_logic;
        reset: in std_logic;
        time_out: out std_logic
    );
end timeout;

architecture beh of timeout is
    component contador_m is
        generic (
            constant M: integer := 100 -- modulo do contador
        );
        port (
            clock   : in  std_logic;
            zera_as : in  std_logic;
            zera_s  : in  std_logic;
            conta   : in  std_logic;
            Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
            fim     : out std_logic;
            meio    : out std_logic
        );
    end component;

begin
    counter: contador_m generic map (M => 10000) port map (
        clock => clock,
        zera_as => reset,
        zera_s => '0',
        conta => '1',
        fim => time_out
    );
end architecture;