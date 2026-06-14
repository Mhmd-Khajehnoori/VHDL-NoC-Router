library ieee;
use ieee.std_logic_1164.all; 

entity fifo_controller is

    generic (
		ADDR_WIDTH : integer := 3
    );

	port (
		reset, clk : in std_logic;
		wr, rd : in std_logic;
		empty, full : out std_logic;
		w_addr, r_addr : out std_logic_vector(ADDR_WIDTH - 1 downto 0)
	);

end entity;


architecture arch of fifo_controller is

	constant PTR_WIDTH : integer := ADDR_WIDTH + 1;
	
	-- counter 
	component my_counter 
		 generic (
			  COUNT_WIDTH : integer := 4
		 );
		 port (
			  clk, reset : in  std_logic;
			  en         : in  std_logic;  
			  q          : out std_logic_vector(COUNT_WIDTH - 1 downto 0)
		 );		
	end component;
	
	
    signal w_ptr, r_ptr       : std_logic_vector(PTR_WIDTH - 1 downto 0);
    signal w_en, r_en         : std_logic;
    signal full_sig, empty_sig: std_logic;

	 
begin

-- register & next-state logic.

	-- counter enable signals
    w_en <= wr and (not full_sig);
    r_en <= rd and (not empty_sig);
	 

	-- write pointer counter
    w_pointer_counter: my_counter
        generic map (
            COUNT_WIDTH => PTR_WIDTH
        )
        port map (
            clk   => clk,
            reset => reset,
            en    => w_en,
            q     => w_ptr
        );

		  
	-- read pointer counter 
    r_pointer_counter: my_counter
        generic map (
            COUNT_WIDTH => PTR_WIDTH
        )
        port map (
            clk   => clk,
            reset => reset,
            en    => r_en,
            q     => r_ptr
        );
	
	
-- output logic
	
	-- extracting the address.
   w_addr <= w_ptr(ADDR_WIDTH - 1 downto 0);
   r_addr <= r_ptr(ADDR_WIDTH - 1 downto 0);
	
	
	-- empty / full logic
	empty_sig <= '1' when w_ptr = r_ptr else '0';
   empty     <= empty_sig;

   full_sig  <= '1' when (w_ptr(ADDR_WIDTH - 1 downto 0) = r_ptr(ADDR_WIDTH - 1 downto 0)) 
                      and (w_ptr(ADDR_WIDTH) /= r_ptr(ADDR_WIDTH)) else '0';
   full      <= full_sig;



end arch;