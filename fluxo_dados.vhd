library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity fluxo_dados is
    port (
        clock 			            : in std_logic;
        escolha_display 	        : in std_logic_vector (3 downto 0);
        escolha_carta      	        : in std_logic_vector (6 downto 0);
        reg_en_display 	            : in std_logic;
        reg_en_carta 	            : in std_logic;
        reg_en_jogada1 	            : in std_logic;
        reg_en_jogada2 	            : in std_logic;
        jogada_seleciona_mux 	    : in std_logic;
        escreve 	                : in std_logic;
        reg_en_chute1 	            : in std_logic;
        reg_en_chute2 	            : in std_logic;
        troca_jogador 	            : in std_logic;
        conta_player 	            : in std_logic;
        zera_regs 	                : in std_logic;
        zera_timeout 	            : in std_logic;
        conflito_mem 	            : out std_logic;
        igual_selecao 	            : out std_logic;
        jogada_carta 	            : out std_logic;
        jogada_display 	            : out std_logic;
        fim_jogo 	                : out std_logic;
        time_out 	                : out std_logic;
        par_correto 	            : out std_logic;
        pontos_jogador1 	        : out std_logic_vector (3 downto 0);
        pontos_jogador2 	        : out std_logic_vector (3 downto 0);
        pontos_total                : out std_logic_vector (3 downto 0)
    );
end entity fluxo_dados;

architecture estrutural of fluxo_dados is
    
    component demux
        port (
            SEL : in  std_logic;
            I   : in  std_logic;
            Y   : out std_logic;
            Z   : out std_logic
        );
    end component;

    component mux
        port (
            SEL : in  std_logic;
            I   : in  std_logic_vector (4 downto 0);
            J   : in  std_logic_vector (4 downto 0);
            Y   : out std_logic_vector (4 downto 0)
        );
    end component;

    component codificador_7_3
        port (
            A : in std_logic_vector (6 downto 0);
            Y : out std_logic_vector (2 downto 0)
        );
    end component;

    component codificador_4_2
        port (
            A : in std_logic_vector (3 downto 0);
            Y : out std_logic_vector (1 downto 0)
        );
    end component;

    component contador_bit
        port (
            clock   : in  std_logic;
            zera_as : in  std_logic;
            zera_s  : in  std_logic;
            conta   : in  std_logic;
            Q       : out std_logic
        );
    end component;

    component comparador_4bits
        port (
            i_A3   : in  std_logic;
            i_B3   : in  std_logic;
            i_A2   : in  std_logic;
            i_B2   : in  std_logic;
            i_A1   : in  std_logic;
            i_B1   : in  std_logic;
            i_A0   : in  std_logic;
            i_B0   : in  std_logic;
            i_AGTB : in  std_logic;
            i_ALTB : in  std_logic;
            i_AEQB : in  std_logic;
            o_AGTB : out std_logic;
            o_ALTB : out std_logic;
            o_AEQB : out std_logic
        );
    end component;

    component comparador_5bits
        port (
            i_A4   : in  std_logic;
            i_B4   : in  std_logic;
            i_A3   : in  std_logic;
            i_B3   : in  std_logic;
            i_A2   : in  std_logic;
            i_B2   : in  std_logic;
            i_A1   : in  std_logic;
            i_B1   : in  std_logic;
            i_A0   : in  std_logic;
            i_B0   : in  std_logic;
            i_AGTB : in  std_logic;
            i_ALTB : in  std_logic;
            i_AEQB : in  std_logic;
            o_AGTB : out std_logic;
            o_ALTB : out std_logic;
            o_AEQB : out std_logic
        );
    end component;

    component ram_32x4 is
        port (
            clk          : in  std_logic;
            endereco     : in  std_logic_vector(4 downto 0);
            dado_entrada : in  std_logic_vector(3 downto 0);
            we           : in  std_logic;
            ce           : in  std_logic;
            dado_saida   : out std_logic_vector(3 downto 0)
        );
    end component;

    component registrador_n is
        generic (
            constant N: integer := 8 
        );
        port (
            clock  : in  std_logic;
            clear  : in  std_logic;
            enable : in  std_logic;
            D      : in  std_logic_vector (N-1 downto 0);
            Q      : out std_logic_vector (N-1 downto 0) 
        );
    end component;

    component edge_detector is
        port (
            clock  : in  std_logic;
            reset  : in  std_logic;
            sinal  : in  std_logic;
            pulso  : out std_logic
        );
    end component;

    component timeout is
        port(
            clock: in std_logic;
            reset: in std_logic;
            time_out: out std_logic
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

    signal s_escolha_display_codififcado    : std_logic_vector (1 downto 0);
    signal s_escolha_carta_codififcado      : std_logic_vector (2 downto 0);
    signal s_posicao_escolhida              : std_logic_vector (4 downto 0);
    signal s_escolha1                       : std_logic_vector (4 downto 0);
    signal s_escolha2                       : std_logic_vector (4 downto 0);
    signal s_endereco                       : std_logic_vector (4 downto 0);
    signal s_invalid                        : std_logic_vector (3 downto 0) := "1111";
    signal s_not_escreve                    : std_logic;
    signal s_seleciona_jogador              : std_logic;
    signal s_conta_ponto_jogador1           : std_logic;
    signal s_conta_ponto_jogador2           : std_logic;
    signal s_animal_mem                     : std_logic_vector (3 downto 0);
    signal s_animal_chute1                  : std_logic_vector (3 downto 0);
    signal s_animal_chute2                  : std_logic_vector (3 downto 0);
    signal s_sinal_display                  : std_logic;
    signal s_sinal_carta                    : std_logic;

    
begin

    -- sinais de controle ativos em alto
    -- sinais dos componentes ativos em baixo
    s_not_escreve <= not escreve;  
    s_sinal_display <= escolha_display(0) or escolha_display(1) or escolha_display(2) or escolha_display(3); 
    s_sinal_carta <= escolha_carta(0) or escolha_carta(1) or escolha_carta(2) or escolha_carta(3) or escolha_carta(4) or escolha_carta(5) or escolha_carta(6);

    r1: registrador_n
        generic map (
            N => 2
        )
        port map(
            clock => clock,
            clear => zera_regs, 
            enable => reg_en_display,
            D => s_escolha_display_codififcado,
            Q(1) => s_posicao_escolhida(4),
            Q(0) => s_posicao_escolhida(3)
        );

    r2: registrador_n
        generic map (
            N => 3
        )
        port map(
            clock => clock,
            clear => zera_regs, 
            enable => reg_en_carta,
            D => s_escolha_carta_codififcado,
            Q(2) => s_posicao_escolhida(2),
            Q(1) => s_posicao_escolhida(1),
            Q(0) => s_posicao_escolhida(0)
        );

    r3: registrador_n
        generic map (
            N => 5
        )
        port map(
            clock => clock,
            clear => zera_regs, 
            enable => reg_en_jogada1,
            D => s_posicao_escolhida,
            Q => s_escolha1 
        );

    r4: registrador_n
        generic map (
            N => 5
        )
        port map(
            clock => clock,
            clear => zera_regs, 
            enable => reg_en_jogada2,
            D => s_posicao_escolhida,
            Q => s_escolha2
        );

    cod4to2: codificador_4_2
        port map(
            A => escolha_display,
            Y => s_escolha_display_codififcado
        );

    cod7to3: codificador_7_3
        port map(
            A => escolha_carta,
            Y => s_escolha_carta_codififcado
        );
    
    comparador_jogadas: comparador_5bits
        port map(
            i_A4   => s_escolha1(4),
            i_B4   => s_escolha2(4),
            i_A3   => s_escolha1(3),
            i_B3   => s_escolha2(3),
            i_A2   => s_escolha1(2),
            i_B2   => s_escolha2(2),
            i_A1   => s_escolha1(1),
            i_B1   => s_escolha2(1),
            i_A0   => s_escolha1(0),
            i_B0   => s_escolha2(0),
            i_AGTB => '0',
            i_ALTB => '0',
            i_AEQB => '1',
            o_AGTB => open, -- saidas nao usadas
            o_ALTB => open,
            o_AEQB => igual_selecao
        );

    mux_dut: mux
        port map(
            SEL => jogada_seleciona_mux,
            I   => s_escolha1,
            J   => s_escolha2,
            Y   => s_endereco
        );

    --memoria: entity work.ram_32x4 (ram_mif)  -- usar esta linha para Intel Quartus
    memoria: entity work.ram_32x4 (ram_modelsim) -- usar arquitetura para ModelSim
        port map (
            clk          => clock,
            endereco     => s_endereco,
            dado_entrada => s_invalid,
            we           => s_not_escreve,-- we ativo em baixo
            ce           => '0',
            dado_saida   => s_animal_mem
        );

    comparador_invalid: comparador_4bits
        port map(
            i_A3   => s_invalid(3),
            i_B3   => s_animal_mem(3),
            i_A2   => s_invalid(2),
            i_B2   => s_animal_mem(2),
            i_A1   => s_invalid(1),
            i_B1   => s_animal_mem(1),
            i_A0   => s_invalid(0),
            i_B0   => s_animal_mem(0),
            i_AGTB => '0',
            i_ALTB => '0',
            i_AEQB => '1',
            o_AGTB => open, -- saidas nao usadas
            o_ALTB => open,
            o_AEQB => conflito_mem
        );

    r5: registrador_n
        generic map (
            N => 4
        )
        port map(
            clock => clock,
            clear => zera_regs, 
            enable => reg_en_chute1,
            D => s_animal_mem,
            Q => s_animal_chute1
        );  

    r6: registrador_n
        generic map (
            N => 4
        )
        port map(
            clock => clock,
            clear => zera_regs, 
            enable => reg_en_chute2,
            D => s_animal_mem,
            Q => s_animal_chute2
        );   

    comparador_chutes: comparador_4bits
        port map(
            i_A3   => s_animal_chute1(3),
            i_B3   => s_animal_chute2(3),
            i_A2   => s_animal_chute1(2),
            i_B2   => s_animal_chute2(2),
            i_A1   => s_animal_chute1(1),
            i_B1   => s_animal_chute2(1),
            i_A0   => s_animal_chute1(0),
            i_B0   => s_animal_chute2(0),
            i_AGTB => '0',
            i_ALTB => '0',
            i_AEQB => '1',
            o_AGTB => open, -- saidas nao usadas
            o_ALTB => open,
            o_AEQB => par_correto
        );

    contador_troca_jogador: contador_bit 
        port map (
            clock => clock,
            zera_as => zera_regs,
            zera_s => '0',
            conta => troca_jogador,
            Q => s_seleciona_jogador
        );  

    demux_dut: demux
        port map(
            SEL => s_seleciona_jogador,
            I   => conta_player,
            Y   => s_conta_ponto_jogador1,
            Z   => s_conta_ponto_jogador2
        ); 

    contador_pontos_jogador1: contador_m 
        generic map (M => 15) 
        port map (
            clock => clock,
            zera_as => zera_regs,
            zera_s => '0',
            conta => s_conta_ponto_jogador1,
            Q => pontos_jogador1
        ); 

    contador_pontos_jogador2: contador_m 
        generic map (M => 15) 
        port map (
            clock => clock,
            zera_as => zera_regs,
            zera_s => '0',
            conta => s_conta_ponto_jogador2,
            Q => pontos_jogador2
        ); 

    contador_pares_encontrados: contador_m 
        generic map (M => 15) 
        port map (
            clock => clock,
            zera_as => zera_regs,
            zera_s => '0',
            conta => conta_player,
            fim => fim_jogo,
            Q => pontos_total
        );

    timeout_counter: timeout port map(
        clock => clock,
        reset => zera_timeout,
        time_out => time_out
    ); 

    detector_display: edge_detector
        port map (
			  clock => clock,
			  reset => zera_regs,
			  sinal => s_sinal_display,
			  pulso => jogada_display
        );

    detector_carta: edge_detector
        port map (
			  clock => clock,
			  reset => zera_regs,
			  sinal => s_sinal_carta,
			  pulso => jogada_carta
        );
end architecture estrutural;
