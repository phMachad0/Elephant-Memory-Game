--------------------------------------------------------------------------
-- Arquivo   : elephant_memory_tb_cenario1.vhd
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
entity elephant_memory_tb_cenario1 is
end entity;

architecture tb of elephant_memory_tb_cenario1 is

  -- Componente a ser testado (Device Under Test -- DUT)
  component elephant_memory
    port (
        clock: in std_logic;
        reset: in std_logic;
        iniciar: in std_logic;
        botoes_display: in std_logic_vector(3 downto 0);
        botoes_carta: in std_logic_vector(6 downto 0);
        db_estado0: out std_logic_vector(6 downto 0);
        db_estado1: out std_logic_vector(6 downto 0);
        placar1: out std_logic_vector (6 downto 0);
        placar2: out std_logic_vector (6 downto 0);
        total: out std_logic_vector (6 downto 0)
    );
  end component;
  ---- Declaracao de sinais de entrada para conectar o componente
  signal clk_in     : std_logic := '0';
  signal rst_in     : std_logic := '0';
  signal iniciar_in : std_logic := '0';
  signal botoes_display_in  : std_logic_vector(3 downto 0) := "0000";
  signal botoes_carta_in  : std_logic_vector(6 downto 0) := "0000000";
  signal rodada     : natural;

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
        botoes_carta => botoes_carta_in,
        db_estado0 => db_estado0_out,
        db_estado1 => db_estado1_out,
        placar1 => placar1_out,
        placar2 => placar2_out,
        total => total_out
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
    wait for 8*clockPeriod;
    wait until falling_edge(clk_in);

    -- Cenario de Teste

    botoes_display_in <= "0001";
    wait for 8*clockPeriod;
    botoes_carta_in <= "0000001"; -- posicao 0 da mem
    wait for 8*clockPeriod;
    botoes_display_in <= "0100";
    wait for 8*clockPeriod;
    botoes_carta_in <= "0000001"; -- posicao 16 da mem

    wait for 8*clockPeriod;

    botoes_display_in <= "0001";
    wait for 8*clockPeriod;
    botoes_carta_in <= "0000001"; -- posicao 0 da mem
    wait for 8*clockPeriod;
    botoes_display_in <= "0001";
    wait for 8*clockPeriod;
    botoes_carta_in <= "0000010";  -- posicao 1 da mem
    wait for 8*clockPeriod;
    botoes_display_in <= "0100";
    wait for 8*clockPeriod;
    botoes_carta_in <= "0001000"; -- posicao 27 da mem

    wait for 8*clockPeriod;

    botoes_display_in <= "0001"; 
    wait for 8*clockPeriod;
    botoes_carta_in <= "0000010"; -- posicao 1 da mem
    wait for 8*clockPeriod;
    botoes_display_in <= "0100";
    wait for 8*clockPeriod;
    botoes_carta_in <= "0000010"; -- posicao 17 da mem


    ---- final do testbench
    assert false report "fim da simulacao" severity note;
    keep_simulating <= '0';
    
    wait; -- fim da simulação: processo aguarda indefinidamente
  end process;


end architecture;
