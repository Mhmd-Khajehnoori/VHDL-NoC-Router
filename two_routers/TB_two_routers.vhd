library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_two_routers is
end entity;


architecture sim of TB_two_routers is
    component two_routers 

    generic(
        router_id_1 : integer range 0 to 15 := 9;
        router_id_2 : integer range 0 to 15 := 10;
        DATA_WIDTH : integer := 12;
        ADDR_WIDTH : integer := 2
    );

    port(
        reset, clk : in std_logic;

        -- router 9 
        input9_0, input9_1, input9_2, input9_4 : in std_logic_vector(11 downto 0);
        output9_0, output9_1, output9_2, output9_4 : out std_logic_vector(11 downto 0);
        wr_self9_0, wr_self9_1, wr_self9_2, wr_self9_4 : in std_logic := '0';
        wr_other9_0, wr_other9_1, wr_other9_2, wr_other9_4 : out std_logic;
        full_self9_0, full_self9_1, full_self9_2, full_self9_4 : out std_logic;
        full_other9_0, full_other9_1, full_other9_2, full_other9_4 : in std_logic;

        -- router 10 
        input10_0, input10_2, input10_3, input10_4 : in std_logic_vector(11 downto 0);
        output10_0, output10_2, output10_3, output10_4 : out std_logic_vector(11 downto 0); 
        wr_self10_0, wr_self10_2, wr_self10_3, wr_self10_4 : in std_logic := '0';
        wr_other10_0, wr_other10_2, wr_other10_3, wr_other10_4 : out std_logic;
        full_self10_0, full_self10_2, full_self10_3, full_self10_4 : out std_logic;
        full_other10_0, full_other10_2, full_other10_3, full_other10_4 : in std_logic

    );

end component;

        signal reset, clk : std_logic;

        -- router 9 ???? ????? 3 ??? ??? ?? ???? 10 ????
        signal input9_0, input9_1, input9_2, input9_4 : std_logic_vector(11 downto 0);
        signal output9_0, output9_1, output9_2, output9_4 : std_logic_vector(11 downto 0);
        signal wr_self9_0, wr_self9_1, wr_self9_2, wr_self9_4 : std_logic := '0';
        signal wr_other9_0, wr_other9_1, wr_other9_2, wr_other9_4 : std_logic;
        signal full_self9_0, full_self9_1, full_self9_2, full_self9_4 : std_logic;
        signal full_other9_0, full_other9_1, full_other9_2, full_other9_4 : std_logic := '0';

        -- router 10 ???? ????? 1 ??? ??? ?? ???? ????? 9 ????
        signal input10_0, input10_2, input10_3, input10_4 : std_logic_vector(11 downto 0);
        signal output10_0, output10_2, output10_3, output10_4 : std_logic_vector(11 downto 0); 
        signal wr_self10_0, wr_self10_2, wr_self10_3, wr_self10_4 : std_logic := '0';
        signal wr_other10_0, wr_other10_2, wr_other10_3, wr_other10_4 : std_logic;
        signal full_self10_0, full_self10_2, full_self10_3, full_self10_4 : std_logic;
        signal full_other10_0, full_other10_2, full_other10_3, full_other10_4 : std_logic := '0';

begin

    uut : two_routers
     generic map(
        router_id_1 => 9,
        router_id_2 => 10,
        DATA_WIDTH => 12,
        ADDR_WIDTH => 3
    )
     port map(
        reset => reset,
        clk => clk,
        input9_0 => input9_0,
        input9_1 => input9_1,
        input9_2 => input9_2,
        input9_4 => input9_4,
        output9_0 => output9_0,
        output9_1 => output9_1,
        output9_2 => output9_2,
        output9_4 => output9_4,
        wr_self9_0 => wr_self9_0,
        wr_self9_1 => wr_self9_1,
        wr_self9_2 => wr_self9_2,
        wr_self9_4 => wr_self9_4,
        wr_other9_0 => wr_other9_0,
        wr_other9_1 => wr_other9_1,
        wr_other9_2 => wr_other9_2,
        wr_other9_4 => wr_other9_4,
        full_self9_0 => full_self9_0,
        full_self9_1 => full_self9_1,
        full_self9_2 => full_self9_2,
        full_self9_4 => full_self9_4,
        full_other9_0 => full_other9_0,
        full_other9_1 => full_other9_1,
        full_other9_2 => full_other9_2,
        full_other9_4 => full_other9_4,
        input10_0 => input10_0,
        input10_2 => input10_2,
        input10_3 => input10_3,
        input10_4 => input10_4,
        output10_0 => output10_0,
        output10_2 => output10_2,
        output10_3 => output10_3,
        output10_4 => output10_4,
        wr_self10_0 => wr_self10_0,
        wr_self10_2 => wr_self10_2,
        wr_self10_3 => wr_self10_3,
        wr_self10_4 => wr_self10_4,
        wr_other10_0 => wr_other10_0,
        wr_other10_2 => wr_other10_2,
        wr_other10_3 => wr_other10_3,
        wr_other10_4 => wr_other10_4,
        full_self10_0 => full_self10_0,
        full_self10_2 => full_self10_2,
        full_self10_3 => full_self10_3,
        full_self10_4 => full_self10_4,
        full_other10_0 => full_other10_0,
        full_other10_2 => full_other10_2,
        full_other10_3 => full_other10_3,
        full_other10_4 => full_other10_4
    );


    ------------------------------------------------------------------
    -- CLOCK
    ------------------------------------------------------------------

    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;

            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;

    ------------------------------------------------------------------
    -- STIMULUS
    ------------------------------------------------------------------

    stim_proc : process
    begin

    ------------------------------------------------------------------
    -- TEST 0 : RESET
    ------------------------------------------------------------------
        reset <= '1';

        wait for 40 ns;

        reset <= '0';

    ------------------------------------------------------------------
    -- TEST 1
    ------------------------------------------------------------------

        wr_self9_0 <= '1';
        wr_self9_4 <= '1';
        wr_self10_4 <= '1';
        wr_self10_3 <= '1';

        -- headers
        input9_0 <= "000100101011"; -- 9 -> 11 
        input9_4 <= "000110100101"; -- 13 -> 5 
        input10_4 <= "000111001000"; -- 14 -> 8 
        input10_3 <= "000101101001"; -- 11 -> 9
        wait for 20 ns;

        -- tails
        input9_0 <= "100100100000"; -- 9 -> 11 
        input9_4 <= "100110100000"; -- 13 -> 5 
        input10_4 <= "100111000000"; -- 14 -> 8 
        input10_3 <= "100101100000"; -- 11 -> 9
        -- 11 -> 9
        wait for 20 ns;


        wr_self9_0 <= '0';
        wr_self9_4 <= '0';
        wr_self10_4 <= '0';
        wr_self10_3 <= '0';

        -- input9_0 <= (others => 'X');  
        -- input9_4 <= (others => 'X');
        -- input10_4 <= (others => 'X');
        -- input10_3 <= (others => 'X');
        

        wait for 100 ns;

    ------------------------------------------------------------------
    -- TEST 2
    ------------------------------------------------------------------

        wr_self10_0 <= '1'; 
        wr_self10_3 <= '1';
        wr_self10_4 <= '1';   

        -- headers
        input10_4 <= "000111001001"; -- 14 -> 9
        input10_0 <= "000101001001"; -- 10 -> 9
        input10_3 <= "000101101000"; -- 11 -> 8
        wait for 20 ns;

        -- tails
        input10_4 <= "100111000000"; -- 14 -> 9
        input10_0 <= "100101000000"; -- 10 -> 9
        input10_3 <= "100101100000"; -- 11 -> 8
        wait for 20 ns;

        wr_self10_0 <= '0'; 
        wr_self10_3 <= '0';
        wr_self10_4 <= '0';  
        -- input10_4 <= (others => 'X');
        -- input10_0 <= (others => 'X');
        -- input10_3 <= (others => 'X');

        wait for 100 ns;


        wait;
    end process;

end sim;