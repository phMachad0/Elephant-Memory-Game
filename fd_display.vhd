library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity fd_display is
    port(
        -- Sinais basicos
        clock: in std_logic;
        reset: in std_logic;

        --sinais de entrada provenientes de circuito_display
        placar1  : in std_logic_vector(3 downto 0);
        placar2  : in std_logic_vector(3 downto 0);
        end_animal: in std_logic_vector(3 downto 0);
        posicao1  : in std_logic_vector(4 downto 0);
        posicao2  : in std_logic_vector(4 downto 0);

        -- Sinais de entrada provenientes de UC_Display
        zera_timer_texto : in std_logic;
        escolha_mem : in std_logic_vector(2 downto 0);
        escolha_posicao: in std_logic;
        pisca: in std_logic;
        mux_sel_display: in std_logic;
        escreve_reg: in std_logic;
        reset_reg: in std_logic;    
        
        -- Sinais de saída para a UC_display
        fim_timer_texto  : out std_logic;
        meio_timer_texto : out std_logic;
        display    : out std_logic_vector(41 downto 0)
    );
end entity;

architecture beh of FD_display is
    component mux_generic is
        generic(
          constant endereco_bits : integer := 4;
          constant dado_bits : integer := 4
        );
      
        port (
          SEL : in  std_logic_vector(endereco_bits - 1 downto 0);
          I : in std_logic_vector((2**endereco_bits)*dado_bits - 1 downto 0);
          Y   : out std_logic_vector (dado_bits-1 downto 0)
        );
      end component;

    component mux
        generic (
            constant M: integer := 4
        );
        port (
            SEL : in  std_logic;
            I   : in  std_logic_vector (M-1 downto 0);
            J   : in  std_logic_vector (M-1 downto 0);
            Y   : out std_logic_vector (M-1 downto 0)
        );
    end component;

    component ram_32x42 is
        port (
            clk          : in  std_logic;
            endereco     : in  std_logic_vector(4 downto 0);
            dado_entrada : in  std_logic_vector(41 downto 0);
            we           : in  std_logic;
            ce           : in  std_logic;
            dado_saida   : out std_logic_vector(41 downto 0)
        );
    end component;

    component contador_m is
        generic (
            constant M: integer := 100 -- modulo do contador
        );
        port (
            clock   : in  std_logic;
            zera_as : in  std_logic;
            zera_s  : in  std_logic;
            conta   : in  std_logic;
            Q       : out std_logic_vector(natural(ceil(log2(real(M))))-1 downto 0);
            fim     : out std_logic;
            meio    : out std_logic
        );
    end component;

    component hexa7seg is
        port (
            hexa : in  std_logic_vector(3 downto 0);
            sseg : out std_logic_vector(6 downto 0)
        );
    end component;

    component banco_registradores is
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
    end component;

    signal mux_output_endereco: std_logic_vector(4 downto 0);
    signal texto_sig: std_logic_vector(41 downto 0);

    signal posicao_sig: std_logic_vector(5 downto 0);
    signal idle_display: std_logic_vector(27 downto 0);
    signal placar_display: std_logic_vector(41 downto 0);
    signal placar1p, placar2p: std_logic_vector(6 downto 0);
    signal enderecos_memoria: std_logic_vector(39 downto 0);
    signal piscada: std_logic_vector(8 downto 0);

    signal placar1p_not, placar2p_not: std_logic_vector(6 downto 0);
begin
    text_memory: ram_32x42 port map(
        clk => clock,
        endereco => mux_output_endereco,
        dado_entrada => (41 downto 0 => '0'),
        we => '1',
        ce => '0',
        dado_saida => texto_sig
    );

    mux_display: mux generic map (M => 42)port map(
        SEL => mux_sel_display,
        I => placar_display,
        J => texto_sig,
        Y => display
    );
    placar_display <= idle_display & placar1p & placar2p;

    conta_tempo_texto: contador_m generic map(m => 4) port map(
        clock   => clock ,
        zera_as => reset,
        zera_s  => zera_timer_texto,
        conta   => '1',
        Q       => open,
        fim     => fim_timer_texto,
        meio    => meio_timer_texto
    );

    conta_frequencia_piscada: contador_m generic map(m => 400) port map(
        clock   => clock ,
        zera_as => reset,
        zera_s  => '1',
        conta   => '1',
        Q       => piscada
    );

    mux_mem_endereco: mux_generic
        generic map(
            endereco_bits => 3,
            dado_bits => 5)
        port map(
            SEL => escolha_mem,
            I  => enderecos_memoria,
            Y   => mux_output_endereco
        );
        enderecos_memoria <= "11111" & "10011" &"10010" & "10001" & "10000" & "01111" & "01110" & '0' & end_animal;

    BR: banco_registradores port map(
        clock  => clock,
        reset  => reset,

        endereco1 => posicao1,
        endereco2 => posicao2,
        escolhe_endereco => escolha_posicao,
        escreve  => escreve_reg,
        dado_saida => idle_display,

        pisca => pisca,
        frequencia => piscada(8)
    );

    HEX0: hexa7seg port map(
        hexa => placar1,
        sseg => placar1p_not
    );
    placar1p <= placar1p_not;

    HEX1: hexa7seg port map(
        hexa => placar2,
        sseg => placar2p_not
    );

    placar2p <= placar2p_not;
end architecture;