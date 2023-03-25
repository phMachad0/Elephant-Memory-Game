-------------------------------------------------------------------
-- Arquivo   : ram_32x4.vhd
-- Projeto   : Elephant-Memory-Game
-------------------------------------------------------------------
-- Descricao : módulo de memória RAM sincrona 32x4 
--             sinais we e ce ativos em baixo
--             codigo ADAPTADO do código encontrado no livro 
--             VHDL Descricao e Sintese de Circuitos Digitais
--             de Roberto D'Amore, LTC Editora.
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Pedro Machado     criacao
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_32x4_swap is
   port (       
       clk          : in  std_logic;
       reset        : in  std_logic;
       endereco1    : in  std_logic_vector(4 downto 0);
       endereco2    : in  std_logic_vector(4 downto 0);
       dado_entrada : in  std_logic_vector(3 downto 0);
       we           : in  std_logic;
       ce           : in  std_logic;
       troca        : in  std_logic;
       dado_saida   : out std_logic_vector(3 downto 0)
    );
end entity ram_32x4_swap;

-- Dados iniciais (para simulacao com Modelsim) 
architecture ram_modelsim of ram_32x4 is
  type   arranjo_memoria is array(0 to 31) of std_logic_vector(3 downto 0);
  signal memoria : arranjo_memoria := (
                                        "0001", -- posicao 0 (00000)
                                        "0010", -- posicao 1 (00001)
                                        "0011", -- posicao 2 (00010)
                                        "0100", -- posicao 3 (00011)
                                        "0101", -- posicao 4 (00100)
                                        "0110", -- posicao 5 (00101)
                                        "0111", -- posicao 6 (00110)
                                        "1111", -- posicao 7 (00111) (invalida)
                                        "1000", -- posicao 8 (01000)
                                        "1001", -- posicao 9 (01001)
                                        "1010", -- posicao 10 (01010)
                                        "1011", -- posicao 11 (01011)
                                        "1100", -- posicao 12 (01100)
                                        "1101", -- posicao 13 (01101)
                                        "1110", -- posicao 14 (01110)
                                        "1111", -- posicao 15 (01111) (invalida)
                                        "0001", -- posicao 16 (10000)
                                        "0010", -- posicao 17 (10001)
                                        "0011", -- posicao 18 (10010)
                                        "0100", -- posicao 19 (10011)
                                        "0101", -- posicao 20 (10100)
                                        "0110", -- posicao 21 (10101)
                                        "0111", -- posicao 22 (10110)
                                        "1111", -- posicao 23 (10111)(invalida)
                                        "1000", -- posicao 24 (11000)
                                        "1001", -- posicao 25 (11001)
                                        "1010", -- posicao 26 (11010)
                                        "1011", -- posicao 27 (11011)
                                        "1100", -- posicao 28 (11100)
                                        "1101", -- posicao 29 (11101)
                                        "1110", -- posicao 30 (11110)
                                        "1111");  -- posicao 31 (11111)(invalida)
                                        
  
begin

  process(clk, reset)
  begin
    if (reset='1) then
      memoria <= (
        "0001", -- posicao 0 (00000)
        "0010", -- posicao 1 (00001)
        "0011", -- posicao 2 (00010)
        "0100", -- posicao 3 (00011)
        "0101", -- posicao 4 (00100)
        "0110", -- posicao 5 (00101)
        "0111", -- posicao 6 (00110)
        "1111", -- posicao 7 (00111) (invalida)
        "1000", -- posicao 8 (01000)
        "1001", -- posicao 9 (01001)
        "1010", -- posicao 10 (01010)
        "1011", -- posicao 11 (01011)
        "1100", -- posicao 12 (01100)
        "1101", -- posicao 13 (01101)
        "1110", -- posicao 14 (01110)
        "1111", -- posicao 15 (01111) (invalida)
        "0001", -- posicao 16 (10000)
        "0010", -- posicao 17 (10001)
        "0011", -- posicao 18 (10010)
        "0100", -- posicao 19 (10011)
        "0101", -- posicao 20 (10100)
        "0110", -- posicao 21 (10101)
        "0111", -- posicao 22 (10110)
        "1111", -- posicao 23 (10111)(invalida)
        "1000", -- posicao 24 (11000)
        "1001", -- posicao 25 (11001)
        "1010", -- posicao 26 (11010)
        "1011", -- posicao 27 (11011)
        "1100", -- posicao 28 (11100)
        "1101", -- posicao 29 (11101)
        "1110", -- posicao 30 (11110)
        "1111");  -- posicao 31 (11111)(invalida)
    elsif (clk = '1' and clk'event) then
          if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"
           
              -- Detecta ativacao de we (ativo baixo)
              if (we = '0') then 
                if (troca='0') then
                  memoria(to_integer(unsigned(endereco1))) <= dado_troca2;
                  memoria(to_integer(unsigned(endereco2))) <= dado_troca1;
                else
                  memoria(to_integer(unsigned(endereco1))) <= dado_entrada;
                end if;
              end if;          
          end if;
      end if;
  end process;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco1)));

  dado_troca1 <= memoria(to_integer(unsigned(endereco1)));
  dado_troca2 <= memoria(to_integer(unsigned(endereco2)));

end architecture ram_modelsim;