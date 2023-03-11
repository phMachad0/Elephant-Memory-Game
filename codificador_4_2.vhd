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

entity codificador_4_2 is
  port (
    A : in bit_vector (3 downto 0);
    Y : out bit_vector (1 downto 0)
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
