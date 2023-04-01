library ieee;
use ieee.std_logic_1164.all;


entity random_generator_5bits is
    port(
        clock: in std_logic;
        enable: in std_logic;
        dado: out std_logic_vector(4 downto 0)
    );
end entity random_generator_5bits;

architecture LFSR of random_generator_5bits is
    signal dado28: std_logic_vector(27 downto 0) := "1010110101101011010110101101";
    signal dado28prox: std_logic_vector(27 downto 0);

begin
    process(clock)
    begin
        if (clock'event and clock='1' and enable='1') then
            dado28 <= dado28prox;
        end if;
    end process;

    GEN: for i in 3 to 27 generate
            dado28prox(i+1) <= dado28(i);
        end generate;

    dado28prox(3) <= dado28(27) xor dado28(2);

    dado28prox(2) <= dado28(1);
    dado28prox(1) <= dado28(0);
    dado28prox(0) <= dado28(27);

    dado <= dado28(4 downto 0);
end architecture;
