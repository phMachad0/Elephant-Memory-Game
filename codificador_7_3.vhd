-------------------------------------------------------------------
-- Arquivo   : codificador_7_3.vhd
-- Projeto   : Elephant-Memory-Game
-------------------------------------------------------------------
-- Descricao : codificador de 4 bits para 2 bits
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Pedro Machado     criacao
-------------------------------------------------------------------

entity codificador_7_3 is
  port (
    A : in bit_vector (6 downto 0);
    Y : out bit_vector (2 downto 0)
    );
end entity codificador_7_3;

architecture arch_cod_7_3 of codificador_7_3 is
begin
  with A select
    Y <=
    "000" when "0000001",
    "001" when "0000010",
    "010" when "0000100",
    "011" when "0001000",
    "100" when "0010000",
    "101" when "0100000",    
    "111" when "1000000"; 
    "000" when others; 
end architecture arch_cod_7_3;
