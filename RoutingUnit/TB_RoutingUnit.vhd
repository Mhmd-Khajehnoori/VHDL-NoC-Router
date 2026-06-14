library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_RoutingUnit is
end TB_RoutingUnit;

architecture tb_arch of TB_RoutingUnit is
    -- defining the component just like the main ENTITY.
    component RoutingUnit
        generic(
            router_id : integer range 0 to 15
        );
        port(
            dest  : in std_logic_vector(4 downto 0);
            output : out integer range 0 to 4 
        );
    end component;

    signal dest_tb  : std_logic_vector(4 downto 0);
    signal output_tb : integer range 0 to 4; 
    
    -- current Router's number.
    constant ROUTER_ID : integer := 9; 

begin

    uut: RoutingUnit
        generic map(router_id => ROUTER_ID)
        port map(
            dest  => dest_tb,
            output => output_tb 
        );

    process
    begin
	
	-- the current router is the destinantion: output = 0
     	dest_tb  <= std_logic_vector(to_unsigned(9, 5)); 
	wait for 10 ns;
    
	-- going south: output = 4
	dest_tb  <= std_logic_vector(to_unsigned(13, 5)); 
	wait for 10 ns;
      
        -- going north: output = 2
	dest_tb  <= std_logic_vector(to_unsigned(5, 5)); 
	wait for 10 ns;

        -- going east: output = 3
	dest_tb  <= std_logic_vector(to_unsigned(11, 5)); 
        wait for 10 ns;

        -- going west: output = 1
	dest_tb  <= std_logic_vector(to_unsigned(8, 5)); 
        wait for 10 ns; 
 
        wait;

    end process;
end tb_arch;
