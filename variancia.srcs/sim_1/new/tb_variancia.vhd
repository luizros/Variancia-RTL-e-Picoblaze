library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity tb_variancia is
--  Port ( );
end tb_variancia;

architecture Behavioral of tb_variancia is

component controle is
    Port ( clk: in std_logic;
           start: in std_logic; 
           reset: in std_logic;
           clear_regX: out std_logic;
           load_regX: out std_logic;
           clear_registraX: out std_logic;
           load_registraX: out std_logic;
           clear_regx_subtracao: out std_logic;
           load_regx_subtracao: out std_logic; 
           clear_regmult: out std_logic;
           load_regmult: out std_logic;            
           clear_desloc_soma: out std_logic;
           load_desloc_soma: out std_logic;
           clear_soma_x: out std_logic;
           load_soma_x: out std_logic;
           sready: in std_logic;  
           ready: out std_logic            
          );
end component;


component operacional is
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
end component;

signal sclear_regmult,sload_regmult,sclear_regX, sload_regX, sclear_registraX, sload_registraX, sclear_regx_subtracao, sload_regx_subtracao, sclear_desloc_soma, sload_desloc_soma, sclear_soma_x, sload_soma_x: std_logic;
signal sx, smedia: std_logic_vector(7 downto 0):="00000000";
signal fready, sclk,sstart, sreset,sready: std_logic:='0';
signal svariancia:  std_logic_vector(15 downto 0):="0000000000000000";

begin

bloco_operacional: operacional port map(
           clk => sclk,
           x => sx,
           clear_registraX => sclear_registraX,
           load_registraX => sload_registraX,
           clear_regX => sclear_regx,
           load_regX => sload_regx,
           clear_regx_subtracao => sclear_regx_subtracao,
           load_regx_subtracao => sload_regx_subtracao,
           clear_regmult => sclear_regmult,
           load_regmult => sload_regmult,   
           clear_desloc_soma => sclear_desloc_soma,
           load_desloc_soma => sload_desloc_soma,
           clear_soma_x => sclear_soma_x,
           load_soma_x => sload_soma_x,           
           media => smedia,
           variancia => svariancia
          );

bloco_de_controle: controle port map(
           clk => sclk,
           start => sstart,
           reset => sreset,
           clear_registraX => sclear_registrax,
           load_registraX => sload_registrax,
           clear_regX => sclear_regx,
           load_regX => sload_regx,
           clear_regx_subtracao => sclear_regx_subtracao,
           load_regx_subtracao => sload_regx_subtracao,
           clear_regmult => sclear_regmult,
           load_regmult => sload_regmult,
           clear_desloc_soma => sclear_desloc_soma,
           load_desloc_soma => sload_desloc_soma,
           clear_soma_x => sclear_soma_x,
           load_soma_x => sload_soma_x,           
           sready => sready,
           ready => fready            
          );

--estimulos

sclk <= not sclk after 5 ns;
smedia <= "00001101";
sx <= "00000000", "00000001" after 30 ns,  "00000010" after 60 ns, "00000100" after 90 ns, "00001000" after 120 ns, "00010000" after 150 ns, "00100000" after 180 ns, "00110000" after 210ns, "00000000" after 240ns;
sstart <= '0', '1' after 30 ns,'0' after 35 ns, '1' after 60 ns, '0' after 65 ns, '1' after 90 ns, '0' after 95 ns, '1' after 120ns, '0' after 125ns, '1' after 150ns, '0' after 155ns, '1' after 180ns, '0' after 185 ns, '1' after 210ns, '0' after 215ns, '1' after 240ns,'0' after 245ns;
sready <= '0', '1' after 255 ns, '0' after 265ns;

end Behavioral;
