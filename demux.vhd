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
library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity demux is
  port (
    SEL : in  std_logic;
    I   : in  std_logic;
    Y   : out std_logic;
    Z   : out std_logic
  );
end entity demux;

architecture arch_demux of demux is
begin
    Y <= I when SEL = '0' else '0';
    Z <= I when SEL = '1' else '0';
end architecture arch_demux;
