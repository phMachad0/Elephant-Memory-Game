-------------------------------------------------------------------
-- Arquivo   : ram_16x4.vhd
-- Projeto   : Experiencia 2 - Um Fluxo de Dados Simples
-------------------------------------------------------------------
-- Descricao : módulo de memória RAM sincrona 16x4 
--             sinais we e ce ativos em baixo
--             codigo ADAPTADO do código encontrado no livro 
--             VHDL Descricao e Sintese de Circuitos Digitais
--             de Roberto D'Amore, LTC Editora.
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     08/01/2020  1.0     Edson Midorikawa  criacao
--     01/02/2020  2.0     Antonio V.S.Neto  Atualizacao para 
--                                           RAM sincrona para
--                                           minimizar problemas
--                                           com Quartus.
--     02/02/2020  2.1     Edson Midorikawa  revisao de codigo e
--                                           arquitetura para 
--                                           simulacao com ModelSim 
--     07/01/2023  2.1.1   Edson Midorikawa  revisao
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_32x42 is
   port (       
       clk          : in  std_logic;
       endereco     : in  std_logic_vector(4 downto 0);
       dado_entrada : in  std_logic_vector(41 downto 0);
       we           : in  std_logic;
       ce           : in  std_logic;
       dado_saida   : out std_logic_vector(41 downto 0)
    );
end entity ram_32x42;

-- Dados iniciais em arquivo MIF (para sintese com Intel Quartus Prime) 
architecture ram_mif of ram_32x42 is
  type   arranjo_memoria is array(0 to 31) of std_logic_vector(41 downto 0);
  signal memoria : arranjo_memoria;
  
  -- Configuracao do Arquivo MIF
  attribute ram_init_file: string;
  attribute ram_init_file of memoria: signal is "ram_conteudo_inicial.mif";
  
begin

  process(clk)
  begin
    if (clk = '1' and clk'event) then
          if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"
           
              -- Detecta ativacao de we (ativo baixo)
              if (we = '0') 
                  then memoria(to_integer(unsigned(endereco))) <= dado_entrada;
              end if;
            
          end if;
      end if;
  end process;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));
  
end architecture ram_mif;

-- Dados iniciais (para simulacao com Modelsim) 
architecture ram_modelsim of ram_32x42 is
  type   arranjo_memoria is array(0 to 31) of std_logic_vector(41 downto 0);
  signal memoria : arranjo_memoria := (
                                        "011110100001001010000111011111100011110111", -- girafa 01
                                        "110110111101111110011101110000000000000000", --sapo 02
                                        "000011011110011110111101110000000000000000", --leao 03
                                        "111100000001000111101101000011110010000000", --tigre 04
                                        "111000110111001011000111011100000000000000", --foca  05
                                        "011110111101111111000101110000000000000000", --gato  06
                                        "001110011101111011000111011100000000000000", --vaca  07
                                        "101110000111001111001000011011101001110111", --ovelha   08
                                        "101100011101111111100101000011101110000000", --cabra    09
                                        "111110010111001011110111100100000000000000", --bode     10
                                        "111100011101111111000001110000000000000000", --tatu     11
                                        "111001111110010000100111011011110010000000", --peixe    12
                                        "101110010101001011000111011100000000000000", --onca     13
                                        "000011010111001111100101110000000000000000", --lobo     14
                                        "000010010101000011100111011101101001011110", --invalid  15
                                        "000010010101000000100101100000001001011100", --inicio   16
                                        "011100111110011010000111100010111000000000", --acertou 
                                        "111100110100001010000111011110111101011100", --errou 
                                        "111001101100000111100001111010111001010100", --p1won 
                                        "111001110110110111100001111010111001010100", --p2won 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "000000000000000000000000000000000000000001", --nada 
                                        "011110000111101110111000010011110000000000" --nada 
                                        );
  
begin

  process(clk)
  begin
    if (clk = '1' and clk'event) then
          if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"
           
              -- Detecta ativacao de we (ativo baixo)
              if (we = '0') 
                  then memoria(to_integer(unsigned(endereco))) <= dado_entrada;
              end if;
            
          end if;
      end if;
  end process;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));

end architecture ram_modelsim;