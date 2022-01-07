library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity operacional is
    Port (clk: in std_logic;
          x: in std_logic_vector(7 downto 0);
          clear_regX: in std_logic;
          load_regX: in std_logic;
          clear_registraX: in std_logic;
          load_registraX: in std_logic;
          clear_regx_subtracao: in std_logic;
          load_regx_subtracao: in std_logic;
          clear_regmult: in std_logic;
          load_regmult: in std_logic;          
          clear_desloc_soma: in std_logic;
          load_desloc_soma: in std_logic;
          clear_soma_x: in std_logic;
          load_soma_x: in std_logic;          
          media: in std_logic_vector(7 downto 0);
          variancia: OUT std_logic_vector(15 downto 0)                    
     );
end operacional;

architecture Behavioral of operacional is

type array1D is array (0 to 7) of std_logic_vector(7 downto 0);
type array1D2 is array (0 to 7) of std_logic_vector(15 downto 0);
signal sregX: array1D:=(others=>(others=>'0')); -- Array que contem os valores das entradas
signal regx: std_logic_vector(7 downto 0):=(others=>'0'); -- Registra o valor total das entradas
signal sregsub: array1D:=(others=>(others=>'0')); -- Registra o quadrado da diferença
signal val_desloc: std_logic_vector(15 downto 0):=(others=>'0'); -- Registra a média
signal soma_X: std_logic_vector(15 downto 0):=(others=>'0');
signal registraX: std_logic_vector(7 downto 0):=(others=>'0');
signal sregsub2: array1D2:=(others=>(others=>'0'));-- Registra o quadrado da diferença

begin
    desloac_X: process(clk,clear_registraX)
    begin
        if clear_registraX = '1' then
            sregX <= (others=>(others=>'0'));
        elsif rising_edge(clk) then
            if load_registraX = '1' then
               sregX(0) <= sregX(1);
               sregX(1) <= sregX(2);
               sregX(2) <= sregX(3);
               sregX(3) <= sregX(4);
               sregX(4) <= sregX(5);
               sregX(5) <= sregX(6);
               sregX(6) <= sregX(7);
               sregX(7) <= registrax;
            end if;
        end if;
    end process;
   
    registra_x: process(clk,clear_regX)
    begin
        if clear_regX = '1' then
            registraX <= (others=>'0'); 
        elsif rising_edge(clk) then
            if load_regX = '1' then
               registraX <= x;
            end if;
        end if;
    end process;
    
    -- processo para (xi - média) 
    
    sub_mult: process(clk, clear_regx_subtracao)
    begin
        if clear_regx_subtracao = '1' then
                sregsub <= (others=>(others=>'0'));
        elsif rising_edge(clk) then
            if load_regx_subtracao = '1' then
                sregsub(0) <= std_logic_vector(signed(sregX(0)) - signed(media));
                sregsub(1) <= std_logic_vector(signed(sregX(1)) - signed(media));
                sregsub(2) <= std_logic_vector(signed(sregX(2)) - signed(media));
                sregsub(3) <= std_logic_vector(signed(sregX(3)) - signed(media));
                sregsub(4) <= std_logic_vector(signed(sregX(4)) - signed(media));
                sregsub(5) <= std_logic_vector(signed(sregX(5)) - signed(media));
                sregsub(6) <= std_logic_vector(signed(sregX(6)) - signed(media));
                sregsub(7) <= std_logic_vector(signed(sregX(7)) - signed(media));
            end if;
        end if;
    end process;
    
    
    --processo para multiplicação (xi - média)*(xi - média) 
    mult: process(clk, clear_regmult)
    begin
        if clear_regmult = '1' then
            sregsub2 <= (others=>(others=>'0'));
        else
            if load_regmult = '1' then
                sregsub2(0) <= std_logic_vector(signed(sregsub(0))*signed(sregsub(0)));
                sregsub2(1) <= std_logic_vector(signed(sregsub(1))*signed(sregsub(1)));
                sregsub2(2) <= std_logic_vector(signed(sregsub(2))*signed(sregsub(2)));
                sregsub2(3) <= std_logic_vector(signed(sregsub(3))*signed(sregsub(3)));
                sregsub2(4) <= std_logic_vector(signed(sregsub(4))*signed(sregsub(4)));
                sregsub2(5) <= std_logic_vector(signed(sregsub(5))*signed(sregsub(5)));
                sregsub2(6) <= std_logic_vector(signed(sregsub(6))*signed(sregsub(6)));
                sregsub2(7) <= std_logic_vector(signed(sregsub(7))*signed(sregsub(7)));               
            end if;
       end if;     
    end process;
    
    -- processo para deslocar a soma
    
    desloca_soma: process(clk, clear_desloc_soma)
    begin
        if clear_desloc_soma = '1' then
            val_desloc <= (others=>'0');
        elsif rising_edge(clk) then
            if load_desloc_soma = '1' then
                val_desloc <= soma_x(15) & soma_x(15) & soma_x(15) & soma_x(15 downto 3);
            end if;
        end if;    
    end process;
    
    --processo para somar sub_mult
    
    process(clk, clear_soma_x)
    begin
        if clear_soma_x = '1' then
            soma_x <= (others=>'0');
        elsif rising_edge(clk) then
            if load_soma_x = '1' then
                soma_x <= std_logic_vector(signed(sregsub2(0))+ signed(sregsub2(1))+ signed(sregsub2(2))+ signed(sregsub2(3))+ signed(sregsub2(4))+ signed(sregsub2(5)) + signed(sregsub2(6)) + signed(sregsub2(7)));
            end if;    
        end if; 
    end process;

    variancia <= val_desloc;
end Behavioral;