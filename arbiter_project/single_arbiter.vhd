library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity single_arbiter is
	
	port(
		clk, reset : in std_logic;
		-- all of the requests to the output 
		req : in std_logic_vector(4 downto 0);

		-- the winner input which gets this input.
		grant : out std_logic_vector(4 downto 0)
	);
	

end entity;


architecture arch of single_arbiter is
	
	type my_type is (wait0, wait1, wait2, wait3, wait4, grant0, grant1, 
		grant2, grant3, grant4);

	signal r_reg, r_next : my_type;

begin

	-- register
	process(clk, reset)
	begin
		if (reset = '1') then 
			r_reg <= wait0;
		elsif rising_edge(clk) then       
			r_reg <= r_next; 
		end if; 
	end process;

	-- next-state and output logic
	process(r_reg, req)
	begin
		grant <= (others => '0');
		r_next <= r_reg;

		case r_reg is

			-- ==================== WAIT STATES ====================
			when wait0 =>
				if req(0) = '1' then 
					r_next <= grant0;
				elsif req(1) = '1' then
					r_next <= grant1;
				elsif req(2) = '1' then
					r_next <= grant2;
				elsif req(3) = '1' then
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;
				else 
					r_next <= wait0;
				end if;

			when wait1 =>
				if req(1) = '1' then 
					r_next <= grant1;
				elsif req(2) = '1' then
					r_next <= grant2;
				elsif req(3) = '1' then
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;
				elsif req(0) = '1' then
					r_next <= grant0;
				else 
					r_next <= wait1;
				end if;

			when wait2 => 
				if req(2) = '1' then 
					r_next <= grant2;
				elsif req(3) = '1' then
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;
				elsif req(0) = '1' then
					r_next <= grant0;
				elsif req(1) = '1' then
					r_next <= grant1;
				else 
					r_next <= wait2;
				end if;

			when wait3 => 
				if req(3) = '1' then 
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;
				elsif req(0) = '1' then
					r_next <= grant0;
				elsif req(1) = '1' then
					r_next <= grant1;
				elsif req(2) = '1' then
					r_next <= grant2;
				else 
					r_next <= wait3;
				end if;

			when wait4 => 
				if req(4) = '1' then 
					r_next <= grant4;
				elsif req(0) = '1' then
					r_next <= grant0;
				elsif req(1) = '1' then
					r_next <= grant1;
				elsif req(2) = '1' then
					r_next <= grant2;
				elsif req(3) = '1' then
					r_next <= grant3;
				else 
					r_next <= wait4;
				end if;
			
			-- ==================== GRANT STATES  
			when grant0 =>
				grant(0) <= '1';                     
				if req(0) = '1' then
					r_next <= grant0;  
				elsif req(1) = '1' then
					r_next <= grant1;
				elsif req(2) = '1' then 
					r_next <= grant2;   
				elsif req(3) = '1' then
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;       
				else 
					r_next <= wait1;
					grant(0) <= '0';
				end if;

			when grant1 =>
				grant(1) <= '1';
				if req(1) = '1' then
					r_next <= grant1;
				elsif req(2) = '1' then 
					r_next <= grant2;   
				elsif req(3) = '1' then
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;  
				elsif req(0) = '1' then
					r_next <= grant0;  
				else 
					r_next <= wait2;
					grant(1) <= '0';
				end if;

			when grant2 =>
				grant(2) <= '1';
				if req(2) = '1' then
					r_next <= grant2;
				elsif req(3) = '1' then
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;  
				elsif req(0) = '1' then
					r_next <= grant0; 
				elsif req(1) = '1' then
					r_next <= grant1;
				else 
					r_next <= wait3;
					grant(2) <= '0';
				end if;

			when grant3 =>
				grant(3) <= '1';
				if req(3) = '1' then
					r_next <= grant3;
				elsif req(4) = '1' then
					r_next <= grant4;  
				elsif req(0) = '1' then
					r_next <= grant0; 
				elsif req(1) = '1' then
					r_next <= grant1;
				elsif req(2) = '1' then
					r_next <= grant2;
				else 
					r_next <= wait4;
					grant(3) <= '0';
				end if;

			when grant4 =>
				grant(4) <= '1';
				if req(4) = '1' then
					r_next <= grant4;
				elsif req(0) = '1' then
					r_next <= grant0; 
				elsif req(1) = '1' then
					r_next <= grant1;
				elsif req(2) = '1' then
					r_next <= grant2;
				elsif req(3) = '1' then
					r_next <= grant3;
				else 
					r_next <= wait0;
					grant(4) <= '0';
				end if;

		end case;

	end process;

end arch;