-------------------------------------------------------------------
-- Arquivo   : ram_32x4.vhd
-- Projeto   : Elephant-Memory-Game
-------------------------------------------------------------------
-- Descricao : módulo de memória RAM sincrona 32x4 
--             sinais we e ce ativos em baixo
--             codigo ADAPTADO do código encontrado no livro 
--             VHDL Descricao e Sintese de Circuitos Digitais
--             de Roberto D'Amore, LTC Editora.
-------------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     11/03/2023  1.0     Pedro Machado     criacao
-------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ram_32x4 is
   port (       
       clk          : in  std_logic;
       endereco     : in  std_logic_vector(4 downto 0);
       dado_entrada : in  std_logic_vector(3 downto 0);
       we           : in  std_logic;
       ce           : in  std_logic;
       dado_saida   : out std_logic_vector(3 downto 0)
    );
end entity ram_32x4;

-- Dados iniciais em arquivo MIF (para sintese com Intel Quartus Prime) 
architecture ram_mif of ram_32x4 is
  type   arranjo_memoria is array(0 to 15) of std_logic_vector(3 downto 0);
  signal memoria : arranjo_memoria;
  
  -- Configuracao do Arquivo MIF
  attribute ram_init_file: string;
  attribute ram_init_file of memoria: signal is "ram_conteudo_inicial.mif";
  
begin

  process(clk)
  begin
    if (clk = '1' and clk'event) then
          if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"
           
              -- Detecta ativacao de we (ativo baixo)
              if (we = '0') 
                  then memoria(to_integer(unsigned(endereco))) <= dado_entrada;
              end if;
            
          end if;
      end if;
  end process;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));
  
end architecture ram_mif;

-- Dados iniciais (para simulacao com Modelsim) 
architecture ram_modelsim of ram_32x4 is
  type   arranjo_memoria is array(0 to 31) of std_logic_vector(3 downto 0);
  signal memoria : arranjo_memoria := (
                                        "0001",
                                        "0010",
                                        "0100",
                                        "1000",
                                        "0100",
                                        "0010",
                                        "0001",
                                        "0001",
                                        "0010",
                                        "0010",
                                        "0100",
                                        "0100",
                                        "1000",
                                        "1000",
                                        "0001",
                                        "0100",
                                        "0001",
                                        "0010",
                                        "0100",
                                        "1000",
                                        "0100",
                                        "0010",
                                        "0001",
                                        "0001",
                                        "0010",
                                        "0010",
                                        "0100",
                                        "0100",
                                        "1000",
                                        "1000",
                                        "0001",
                                        "0100" );
  
begin

  process(clk)
  begin
    if (clk = '1' and clk'event) then
          if ce = '0' then -- dado armazenado na subida de "we" com "ce=0"
           
              -- Detecta ativacao de we (ativo baixo)
              if (we = '0') 
                  then memoria(to_integer(unsigned(endereco))) <= dado_entrada;
              end if;
            
          end if;
      end if;
  end process;

  -- saida da memoria
  dado_saida <= memoria(to_integer(unsigned(endereco)));

end architecture ram_modelsim;