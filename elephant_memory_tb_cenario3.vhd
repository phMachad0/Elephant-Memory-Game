--------------------------------------------------------------------------
-- Arquivo   : elephant_memory_tb_cenario3.vhd
-- Projeto   : Elephant-Memory-Game
--------------------------------------------------------------------------
-- Descricao : modelo de testbench para simulação com ModelSim
--
--             implementa um Cenário de Teste do circuito
--             que acerta todas as 16 rodadas
--------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

-- entidade do testbench
entity elephant_memory_tb_cenario3 is
end entity;

architecture tb of elephant_memory_tb_cenario3 is

  -- Componente a ser testado (Device Under Test -- DUT)
  component elephant_memory
    port (
        clock: in std_logic;
        reset: in std_logic;
        iniciar: in std_logic;
        botoes_display: in std_logic_vector(3 downto 0);
        botoes_carta: in std_logic_vector(6 downto 0)

    );
  end component;
  ---- Declaracao de sinais de entrada para conectar o componente
  signal clk_in     : std_logic := '0';
  signal rst_in     : std_logic := '0';
  signal iniciar_in : std_logic := '0';
  signal botoes_display_in  : std_logic_vector(3 downto 0) := "0000";
  signal botoes_carta_in  : std_logic_vector(6 downto 0) := "0000000";
  signal caso     : natural;

  ---- Declaracao dos sinais de saida
  signal db_estado0_out     : std_logic_vector(6 downto 0) := "0000000";
  signal db_estado1_out     : std_logic_vector(6 downto 0) := "0000000";
  signal placar1_out     : std_logic_vector(6 downto 0) := "0000000";
  signal placar2_out     : std_logic_vector(6 downto 0) := "0000000";
  signal total_out     : std_logic_vector(6 downto 0) := "0000000";

  -- Configurações do clock
  signal keep_simulating: std_logic := '0'; -- delimita o tempo de geração do clock
  constant clockPeriod : time := 20 ns;     -- frequencia 50MHz
  
begin
  -- Gerador de clock: executa enquanto 'keep_simulating = 1', com o período especificado. 
  -- Quando keep_simulating=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (not clk_in) and keep_simulating after clockPeriod/2;
  
  ---- DUT para Simulacao
  dut: elephant_memory
       port map
       (
        clock => clk_in,
        reset => rst_in,
        iniciar => iniciar_in,
        botoes_display => botoes_display_in,
        botoes_carta => botoes_carta_in
       );
 
  ---- Gera sinais de estimulo para a simulacao
  -- Cenario de Teste : acerta as 3 primeiras rodadas e erra na 3ª jogada da 4ª rodada

  stimulus: process is
  begin

    -- inicio da simulacao
    assert false report "inicio da simulacao" severity note;
    keep_simulating <= '1';  -- inicia geracao do sinal de clock

    -- gera pulso de reset (1 periodo de clock)
    rst_in <= '1';
    wait for clockPeriod;
    rst_in <= '0';


    -- pulso do sinal de Iniciar (muda na borda de descida do clock)
    wait until falling_edge(clk_in);
    iniciar_in <= '1';
    wait until falling_edge(clk_in);
    iniciar_in <= '0';
    
    -- espera para inicio dos testes
    wait for 16*clockPeriod;
    wait until falling_edge(clk_in);

    -- Cenario de Teste

    caso <= 3;
    botoes_display_in <= "0001";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000001"; -- posicao 0 da mem
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 4;
    botoes_display_in <= "0100";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000001"; -- posicao 16 da mem
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";

    wait for 16*clockPeriod;
	 
    caso <= 5;
	  wait for 16*clockPeriod;
    botoes_display_in <= "0001";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000010";  -- posicao 1 da mem
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 6;
    botoes_display_in <= "0100";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000010"; -- posicao 17 da mem
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";

    wait for 16*clockPeriod;
    caso <= 7;
    botoes_display_in <= "0001"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000100"; -- posicao 2 da mem
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 8;
    botoes_display_in <= "0100";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000100"; -- posicao 18 da mem
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 9;
    botoes_display_in <= "0001"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0001000"; 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 10;
    botoes_display_in <= "0100";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0001000"; 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 11;
    botoes_display_in <= "0001"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0010000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 12;
    botoes_display_in <= "0100";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0010000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 13;
    botoes_display_in <= "0001"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0100000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 14;
    botoes_display_in <= "0100";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0100000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 15;
    botoes_display_in <= "0001"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "1000000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 16;
    botoes_display_in <= "0100";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "1000000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 17;
    botoes_display_in <= "0010"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000001";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 18;
    botoes_display_in <= "1000";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000001";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 19;
    botoes_display_in <= "0010"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000010";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 20;
    botoes_display_in <= "1000";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000010";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 21;
    botoes_display_in <= "0010"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000100";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 22;
    botoes_display_in <= "1000";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000100";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 23;
    botoes_display_in <= "0010"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0001000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 24;
    botoes_display_in <= "1000";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0001000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 25;
    botoes_display_in <= "0010"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0010000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 26;
    botoes_display_in <= "1000";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0010000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 27;
    botoes_display_in <= "0010"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0100000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 28;
    botoes_display_in <= "1000";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "0100000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    caso <= 29;
    botoes_display_in <= "0010"; 
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "1000000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
    wait for 16*clockPeriod;
    caso <= 30;
    botoes_display_in <= "1000";
    wait for 16*clockPeriod;
    botoes_display_in <= "0000";	 
    wait for 16*clockPeriod;
    botoes_carta_in <= "1000000";
    wait for 16*clockPeriod;
    botoes_carta_in <= "0000000";
	  wait for 16*clockPeriod;

    ---- final do testbench
    assert false report "fim da simulacao" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: processo aguarda indefinidamente
  end process;


end architecture;
