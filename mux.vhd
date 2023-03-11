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

entity mux is
  port (
    SEL : in  bit;
    I   : in  bit_vector (4 downto 0);
    J   : in  bit_vector (4 downto 0);
    Y   : out bit_vector (4 downto 0)
  );
end entity mux;

architecture arch_mux of mux is
begin
  with SEL select
    Y <=
    I when '0',
    J when '1',
    "00000" when others;
end architecture arch_mux;
