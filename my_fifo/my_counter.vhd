library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity my_counter is
    generic (
        COUNT_WIDTH : integer := 4
    );
    port (
        clk, reset : in  std_logic;
        en         : in  std_logic;  
        q          : out std_logic_vector(COUNT_WIDTH - 1 downto 0)
    );
end entity;

architecture arch of my_counter is 

    signal r_reg, r_next : unsigned(COUNT_WIDTH - 1 downto 0);
        
begin
    -- register
    process(clk, reset)
    begin
        if reset = '1' then
            r_reg <= (others => '0');
        elsif rising_edge(clk) then 
            r_reg <= r_next;
        end if;
    end process;
     
    -- next-state logic
    process(r_reg, en)
    begin
        r_next <= r_reg;       
        if (en = '1') then 
            r_next <= r_reg + 1;
        end if;
    end process;
    
    -- output logic
    q <= std_logic_vector(r_reg);
     
end arch;
