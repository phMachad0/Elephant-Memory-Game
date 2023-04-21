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
use ieee.numeric_std.all;

entity mux_generic is
  generic(
    constant endereco_bits : integer := 4;
    constant dado_bits : integer := 4
  );

  port (
    SEL : in  std_logic_vector(endereco_bits - 1 downto 0);
    I : in std_logic_vector((2**endereco_bits)*dado_bits - 1 downto 0);
    Y   : out std_logic_vector (dado_bits-1 downto 0)
  );
end entity mux_generic;

architecture arch_mux of mux_generic is
begin
    Y <= I((dado_bits*(to_integer(unsigned(SEL))+1) - 1) downto to_integer(unsigned(SEL))*dado_bits);
end architecture arch_mux;
