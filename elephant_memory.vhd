library ieee;
use ieee.std_logic_1164.all;

entity elephant_memory is
    port(
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
end elephant_memory;

architecture elephant_memory_arch of elephant_memory is
    component fluxo_dados is
        port (
            clock 			            : in std_logic;
            escolha_display 	        : in std_logic_vector (3 downto 0);
            escolha_carta      	        : in std_logic_vector (6 downto 0);
            reg_en_display 	            : in std_logic;
            reg_en_carta 	            : in std_logic;
            reg_en_jogada1 	            : in std_logic;
            reg_en_jogada2 	            : in std_logic;
            jogada_seleciona_mux 	    : in std_logic;
            escreve 	                : in std_logic;
            reg_en_chute1 	            : in std_logic;
            reg_en_chute2 	            : in std_logic;
            troca_jogador 	            : in std_logic;
            conta_player 	            : in std_logic;
            zera_regs 	                : in std_logic;
            zera_timeout 	            : in std_logic;
            conflito_mem 	            : out std_logic;
            igual_selecao 	            : out std_logic;
            jogada_carta 	            : out std_logic;
            jogada_display 	            : out std_logic;
            fim_jogo 	                : out std_logic;
            time_out 	                : out std_logic;
            par_correto 	            : out std_logic;
            pontos_jogador1 	        : out std_logic_vector (3 downto 0);
            pontos_jogador2 	        : out std_logic_vector (3 downto 0);
            pontos_total                : out std_logic_vector (3 downto 0)
        );
    end component;

    component unidade_controle is
        port (
            --entradas basicas
        clock : in std_logic;
        reset : in std_logic;
        iniciar : in std_logic;


        --entradas de controle
        fim_jogo    : in std_logic;     --indica se todos as cartas foram "eliminadas"
        jogada_display : in std_logic;  --saida do edge decector correspondente ao clique de um botao de selecao de display
        jogada_carta : in std_logic;    --saida do edge decector correspondente ao clique de um botao de selecao de carta
        conflito_mem : in std_logic;    --indica se a carta selecionada ja foi "eliminada" previamente
        igual_selecao : in std_logic;   --indica se uma unica carta foi selecionada duas vezes
        par_correto : in std_logic;     --indica se as duas cartas registradas formam um par
		
        
        --saida para zerar
        zera_regs: out std_logic;


        --saidas de registro
        reg_en_display : out std_logic;
        reg_en_carta : out std_logic;
        reg_en_jogada1 : out std_logic;
        reg_en_jogada2 : out std_logic;
        --registra os pares na saida da memoria
        reg_en_chute1 : out std_logic;
        reg_en_chute2 : out std_logic;


        --saidas para manipulacao do fluxo de dados
        conta_player : out std_logic;
        escreve : out std_logic;
        jogada_sel_mux : out std_logic;
        troca_jogador : out std_logic;


        --Timeout
        time_out : in std_logic;
        zera_timeout	: out std_logic;

        
        --depuracao
		db_esgotou : out std_logic;
        db_estado : out std_logic_vector(7 downto 0)
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

    --Sinais correspondentes a UC
    signal fim_jogo_sig, jogada_display_sig, jogada_carta_sig, conflito_mem_sig, igual_selecao_sig, par_correto_sig : std_logic;
    signal zera_regs_sig : std_logic;
    signal reg_en_display_sig, reg_en_carta_sig, reg_en_jogada1_sig, reg_en_jogada2_sig, reg_en_chute1_sig, reg_en_chute2_sig: std_logic;
    signal conta_player_sig, escreve_sig, jogada_sel_mux_sig, troca_jogador_sig: std_logic;
    signal time_out_sig, zera_timeout_sig: std_logic;
    signal db_esgotou_sig: std_logic;
    signal db_estado_sig: std_logic_vector(7 downto 0);

    --Sinais exclusivos do FD
    signal pontos_jogador1_sig, pontos_jogador2_sig, pontos_total_sig : std_logic_vector(3 downto 0);
begin
    UC: unidade_controle port map(
        clock => clock,
        reset => reset,
        iniciar => iniciar,
        fim_jogo => fim_jogo_sig,
        jogada_display => jogada_display_sig,
        jogada_carta => jogada_carta_sig,
        conflito_mem => conflito_mem_sig,
        igual_selecao => igual_selecao_sig,
        par_correto => par_correto_sig,
        zera_regs => zera_regs_sig,
        reg_en_display => reg_en_display_sig,
        reg_en_carta => reg_en_carta_sig,
        reg_en_jogada1 => reg_en_jogada1_sig,
        reg_en_jogada2 => reg_en_jogada2_sig,
        reg_en_chute1 => reg_en_chute1_sig,
        reg_en_chute2 => reg_en_chute2_sig,
        conta_player => conta_player_sig,
        escreve => escreve_sig,
        jogada_sel_mux => jogada_sel_mux_sig,
        troca_jogador => troca_jogador_sig,
        time_out => time_out_sig,
        zera_timeout => zera_timeout_sig,
        db_esgotou => db_esgotou_sig,
        db_estado => db_estado_sig
    );

    FD: fluxo_dados port map(
        clock => clock,	            
        escolha_display => botoes_display,
        escolha_carta => botoes_carta,
        reg_en_display => reg_en_display_sig,
        reg_en_carta => reg_en_carta_sig,
        reg_en_jogada1 => reg_en_jogada1_sig,
        reg_en_jogada2 => reg_en_jogada2_sig,
        jogada_seleciona_mux => jogada_sel_mux_sig,
        escreve => escreve_sig,
        reg_en_chute1 => reg_en_chute1_sig,
        reg_en_chute2 => reg_en_chute2_sig,
        troca_jogador => troca_jogador_sig,
        conta_player => conta_player_sig,
        zera_regs => zera_regs_sig,
        zera_timeout => zera_timeout_sig,
        conflito_mem => conflito_mem_sig,
        igual_selecao => igual_selecao_sig,
        jogada_carta => jogada_carta_sig,
        jogada_display => jogada_display_sig,
        fim_jogo => fim_jogo_sig,
        time_out => time_out_sig,
        par_correto => par_correto_sig,
        pontos_jogador1 => pontos_jogador1_sig,
        pontos_jogador2 => pontos_jogador2_sig,
        pontos_total => pontos_total_sig
    );

    HEX0: hexa7seg port map(
        hexa => db_estado_sig(3 downto 0),
        sseg => db_estado0
    );

    HEX1: hexa7seg port map(
        hexa => db_estado_sig(7 downto 4),
        sseg => db_estado1
    );
    
    HEX2: hexa7seg port map(
        hexa => pontos_jogador1_sig,
        sseg => placar1
    );
    
    HEX3: hexa7seg port map(
        hexa => pontos_jogador2_sig,
        sseg => placar2
    );

    HEX4: hexa7seg port map(
        hexa => pontos_total_sig,
        sseg => total
    );
end architecture;
