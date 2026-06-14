library ieee;
use ieee.std_logic_1164.all; 

entity my_fifo is

    generic (
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 3   
    );
    port (
        clk, reset : in  std_logic;
        wr, rd : in  std_logic;
        w_data : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        r_data : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        empty, full : out std_logic 
    );

end entity;


architecture arch of my_fifo is

	-- register
	component register_file 
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
	end component;
	
	-- fifo controller
	component fifo_controller 
		generic (
			ADDR_WIDTH : integer := 3
		 );

		port (
			reset, clk : in std_logic;
			wr, rd : in std_logic;
			empty, full : out std_logic;
			w_addr, r_addr : out std_logic_vector(ADDR_WIDTH - 1 downto 0)
		);
	end component;
	
	signal is_valid : std_logic;
	signal w_addr_sig, r_addr_sig : std_logic_vector(ADDR_WIDTH - 1 downto 0);
	signal w_en_sig : std_logic;
	signal full_sig, empty_sig : std_logic;


begin

		is_valid <= '0' when w_data = (w_data'range => 'X') or w_data = (w_data'range => 'U') 
               else '1';

		w_en_sig <= wr and (not full_sig) and is_valid;
		empty <= empty_sig;
		full  <= full_sig;
	
	
		cntrl_unit : fifo_controller
		generic map(
			ADDR_WIDTH => ADDR_WIDTH
		)
		port map(
			reset => reset,
			clk => clk,
			wr => wr,
			rd => rd,
			empty => empty_sig,
			full  => full_sig,
			w_addr => w_addr_sig,
			r_addr => r_addr_sig	
		);
		
		
		reg_file_unit : register_file 
		generic map(
			DATA_WIDTH => DATA_WIDTH,
         ADDR_WIDTH => ADDR_WIDTH
		)
		port map(
			reset => reset,
			clk => clk,
			w_en => w_en_sig,
			w_data => w_data,
			r_data0 => r_data,
			w_addr => w_addr_sig,
			r_addr0 => r_addr_sig
			
		);
	
 
end arch;