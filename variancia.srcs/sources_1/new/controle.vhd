
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity controle is
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
end controle;

architecture Behavioral of controle is

type tipo_estado is (e0, e1, e2, e3, e4, e5, e6, e7, e8);
signal estado_atual, proximo_estado: tipo_estado:= e0; 
signal sstart: std_logic:='0';


begin

    -- processo sequencial para registrar estados
    process(clk, reset)
    begin
        if reset = '1' then
            estado_atual <= e0;
        elsif rising_edge(clk) then
            estado_atual <= proximo_estado;
        end if;
    end process;
    
    -- processo combinacional para transição de estados
 
    process(estado_atual, start, sready)
    begin
        case estado_atual is
            when e0 => -- inicialização, zera  todos os registrados
                proximo_estado <= e1;
            when e1 => -- registra os valores de x                 
                if start = '1'then
                    proximo_estado <= e2;
                else
                    proximo_estado <= e1;
                end if;
            when e2 => -- shift resgister de  x
                proximo_estado <= e3;
            when e3 => 
                if start ='1' and sready = '1' then
                    proximo_estado <= e4;
                elsif start = '1' and sready = '0' then
                    proximo_estado <= e3;
                elsif start = '0' and sready = '1' then
                    proximo_estado <= e4; 
                elsif start = '0' and sready = '0' then
                    proximo_estado <= e1; 
                end if;         
            when e4 => -- registra a subtração
                proximo_estado <= e5;
            when e5 => -- registra a multiplicação
                proximo_estado <= e6;                
            when e6 => -- registra a soma dos produtos
                proximo_estado <= e7;
            when e7 => -- desloca a soma dos produtos
                proximo_estado <= e8;
            when e8 => -- aciona o ready
                if start = '1' then
                    proximo_estado <= e8;
                else
                    proximo_estado <= e1;
                end if;            
            when others =>
                proximo_estado <= e0;                
        end case;
    end process;    

    process(estado_atual)
    begin
        case estado_atual is
            when e0 => 
               clear_regX             <= '1';
               load_regX              <= '0';
               clear_registraX        <= '1';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '1';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '1';
               load_regmult           <= '0';        
               clear_desloc_soma      <= '1';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '1';
               load_soma_x            <= '0';
               ready                  <= '0';                                                                                                                    
            when e1 =>
               clear_regX             <= '0';
               load_regX              <= '1';
               clear_registraX        <= '0';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '0';
               load_regmult           <= '0';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '0';
               load_soma_x            <= '0'; 
               ready                  <= '0';                                                                                                                                                                    
            when e2 =>
               clear_regX             <= '0';
               load_regX              <= '0';
               clear_registraX        <= '0';
               load_registraX         <= '1';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '0';
               load_regmult           <= '0';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '0';
               load_soma_x            <= '0'; 
               ready                  <= '0';                                                                                               
            when e3 =>
               clear_regX             <= '0';
               load_regX              <= '0';
               clear_registraX        <= '0';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '0';
               load_regmult           <= '0';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '0';
               load_soma_x            <= '0'; 
               ready                  <= '0';                                                                                                  
            when e4 =>
               clear_regX             <= '0';
               load_regX              <= '0';
               clear_registraX        <= '0';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '1';
               clear_regmult          <= '0';
               load_regmult           <= '0';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '0';
               load_soma_x            <= '0'; 
               ready                  <= '0';                                                                                                                                                                                                                    
            when e5 =>
               clear_regX             <= '0';
               load_regX              <= '0';
               clear_registraX        <= '0';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '0';
               load_regmult           <= '1';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '0';
               load_soma_x            <= '0'; 
               ready                  <= '0';                                                                                                                                                                                                                      
            when e6 =>
               clear_regX             <= '0';
               load_regX              <= '0';
               clear_registraX        <= '0';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '0';
               load_regmult           <= '0';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '0';
               load_soma_x            <= '1'; 
               ready                  <= '0';     
            when e7 =>
               clear_regX             <= '0';
               load_regX              <= '0';
               clear_registraX        <= '0';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '0';
               load_regmult           <= '0';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '1';
               clear_soma_x           <= '0';
               load_soma_x            <= '0'; 
               ready                  <= '0';
            when e8 =>
               clear_regX             <= '0';
               load_regX              <= '0';
               clear_registraX        <= '0';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '0';
               load_regx_subtracao    <= '0';
               clear_regmult          <= '0';
               load_regmult           <= '0';      
               clear_desloc_soma      <= '0';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '0';
               load_soma_x            <= '0'; 
               ready                  <= '1';                  
            when others =>
               clear_regX             <= '1';
               load_regX              <= '0';
               clear_registraX        <= '1';
               load_registraX         <= '0';
               clear_regx_subtracao   <= '1';
               load_regx_subtracao    <= '0';       
               clear_desloc_soma      <= '1';
               load_desloc_soma       <= '0';
               clear_soma_x           <= '1';
               load_soma_x            <= '0';
               ready                  <= '0';                                                                                      
        end case;
    end process;
    

end Behavioral;
