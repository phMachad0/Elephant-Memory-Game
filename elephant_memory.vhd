library ieee;
use ieee.std_logic_1164.all;

entity elephant_memory is
    port(
        clock: in std_logic;
        reset: in std_logic;
        iniciar: in std_logic;
        botoes_display: in std_logic_vector(3 downto 0);
        botoes_carta: in std_logic_vector(6 downto 0);
        display: out std_logic_vector (41 downto 0) 
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
            animal_mem 	                : out std_logic_vector (3 downto 0);
            jogador_vez	                : out std_logic;
            par_correto 	            : out std_logic;
            pontos_jogador1 	        : out std_logic_vector (3 downto 0);
            pontos_jogador2 	        : out std_logic_vector (3 downto 0);
            posicao_carta1 	            : out std_logic_vector (4 downto 0);
            posicao_carta2 	            : out std_logic_vector (4 downto 0);
            pontos_total                : out std_logic_vector (3 downto 0);

            --Entradas e saídas da geração aleatória:
            troca_posicao: in std_logic;
            endereco_random_sel: in std_logic;
            en_random_generator: in std_logic;
            registra_random: in std_logic;
            zera_time_prep: in std_logic;
            en_time_prep: in std_logic;

            pos_random_invalida: out std_logic;
            fim_time_prep:       out std_logic
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
        fim_display : in std_logic;  
		
        
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
        db_estado : out std_logic_vector(7 downto 0);

        opcode : out std_logic_vector(3 downto 0);

        --Entradas e saídas da geração aleatória:
        troca_posicao: out std_logic;
        endereco_random_sel: out std_logic;
        en_random_generator: out std_logic;
        registra_random: out std_logic;
        zera_time_prep: out std_logic;
        en_time_prep: out std_logic;

        pos_random_invalida: in std_logic;
        fim_time_prep:       in std_logic
        );
    end component;

    component circuito_display is
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
    signal jogadr_vez_sig: std_logic;
    signal db_estado_sig: std_logic_vector(7 downto 0);

    --Sinais exclusivos do FD
    signal pontos_jogador1_sig, pontos_jogador2_sig, pontos_total_sig : std_logic_vector(3 downto 0);

    signal posicao_carta1_sig, posicao_carta2_sig : std_logic_vector(4 downto 0);

    signal opcode_s, s_end_animal : std_logic_vector(3 downto 0);

    signal fim_display_sig : std_logic;
	 
	 signal botoes_display_not : std_logic_vector(3 downto 0);
	 signal botoes_cartas_not : std_logic_vector(6 downto 0);
	 signal display_not:  std_logic_vector (41 downto 0);


     --Sinais da geracao aleatoria
    signal troca_posicao_sig: std_logic;
    signal endereco_random_sel_sig: std_logic;
    signal en_random_generator_sig: std_logic;
    signal registra_random_sig: std_logic;
    signal zera_time_prep_sig: std_logic;
    signal en_time_prep_sig: std_logic;

    signal pos_random_invalida_sig: std_logic;
    signal fim_time_prep_sig:       std_logic;

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
        opcode => opcode_s,
        fim_display => fim_display_sig,
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
        db_estado => db_estado_sig,

        troca_posicao => troca_posicao_sig,
        endereco_random_sel => endereco_random_sel_sig,
        en_random_generator => en_random_generator_sig,
        registra_random => registra_random_sig,
        zera_time_prep => zera_time_prep_sig,
        en_time_prep => en_time_prep_sig,

        pos_random_invalida => pos_random_invalida_sig,
        fim_time_prep => fim_time_prep_sig
    );

    FD: fluxo_dados port map(
        clock => clock,	            
        escolha_display => botoes_display,
        escolha_carta => botoes_cartas_not,
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
        animal_mem => s_end_animal,
        jogador_vez => jogadr_vez_sig,
        par_correto => par_correto_sig,
        pontos_jogador1 => pontos_jogador1_sig,
        pontos_jogador2 => pontos_jogador2_sig,
        posicao_carta1 => posicao_carta1_sig,
        posicao_carta2 => posicao_carta2_sig,
        pontos_total => pontos_total_sig,

        troca_posicao => troca_posicao_sig,
        endereco_random_sel => endereco_random_sel_sig,
        en_random_generator => en_random_generator_sig,
        registra_random => registra_random_sig,
        zera_time_prep => zera_time_prep_sig,
        en_time_prep => en_time_prep_sig,

        pos_random_invalida => pos_random_invalida_sig,
        fim_time_prep => fim_time_prep_sig
    );
	 botoes_cartas_not <= not botoes_carta;

    CIRCUITO_DISPLAY_dut: circuito_display port map(
        clock =>clock ,
        reset => reset,
        opcode => opcode_s,
        end_animal => s_end_animal,
        jogador_vez => jogadr_vez_sig,
        posicao_carta1 => posicao_carta1_sig,
        posicao_carta2 => posicao_carta2_sig,
        placar1 => pontos_jogador1_sig,
        placar2 => pontos_jogador2_sig,
        display => display_not,
        fim_display => fim_display_sig
    );
	 display <= not display_not;
end architecture;
