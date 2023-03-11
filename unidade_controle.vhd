--------------------------------------------------------------------
-- Arquivo   : unidade_controle.vhd
-- Projeto   : Elephant Memory - Projeto de uma unidade de controle
--------------------------------------------------------------------
-- Descricao : unidade de controle 
--
--             1) codificação VHDL (maquina de Moore)
--
--             2) definicao de valores da saida de depuracao
--                db_estado
--------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity unidade_controle is
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
        reg_en_display1 : out std_logic;
        reg_en_carta1 : out std_logic;
        reg_en_jogada1 : out std_logic;
        reg_en_display2 : out std_logic;
        reg_en_carta2 : out std_logic;
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
end entity;

architecture fsm of unidade_controle is
    type t_estado is (inicial, preparacao, ini_jogo, espera1, registra_display1, registra_carta1, registra_jogada1, verifica_conflito1
    espera2, registra_display2, registra_carta2, registra_jogada2, verifica_conflito2, verifica_selecao, regisptra_par1, registra_par2,
    verifica_pares, escreve_mem1, escreve_mem2, proximo_jogador, finalizado, esgotado);
    
    signal Eatual, Eprox: t_estado;
begin

    -- memoria de estado
    process (clock,reset)
    begin
        if reset='1' then
            Eatual <= inicial;
        elsif clock'event and clock = '1' then
            Eatual <= Eprox; 
        end if;
    end process;


    ----------------------------------
    -- LOGICA DE PROXIMO ESTADO
    ----------------------------------
    
    Eprox <=
        inicial             when Eatual = inicial and iniciar='0' else
        preparacao          when (Eatual=inicial or Eatual=acerto or Eatual=erro or Eatual=esgotado) and iniciar='1' else
        ini_jogo            when Eatual = preparacao or Eatual = proxima_rodada else
        espera1             when Eatual = ini_jogo or (Eatual = espera1 and jogada_display='0' and jogada_carta='0' and time_out='0') or Eatual = registra_display1 or (Eatual= verifica_conflito1 and conflito_mem='1') else
        registra_display1   when Eatual = espera1 and jogada_display='1' else
        registra_carta1     when Eatual = espera1 and jogada_carta='1' else
        registra_jogada1    when Eatual = registra_carta1 else
        verifica_conflito1  when Eatual = registra_jogada1 else
        espera2             when (Eatual = verifica_conflito1 and conflito_mem='0') or (Eatual = espera2 and jogada_display='0' and jogada_carta='0' and time_out='0') or Eatual=registra_display2 or (Eatual=verifica_conflito2 and conflito_mem='1') or (Eatual=verifica_selecao and igual_selecao='1') else
        registra_display2   when Eatual=espera2 and jogada_display='1' else
        registra_carta2     when Eatual=espera2 and jogada_carta='1' else
        registra_jogada2    when Eatual = registra_carta2 else
        verifica_conflito2  when Eatual=registra_jogada2 else
        esgotado            when (Etaual = espera1 or Eatual=espera2) and time_out='1' else
        verifica_selecao    when (Eatual = verfica_conflito2 and conflito_mem='0') else
        registra_par1       when (Eatual=verifica_selecao and igual_selecao = '0') else
        registra_par2       when Eatual = registra_par1 else
        verifica_pares      when Eatual = registra_par2 else
        escreve_mem1        when Eatual = verifica_pares and par_correto='1' else
        escreve_mem2        when Eatual = escreve_mem1 else
        finalizado          when Eatual = escreve_mem2 and fim_jogo='1' else
        proximo_jogador     when (Eatual = verifica_pares and par_correto = '0') or (Eatual = escreve_mem2 and par_correto = '1') else
        espera1             when Eatual = proximo_jogador else
        proximo_jogador     when Eatual = timeout else
        preparacao          when Eatual = finalizado and iniciar = '1' else
        Eatual;
    


    ---------------------------------------
    -- LOGICA DE SAIDA (maquina de Moore)
    ---------------------------------------

    --saidas de manipulacao do fluxo de dados
    with Eatual select
        jogada_sel_mux <= '1' when verifica_conflito2 | registra_par2 | escreve_mem2,
                          '0' when others;
    with Eatual select
        escreve <=  '1' when escreve_mem1 | escreve_mem2,
                    '0' when others;
    with Eatual select
        conta_player <= '1' when escreve_mem1,
                        '0' when others;
    with Eatual select
        troca_jogador <= '1' when proximo_jogador,
                         '0' when others;

    --saidas de registro
    with Eatual select
        reg_en_display1 <= '1' when registra_display1,
                           '0' when others;
    with Eatual select
        reg_en_carta1 <= '1' when registra_carta1,
                         '0' when others;
    with Eatual select
        reg_en_jogada1 <= '1' when registra_jogada1,
                          '0' when others;
                   
    with Eatual select
        reg_en_display2 <= '1' when registra_display1,
                           '0' when others;
    with Eatual select
        reg_en_carta2 <= '1' when registra_carta1,
                         '0' when others;
    with Eatual select
        reg_en_jogada2 <= '1' when registra_jogada1,
                          '0' when others;

    --registra  os pares na saida da memoria
    with Eatual select
        reg_sen_chute1 <= '1' when registra_par1,
                          '0' when others;
    with Eatual select
        reg_sen_chute2 <= '1' when registra_par2,
                          '0' when others;
    


    --time out
    with Eatual select
        zera_timeout <= '1' when ini_rodada | proxima_jogada,
                        '0' when others;

    --Zera
    with Eatual select
        zera_regs <= '1' when preparacao,
                     '0' when others;
                          
    
    --depuracao
    with Eatual select
        db_esgotou <=  '1' when esgotado,
                       '0' when others;				  
    with Eatual select
        db_estado <= "0000_0000" when inicial,     -- 00
                     "0000_0001" when preparacao,  -- 01
                     "0000_0010" when ini_jogo     -- 02
                     
                     "0001_0000" when espera1,            -- 10
                     "0001_0001" when registra_display1   -- 11
                     "0001_0010" when registra_carta1     -- 12
                     "0001_0011" when registra_jogada1    -- 13
                     "0001_0011" when verifica_conflito1  -- 14

                     "0010_0000" when espera2,            -- 20
                     "0010_0001" when registra_display2   -- 21
                     "0010_0010" when registra_carta2     -- 22
                     "0010_0011" when registra_jogada2    -- 23
                     "0010_0011" when verifica_conflito2  -- 24
                     
                     "0100_0000" when verifica_selecao -- 40
                     "0100_0001" when registra_par1    -- 42
                     "0100_0010" when registra_par2    -- 43

                     "0111_0000" when verifica_pares  -- 70
                     "0111_0001" when escreve_mem1    -- 71
                     "0111_0010" when escreve_mem2    -- 72

                     "1010_1010" when proximo_jogador -- AA
                     "1110_1110" when esgotado -- EE
                     "1111_0001" when finalizado -- F1

                     "1111_1111" when others;          -- FF

end architecture fsm;
