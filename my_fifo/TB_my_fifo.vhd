library ieee;
use ieee.std_logic_1164.all;

entity TB_my_fifo is
end TB_my_fifo;

architecture sim of TB_my_fifo is

    component my_fifo
        generic (
            DATA_WIDTH : integer := 8;
            ADDR_WIDTH : integer := 3
        );
        port (
            clk, reset : in std_logic;
            wr, rd     : in std_logic;
            w_data     : in std_logic_vector(DATA_WIDTH-1 downto 0);
            r_data     : out std_logic_vector(DATA_WIDTH-1 downto 0);
            empty, full: out std_logic
        );
    end component;

    signal clk, reset : std_logic := '0';
    signal wr, rd     : std_logic := '0';

    signal w_data : std_logic_vector(7 downto 0) := (others => '0');
    signal r_data : std_logic_vector(7 downto 0);

    signal empty, full : std_logic;

begin

    uut : my_fifo
        generic map(
            DATA_WIDTH => 8,
            ADDR_WIDTH => 3
        )
        port map(
            clk    => clk,
            reset  => reset,
            wr     => wr,
            rd     => rd,
            w_data => w_data,
            r_data => r_data,
            empty  => empty,
            full   => full
        );

    -------------------------------------------------
    -- Clock (10 ns period)
    -------------------------------------------------
    clk_process : process
    begin
        while now < 500 ns loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    -------------------------------------------------
    -- Stimulus
    -------------------------------------------------
    stim_proc : process
    begin

        -------------------------------------------------
        -- RESET
        -------------------------------------------------
        reset <= '1';
        wait for 20 ns;

        reset <= '0';
        wait for 20 ns;

        -------------------------------------------------
        -- WRITE 8 BYTES
        -------------------------------------------------
        wr <= '1';

        w_data <= x"11"; wait for 10 ns;
        w_data <= x"22"; wait for 10 ns;
        w_data <= x"33"; wait for 10 ns;
        w_data <= x"44"; wait for 10 ns;
        w_data <= x"55"; wait for 10 ns;
        w_data <= x"66"; wait for 10 ns;
        w_data <= x"77"; wait for 10 ns;
        w_data <= x"88"; wait for 10 ns;

        wr <= '0';

        -------------------------------------------------
        -- OVERFLOW TEST
        -------------------------------------------------
        wait for 20 ns;

        wr <= '1';
        w_data <= x"AA";
        wait for 10 ns;
        wr <= '0';

        -------------------------------------------------
        -- READ ALL DATA
        -------------------------------------------------
        wait for 20 ns;

        rd <= '1';

        wait for 10 ns; -- expect 11
        wait for 10 ns; -- expect 22
        wait for 10 ns; -- expect 33
        wait for 10 ns; -- expect 44
        wait for 10 ns; -- expect 55
        wait for 10 ns; -- expect 66
        wait for 10 ns; -- expect 77
        wait for 10 ns; -- expect 88

        rd <= '0';

        -------------------------------------------------
        -- UNDERFLOW TEST
        -------------------------------------------------
        wait for 20 ns;

        rd <= '1';
        wait for 20 ns;
        rd <= '0';

        wait;

    end process;

end sim;