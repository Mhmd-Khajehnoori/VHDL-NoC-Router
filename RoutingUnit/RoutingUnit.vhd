library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY RoutingUnit IS
    generic(
        router_id : integer range 0 to 15
    );

    port(
        clk      : in  std_logic;
        reset    : in  std_logic;

		valid_in  : in  std_logic;
		valid_out  : out  std_logic;

        data_in  : in  std_logic_vector(11 downto 0);

        data_out : out std_logic_vector(11 downto 0);
        output   : out std_logic_vector(2 downto 0)
    );

END ENTITY;

ARCHITECTURE arch OF RoutingUnit IS
    signal dest_reg     : std_logic_vector(4 downto 0);
    signal current_dest : std_logic_vector(4 downto 0);
    
    signal dest_int     : integer range 0 to 31;    
    signal curr_x, curr_y, dest_x, dest_y : integer range 0 to 3;

BEGIN
    data_out <= data_in;

    -- Destination Register
    process(clk, reset)
    begin
        if reset = '1' then
            dest_reg <= (others => '0');
        elsif rising_edge(clk) then
            if valid_in = '1' and data_in(11) = '0' then
                dest_reg <= data_in(4 downto 0);
            end if;
        end if;
    end process;

    current_dest <= data_in(4 downto 0) when data_in(11) = '0' else dest_reg;

    curr_x <= router_id mod 4;
    curr_y <= router_id / 4;
    
    dest_int <= to_integer(unsigned(current_dest));
    dest_x   <= dest_int mod 4;
    dest_y   <= dest_int / 4;

    -- Routing Logic
    process(valid_in, curr_x, curr_y, dest_x, dest_y)
    begin
        if valid_in = '0' then
            valid_out <= '0';
            output    <= "111";
        else
            valid_out <= '1';
            if (curr_x = dest_x) and (curr_y = dest_y) then
                output <= "000";      -- local
            elsif (curr_x = dest_x) then
                if (curr_y < dest_y) then
                    output <= "100";  -- south
                else
                    output <= "010";  -- north
                end if;
            elsif (curr_x < dest_x) then
                output <= "011";      -- east
            else
                output <= "001";      -- west
            end if;
        end if;
    end process;
END arch;