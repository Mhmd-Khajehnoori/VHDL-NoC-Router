library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity register_file is

    generic (
        DATA_WIDTH : integer := 8;  
        ADDR_WIDTH : integer := 3   
    );

	port (
		reset, clk : in std_logic;
		w_en : in std_logic; -- write enable
		w_addr,r_addr0 : in std_logic_vector(ADDR_WIDTH - 1 downto 0); 
		w_data : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		r_data0 : out std_logic_vector(DATA_WIDTH - 1 downto 0)
	);

end entity;


architecture arch of register_file is

	type my_array_type is array (0 to (2**ADDR_WIDTH) - 1) of STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	
	signal array_reg, array_next : my_array_type;

begin


	-- register
	process(clk, reset)
	begin
		if (reset = '1') then
			array_reg <= (others => (others => 'X'));
			
		elsif (clk'event and clk = '1') then 
			array_reg <= array_next;
			
		end if;
	end process;
	
	
	-- next-state logic
	process(array_reg, w_en, w_data, w_addr)
	begin 
		array_next <= array_reg;
		if (w_en = '1') then
			array_next(to_integer(unsigned(w_addr))) <= w_data;
		end if;
	end process;
	
	-- output logic
	r_data0 <= array_reg(to_integer(unsigned(r_addr0)));

end arch;