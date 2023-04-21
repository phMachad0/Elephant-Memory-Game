-------------------------------------------------------------------
-- Arquivo   : mux.vhd
-- Projeto   : Elephant-Memory-Game
-------------------------------------------------------------------
-- Descricao : mux que seleciona uma das entradas de 5 bits
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Pedro Machado     criacao
-------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity mux is
  generic(
    constant M : integer := 4 
  );
  port (
    SEL : in  std_logic;
    I   : in  std_logic_vector (M-1 downto 0);
    J   : in  std_logic_vector (M-1 downto 0);
    Y   : out std_logic_vector (M-1 downto 0)
  );
end entity mux;

architecture arch_mux of mux is
begin
  with SEL select
    Y <=
    I when '0',
    J when '1',
    (M-1 downto 0 => '0') when others;
end architecture arch_mux;
