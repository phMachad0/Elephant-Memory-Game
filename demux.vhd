-------------------------------------------------------------------
-- Arquivo   : demux.vhd
-- Projeto   : Elephant-Memory-Game
-------------------------------------------------------------------
-- Descricao : demux que seleciona uma das 
--             saídas para igualar a entrada de 1 bits
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Pedro Machado     criacao
-------------------------------------------------------------------

entity demux is
  port (
    SEL : in  bit;
    I   : in  bit;
    Y   : out bit;
    Z   : out bit
  );
end entity demux;

architecture arch_demux of demux is
begin
    Y <= I when SEL = '0' else '0';
    Z <= I when SEL = '1' else '0';
end architecture arch_demux;
