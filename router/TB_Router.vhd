library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity TB_Router is
end entity;

architecture sim of TB_Router is

    component Router
        generic(
            router_id  : integer range 0 to 15 := 9;
            DATA_WIDTH : integer := 12;
            ADDR_WIDTH : integer := 2
        );

        port(
            reset, clk : in std_logic;

            output0, output1, output2, output3, output4 : out std_logic_vector(11 downto 0);

            full_other : in std_logic_vector(4 downto 0);

            wr_other0, wr_other1, wr_other2, wr_other3, wr_other4 : out std_logic;

            wr_self0, wr_self1, wr_self2, wr_self3, wr_self4 : in std_logic;

            input0, input1, input2, input3, input4 : in std_logic_vector(11 downto 0);

            full_self0, full_self1, full_self2, full_self3, full_self4 : out std_logic
        );
    end component;

    ------------------------------------------------------------------
    -- clock/reset
    ------------------------------------------------------------------

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

    ------------------------------------------------------------------
    -- router inputs
    ------------------------------------------------------------------

    signal full_other : std_logic_vector(4 downto 0) := "00000";

    signal wr_self0 : std_logic := '0';
    signal wr_self1 : std_logic := '0';
    signal wr_self2 : std_logic := '0';
    signal wr_self3 : std_logic := '0';
    signal wr_self4 : std_logic := '0';

    --  := (others => '0')
    signal input0 : std_logic_vector(11 downto 0) := (others => 'X');
    signal input1 : std_logic_vector(11 downto 0) := (others => 'X');
    signal input2 : std_logic_vector(11 downto 0) := (others => 'X');
    signal input3 : std_logic_vector(11 downto 0) := (others => 'X');
    signal input4 : std_logic_vector(11 downto 0) := (others => 'X');

    ------------------------------------------------------------------
    -- outputs
    ------------------------------------------------------------------

    signal output0 : std_logic_vector(11 downto 0);
    signal output1 : std_logic_vector(11 downto 0);
    signal output2 : std_logic_vector(11 downto 0);
    signal output3 : std_logic_vector(11 downto 0);
    signal output4 : std_logic_vector(11 downto 0);

    signal wr_other0 : std_logic;
    signal wr_other1 : std_logic;
    signal wr_other2 : std_logic;
    signal wr_other3 : std_logic;
    signal wr_other4 : std_logic;

    signal full_self0 : std_logic;
    signal full_self1 : std_logic;
    signal full_self2 : std_logic;
    signal full_self3 : std_logic;
    signal full_self4 : std_logic;

begin

    ------------------------------------------------------------------
    -- UUT
    ------------------------------------------------------------------

    UUT : Router
    generic map(
        router_id  => 9,
        DATA_WIDTH => 12,
        ADDR_WIDTH => 2
    )
    port map(
        clk => clk,
        reset => reset,

        output0 => output0,
        output1 => output1,
        output2 => output2,
        output3 => output3,
        output4 => output4,

        full_other => full_other,

        wr_other0 => wr_other0,
        wr_other1 => wr_other1,
        wr_other2 => wr_other2,
        wr_other3 => wr_other3,
        wr_other4 => wr_other4,

        wr_self0 => wr_self0,
        wr_self1 => wr_self1,
        wr_self2 => wr_self2,
        wr_self3 => wr_self3,
        wr_self4 => wr_self4,

        input0 => input0,
        input1 => input1,
        input2 => input2,
        input3 => input3,
        input4 => input4,

        full_self0 => full_self0,
        full_self1 => full_self1,
        full_self2 => full_self2,
        full_self3 => full_self3,
        full_self4 => full_self4
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
 
        wr_self0 <= '1';
        wr_self3 <= '1';
        wr_self4 <= '1'; 

        input0 <= "000100101011"; -- 9 -> 11  (0->3)
        input3 <= "000101101001"; -- 11 -> 9 (3->0)
        input4 <= "000110100101"; -- 13 -> 5  (4->2)
        wait for 20 ns;

        input0 <= "100100100000"; -- 9 -> 11  (0->3)
        input3 <= "100101100000"; -- 11 -> 9 (3->0)
        input4 <= "100110100000"; -- 13 -> 5  (4->2)
        wait for 20 ns;

        -- 14 -> 8 (4->1)
        
        wr_self0 <= '0';
        wr_self3 <= '0';
        wr_self4 <= '0'; 

        wait for 100 ns;


        ------------------------------------------------------------------
        -- TEST 2 
        ------------------------------------------------------------------

        wr_self3 <= '1';
        wr_self4 <= '1'; 

        input4 <= "000111001001"; -- 14 -> 9 (4->0)
        input3 <= "000101001001"; -- 10 -> 9 (3->0)
        wait for 20 ns;

        input4 <= "100111000000"; -- 14 -> 9 (4->0)
        input3 <= "100101000000"; -- 10 -> 9 (3->0)
        wait for 20 ns;
        
        wr_self4 <= '0'; 
        input3 <= "000101101000"; -- 11 -> 8 (3->2)
        wait for 20 ns;

        input3 <= "100101100000"; -- 11 -> 8 (3->2)
        wait for 20 ns;

        wr_self3 <= '0';

        wait for 100 ns;


        ------------------------------------------------------------------
        -- END
        ------------------------------------------------------------------

        wait;

    end process;

end architecture;