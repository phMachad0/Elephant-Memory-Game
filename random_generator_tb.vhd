library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

-- entidade do testbench
entity random_generator_tb is
end entity;

architecture tb of random_generator_tb is
    component random_generator_5bits is
        port(
            clock: in std_logic;
            enable: in std_logic;
            dado: out std_logic_vector(4 downto 0)
        );
    end component;


    signal enable_in: std_logic;
    signal clk_in: std_logic := '0';
    signal dado_out: std_logic_vector(4 downto 0);

    -- Configurações do clock
  signal keep_simulating: std_logic := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod : time := 20 ns;     -- frequencia 50MHz
begin
    clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
    DUT: random_generator_5bits port map(
        clock => clk_in,
        enable => enable_in,
        dado => dado_out
    );

    stimulus: process is    
    begin
        assert false report "inicio da simulacao" severity note;
        keep_simulating <= '1';  -- inicia geracao do sinal de clock
        
        enable_in <= '1';
        wait for 500*clockPeriod;
        ---- final do testbench
        assert false report "fim da simulacao" severity note;
        keep_simulating <= '0';
        wait;
    end process;

end architecture;
     