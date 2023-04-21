library ieee;
use ieee.std_logic_1164.all;

entity circuito_display is
port(
    --Entradas basicas
    clock: in std_logic;
    reset: in std_logic;
    --Entradas especiais
    opcode: in std_logic_vector(3 downto 0);
    end_animal: in std_logic_vector(3 downto 0);
    jogador_vez: in std_logic;
    posicao_carta1: in std_logic_vector(4 downto 0);
    posicao_carta2: in std_logic_vector(4 downto 0);
    placar1: in std_logic_vector(3 downto 0);
    placar2: in std_logic_vector(3 downto 0);

    --Saidas
    display: out std_logic_vector(41 downto 0);
    fim_display: out std_logic
);

end entity circuito_display;

architecture display_beh of circuito_display is
    component fd_display is
        port(
            -- Sinais basicos
            clock: in std_logic;
            reset: in std_logic;

            --sinais de entrada provenientes de circuito_display
            placar1  : in std_logic_vector(3 downto 0);
            placar2  : in std_logic_vector(3 downto 0);
            end_animal: in std_logic_vector(3 downto 0);
            posicao1  : in std_logic_vector(4 downto 0);
            posicao2  : in std_logic_vector(4 downto 0);

            -- Sinais de entrada provenientes de UC_Display
            zera_timer_texto : in std_logic;
            escolha_mem : in std_logic_vector(2 downto 0);
            escolha_posicao: in std_logic;
            pisca: in std_logic;
            mux_sel_display: in std_logic;
            escreve_reg: in std_logic;
            reset_reg: in std_logic;    
            
            -- Sinais de saída para a UC_display
            fim_timer_texto  : out std_logic;
            meio_timer_texto : out std_logic;
            display    : out std_logic_vector(41 downto 0)
        );
    end component;

    component uc_display is
        port(
            opcode: in std_logic_vector(3 downto 0);
            jogador_vez: in std_logic;

            --Saidas para circuit_display
            fim_display: out std_logic;

            --Saida para FD_display
            zera_timer_texto : out std_logic;
            escolha_mem : out std_logic_vector(2 downto 0);
            escolha_posicao: out std_logic;
            pisca: out std_logic;
            mux_sel_display: out std_logic;
            escreve_reg: out std_logic;
            reset_reg: out std_logic;

            --Entradas provenientes de FD_display
            fim_timer_texto: in std_logic;
            meio_timer_texto: in std_logic
        );
    end component;

    signal zera_timer_texto, escolha_posicao, pisca, mux_sel_display, escreve_reg, reset_reg: std_logic;

    signal escolha_mem_sig : std_logic_vector(2 downto 0);

    signal fim_timer_texto, meio_timer_texto : std_logic;

begin
    FD: fd_display port map(
        clock => clock,
        reset => reset,
        placar1 => placar1,
        placar2 => placar2,
        end_animal => end_animal,
        posicao1 => posicao_carta1,
        posicao2 => posicao_carta2,
        zera_timer_texto => zera_timer_texto,
        escolha_mem => escolha_mem_sig,
        escolha_posicao => escolha_posicao,
        pisca => pisca,
        mux_sel_display => mux_sel_display,
        escreve_reg => escreve_reg,
        reset_reg => reset_reg,
        fim_timer_texto => fim_timer_texto,
        meio_timer_texto => meio_timer_texto,
        display => display
    );

    UC: uc_display port map(
        opcode => opcode,
        jogador_vez => jogador_vez,
        fim_display => fim_display,
        zera_timer_texto => zera_timer_texto,
        escolha_mem => escolha_mem_sig,
        escolha_posicao => escolha_posicao,
        pisca => pisca,
        mux_sel_display => mux_sel_display,
        escreve_reg => escreve_reg,
        reset_reg => reset_reg,
        fim_timer_texto => fim_timer_texto,
        meio_timer_texto => meio_timer_texto
    );
end architecture;

