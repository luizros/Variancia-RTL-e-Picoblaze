library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top_module is
    Port (clk: in std_logic;
          led: out std_logic_vector(15 downto 0);
          ready: out std_logic 
          );
end top_module;

architecture Behavioral of top_module is

component kcpsm6 
generic(                 hwbuild : std_logic_vector(7 downto 0) := X"00";
                interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
         scratch_pad_memory_size : integer := 64);
port (                   address : out std_logic_vector(11 downto 0);
                     instruction : in std_logic_vector(17 downto 0);
                     bram_enable : out std_logic;
                         in_port : in std_logic_vector(7 downto 0);
                        out_port : out std_logic_vector(7 downto 0);
                         port_id : out std_logic_vector(7 downto 0);
                    write_strobe : out std_logic;
                  k_write_strobe : out std_logic;
                     read_strobe : out std_logic;
                       interrupt : in std_logic;
                   interrupt_ack : out std_logic;
                           sleep : in std_logic;
                           reset : in std_logic;
                             clk : in std_logic);
end component;

component pblaze is
  generic(             C_FAMILY : string := "7S"; 
              C_RAM_SIZE_KWORDS : integer := 2;
           C_JTAG_LOADER_ENABLE : integer := 0);
  Port (      address : in std_logic_vector(11 downto 0);
          instruction : out std_logic_vector(17 downto 0);
               enable : in std_logic;
                  rdl : out std_logic;                    
                  clk : in std_logic);
  end component;
--

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
end  component;


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
end  component;
     
COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_in0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_in1 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal Sclear_regmult, sload_regmult, sclear_regX, sload_regX, sclear_registraX, sload_registraX, sclear_regx_subtracao, sload_regx_subtracao, sclear_desloc_soma, sload_desloc_soma, sclear_soma_x, sload_soma_x: std_logic;
signal sx,ssx, smedia: std_logic_vector(7 downto 0):="00000000";
signal lock, fready, sclk,sstart, sreset,sready: std_logic:='0';
signal svariancia: std_logic_vector(15 downto 0):="0000000000000000";

signal         address : std_logic_vector(11 downto 0);
signal     instruction : std_logic_vector(17 downto 0);
signal     bram_enable : std_logic;
signal         in_port : std_logic_vector(7 downto 0);
signal        out_port : std_logic_vector(7 downto 0);
signal         port_id : std_logic_vector(7 downto 0);
signal    write_strobe : std_logic;
signal  k_write_strobe : std_logic;
signal     read_strobe : std_logic;
signal       interrupt : std_logic;
signal   interrupt_ack : std_logic;
signal    kcpsm6_sleep : std_logic;
signal    kcpsm6_reset : std_logic;
signal             sled: std_logic_vector(7 downto 0);
signal             rdl : std_logic;


begin

processor: kcpsm6
    generic map (                 hwbuild => X"00", 
                         interrupt_vector => X"3FF",
                  scratch_pad_memory_size => 64)
    port map(      address => address,
               instruction => instruction,
               bram_enable => bram_enable,
                   port_id => port_id,
              write_strobe => write_strobe,
            k_write_strobe => k_write_strobe,
                  out_port => out_port,
               read_strobe => read_strobe,
                   in_port => in_port,
                 interrupt => interrupt,
             interrupt_ack => interrupt_ack,
                     sleep => kcpsm6_sleep,
                     reset => kcpsm6_reset,
                       clk => clk);

kcpsm6_sleep <='0';

program_rom: pblaze                    --Name to match your PSM file
     generic map(             C_FAMILY => "7S",   --Family 'S6', 'V6' or '7S'
                     C_RAM_SIZE_KWORDS => 2,      --Program size '1', '2' or '4'
                  C_JTAG_LOADER_ENABLE => 0)      --Include JTAG Loader when set to '1' 
     port map(      address => address,      
                instruction => instruction,
                     enable => bram_enable,
                        rdl => rdl,
                        clk => clk);
                        
                        
bloco_operacional: operacional port map(
           clk => clk,
           x => ssx,
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
           variancia => led
          );

bloco_de_controle: controle port map(
           clk => clk,
           start => sstart,
           reset => kcpsm6_reset,
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


  
my_vio : vio_0
  PORT MAP (
    clk => clk,
    probe_in0 => ssx,
    probe_in1 => smedia,
    probe_out0(0) => sstart,
    probe_out1(0) => kcpsm6_reset,
    probe_out2 => sx
  );

-- processo para entradas
process(clk,kcpsm6_reset)   
begin
    if kcpsm6_reset='1' then
        in_port <= (others=>'0');
    elsif rising_edge(clk) then
           case port_id is
               when "00000001" =>
                   in_port <= sx;
               when "00000010" =>
                   in_port <= "0000000"&sstart;
               when others =>
                   in_port <= (others => '0');
              end case;
    end if;
end process;


-- processo para registrar interrupção
process(clk,interrupt_ack)   
begin
    if interrupt_ack='1' then
        interrupt <= '0';
    elsif rising_edge(clk) then
        if sstart = '1' and lock='0' then
            interrupt <= '1';
            lock <= '1';
        elsif sstart = '0' and lock='1' then
            interrupt <= '0';
            lock <= '0';
        end if;  
    end if;
end process;

-- processo para saidas
process(clk,kcpsm6_reset)   
begin
    if kcpsm6_reset='1' then
        sready <= '0';
        ssx <= (others => '0');
        smedia <= (others => '0');   
    elsif rising_edge(clk) then
       if write_strobe = '1' then
           case port_id is
               when "00000101" =>
                   smedia <= out_port;
               when "00000110" =>
                   sready <= out_port(0);
               when "00000111" =>
                   ssx <= out_port;                
               when others =>
                   sready <= '0';
                   ssx <= (others => '0');
                   smedia <= (others => '0');                   
               end case;
       end if;
   end if;
 end process;


ready <= not fready;

end Behavioral;
