-------------------------------------------------------------------
-- Arquivo   : contador_bit.vhd
-- Projeto   : Elephant-Memory-Game
-------------------------------------------------------------------
-- Descricao : contador de 1 bit
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Pedro Machado     criacao
-------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity contador_bit is
    port (
        clock   : in  std_logic;
        zera_as : in  std_logic;
        zera_s  : in  std_logic;
        conta   : in  std_logic;
        Q       : out std_logic
    );
end entity contador_bit;

architecture comportamental of contador_bit is
    signal IQ : std_logic;
begin
  
    process (clock,zera_as,zera_s,conta,IQ)
    begin
        if zera_as='1' then    IQ <= '0';   
        elsif rising_edge(clock) then
            if zera_s='1' then IQ <= '0';
            elsif conta='1' then 
                if IQ='1' then IQ <= '0'; 
                else           IQ <= '1'; 
                end if;
            else               IQ <= IQ;
            end if;
        end if;
    end process;

    -- saida Q
    Q <= IQ;

end architecture comportamental;
