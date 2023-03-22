library ieee;
use ieee.std_logic_1164.all;

entity uc_display is
    --Entradas provenientes do circuito_display
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

end uc_display;

architecture uc_display_beh of uc_display is

begin
    with opcode select
        zera_timer_texto <= '0' when "0001" | "0100" | "0101" | "0110" | "0111" | "1011" | "1111",
                            '1' when others;

    
    escolha_mem <= "000" when opcode="0101" else
                    "001" when opcode="0100" else
                    "010" when opcode="0001" else
                    "011" when opcode="0110" else
                    "100" when opcode="0111" else
                    "101" when opcode="1111" and jogador_vez='0' else
                    "110" when opcode="1111" and jogador_vez='1' else
                    "111";
                
    with opcode select
        mux_sel_display <= '1' when "0001" | "0101" | "0100" | "0110" | "0111" | "1111",
                           '0' when others; 

    with opcode select
        escolha_posicao <= '1' when "1000" | "1011", 
                           '0' when others;

    with opcode select
        pisca <= '1' when "1010" | "1011", 
                 '0' when others;

    with opcode select
        fim_display <= fim_timer_texto when "0001" | "0100" | "0101" | "0110" | "0111" | "1011" | "1111",
                                    '0' when others;

    with opcode select
        escreve_reg <= '1' when "1000", '0' when others;

    with opcode select
        reset_reg <= '1' when "0010", '0' when others;

end architecture;

--Opcodes:
-- 0 padrao
-- 1 start
-- 2 preparacao
-- 3 (nada)
-- 4 carta invalida
-- 5 animal1/animal2
-- 6 certo
-- 7 errado
-- 8 registra1
-- 9 (nada)
-- A espera2_display
-- B cartas_sel_display
-- C (nada)
-- D (nada)
-- E (nada)
-- F finalizado/esgotado
