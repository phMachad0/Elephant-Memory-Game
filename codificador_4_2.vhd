-------------------------------------------------------------------
-- Arquivo   : codificador_4_2.vhd
-- Projeto   : Elephant-Memory-Game
-------------------------------------------------------------------
-- Descricao : codificador de 4 bits para 2 bits
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Pedro Machado     criacao
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity codificador_4_2 is
  port (
    A : in std_logic_vector (3 downto 0);
    Y : out std_logic_vector (1 downto 0)
    );
end entity codificador_4_2;

architecture arch_cod_4_2 of codificador_4_2 is
begin
  with A select
    Y <=
    "00" when "0001",
    "01" when "0010",
    "10" when "0100",
    "11" when "1000",    
    "00" when others; 
end architecture arch_cod_4_2;
