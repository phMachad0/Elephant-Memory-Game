library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity banco_registradores is
    port(
        clock         : in std_logic;
        reset         : in std_logic;

        endereco1      : in std_logic_vector(4 downto 0);
        endereco2      : in std_logic_vector(4 downto 0);
        escolhe_endereco : in std_logic;
        escreve       : in std_logic;
        dado_saida    : out std_logic_vector(27 downto 0);

        pisca : in std_logic;
        frequencia: in std_logic
    );
end entity;

architecture arch_banco_reg of banco_registradores is
    signal ent_s  : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
    signal end1_s : integer range 0 to 32;
    signal end2_s : integer range 0 to 32;
    signal ent_pisca: std_logic_vector(31 downto 0);
    signal ent_show: std_logic_vector(31 downto 0);
begin
    process (clock)
    begin   
        end1_s <= to_integer(unsigned(endereco1));
        end2_s <= to_integer(unsigned(endereco2));

        if clock'event and clock='1' then
            if reset='0' and escolhe_endereco='1' and escreve='1' then 
                ent_s(end1_s) <= '1';
                ent_s(end2_s) <= '1';
            elsif reset='0' and escolhe_endereco='0' and escreve='1' then
                ent_s(end1_s) <= '1';
            elsif reset='1' then
                ent_s <= "00000000000000000000000000000000";
            end if;
        end if;
    end process;
    GEN: for i in 0 to 31 generate
        ent_show(i) <= frequencia when end1_s = i or (end2_s = i and escolhe_endereco = '1') else
                        ent_s(i);
    end generate;
    
    dado_saida <= (ent_show(6 downto 0) & ent_show(14 downto 8) & ent_show(22 downto 16) & ent_show(30 downto 24));
end architecture arch_banco_reg;
