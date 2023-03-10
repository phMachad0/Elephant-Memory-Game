--------------------------------------------------------------------
-- Arquivo   : unidade_controle.vhd
-- Projeto   : Experiencia 3 - Projeto de uma unidade de controle
--------------------------------------------------------------------
-- Descricao : unidade de controle 
--
--             1) codificação VHDL (maquina de Moore)
--
--             2) definicao de valores da saida de depuracao
--                db_estado
-- 
--------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     20/01/2022  1.0     Edson Midorikawa  versao inicial
--     22/01/2023  1.1     Edson Midorikawa  revisao
--------------------------------------------------------------------
--
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
		
        
        --saidas para zerar
        zeraP1 : out std_logic;
        zeraP2 : out std_logic;
        zeraRegs : out std_logic;

        --saidas de registro
        registra_display1 : out std_logic;
        registra_carta1 : out std_logic;
        registra_display2 : out std_logic;
        registra_carta2 : out std_logic;
        registra_pares : out std_logic;  --registra os pares na saida da memoria

        --saidas para manipulacao do fluxo de dados
        contaP1 : out std_logic;
        contaP2 : out std_logic;
        escreve : out std_logic;


        --Timeout
        time_out : in std_logic;
        zera_timeout	: out std_logic;
		
        --depuracao
		db_esgotou : out std_logic;
        db_estado : out std_logic_vector(3 downto 0)
    );
end entity;

architecture fsm of unidade_controle is
    type t_estado is (inicial, preparacao, ini_jogo, espera1, registra_display1, registra_carta1, verifica_conflito1
    espera2, registra_display2, registra_carta2, verifica_conflito2, verifica_cartas;
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

    -- logica de proximo estado
    Eprox <=
        inicial     when Eatual = inicial and iniciar='0' else
        preparacao  when (Eatual=inicial or Eatual=acerto or Eatual=erro or Eatual=esgotado) and iniciar='1' else
        ini_jogo  when Eatual = preparacao or Eatual = proxima_rodada else
        espera1 when Eatual = ini_jogo or (Eatual = espera1 and jogada_display='0' and jogada_carta='0') or Eatual = registra_display1 else
        registra_display1 when Eatual = espera1 and jogada_display='1' else
        registra_carta1 when Eatual = espera1 and jogada_carta='1' else
        verifica_cartas1 when Eatual = registra_cartas1 else
        espera2 when Eatual = registra_carta1 or (Eatual = espera2 and jogada_display='0' and jogada_carta='0') or Eatual=registra_display2 else
        registra_display2 when Eatual=espera2 and jogada_display='1' else
        registra_carta2 when Eatual=espera2 and jogada_carta='1' else
        verifica_cartas2 when Eatual=
        
    -- logica de saída (maquina de Moore)
    with Eatual select
        zeraCR <=      '1' when preparacao,
                      '0' when others;

    with Eatual select
        zeraE <=      '1' when preparacao | ini_rodada,
                      '0' when others;
    
    with Eatual select
        zeraR <=      '1' when inicial | preparacao,
                      '0' when others;
    
    with Eatual select
        registraR <=  '1' when registra,
                      '0' when others;

    with Eatual select
        contaE <=    '1' when proxima_jogada,
                      '0' when others;

    with Eatual select
        contaCR <=    '1' when proxima_rodada,
                      '0' when others;
    
    with Eatual select
        pronto <=     '1' when acerto | erro | esgotado,
                      '0' when others;

    with Eatual select
        acertou <=     '1' when acerto,
                       '0' when others;
    
    with Eatual select
        errou <=       '1' when erro | esgotado,
                       '0' when others;

    with Eatual select
        db_esgotou <=     '1' when esgotado,
                       '0' when others;
							  
    with Eatual select
        zeraT <=       '1' when ini_rodada | proxima_jogada,
                       '0' when others;

    -- saida de depuracao (db_estado)
    with Eatual select
        db_estado <= "0000" when inicial,     -- 0
                     "0001" when preparacao,  -- 1
                     "0010" when espera,      -- 2
                     "0011" when ini_rodada,   -- 3
                     "0100" when registra,    -- 4
                     "0101" when comparacao,  -- 5
                     "0110" when proxima_jogada,   -- 6
                     "0111" when ultima_jogada,     -- 7
                     "1000" when proxima_rodada,    -- 8
                     "1100" when acerto,      -- C
                     "1101" when erro,        -- D
					 "1110" when esgotado,     -- E
                     "1111" when others;      -- F

end architecture fsm;
