library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_routers is
    generic(
        router_id_1 : integer range 0 to 15 := 9;
        router_id_2 : integer range 0 to 15 := 10;
        DATA_WIDTH : integer := 12;
        ADDR_WIDTH : integer := 3
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

end entity;


architecture arch of two_routers is

    component Router 
	generic(
        router_id : integer range 0 to 15 := 9; -- 9 or 10
        DATA_WIDTH : integer := 12;
        ADDR_WIDTH : integer := 2
	);

	port (
        reset, clk : in std_logic;

        -- for crossbar
        output0, output1, output2, output3, output4 : out std_logic_vector(11 downto 0);
        -- for arbiter 
        full_other0, full_other1, full_other2, full_other3, full_other4 : in std_logic;
        -- sending request to the next router's fifo! 
        wr_other0, wr_other1, wr_other2, wr_other3, wr_other4 : out std_logic;

        -- for fifos
        wr_self0, wr_self1, wr_self2, wr_self3, wr_self4 : in std_logic;
        input0, input1, input2, input3, input4 : in std_logic_vector(11 downto 0);
        full_self0, full_self1, full_self2, full_self3, full_self4 : out std_logic
    );
end component;

    signal port_9to10, port_10to9 : STD_LOGIC_VECTOR(11 downto 0);
    signal wr_9to10, wr_10to9 : std_logic;
    signal full9, full10 : std_logic;

begin

    router9 : Router
     generic map(
        router_id => router_id_1,
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
     port map(
        reset => reset,
        clk => clk,
        output0 => output9_0,
        output1 => output9_1,
        output2 => output9_2,
        output3 => port_9to10,
        output4 => output9_4,
        full_other0 => full_other9_0,
        full_other1 => full_other9_1,
        full_other2 => full_other9_2,
        full_other3 => full10,
        full_other4 => full_other9_4,
        wr_other0 => wr_other9_0,
        wr_other1 => wr_other9_1,
        wr_other2 => wr_other9_2,
        wr_other3 => wr_9to10,
        wr_other4 => wr_other9_4,
        wr_self0 => wr_self9_0,
        wr_self1 => wr_self9_1,
        wr_self2 => wr_self9_2,
        wr_self3 => wr_10to9,
        wr_self4 => wr_self9_4,
        input0 => input9_0,
        input1 => input9_1,
        input2 => input9_2,
        input3 => port_10to9,
        input4 => input9_4,
        full_self0 => full_self9_0,
        full_self1 => full_self9_1,
        full_self2 => full_self9_2,
        full_self3 => full9,
        full_self4 => full_self9_4
    );


    router10 : Router
     generic map(
        router_id => router_id_2,
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
     port map(
        reset => reset,
        clk => clk,
        output0 => output10_0,
        output1 => port_10to9,
        output2 => output10_2,
        output3 => output10_3,
        output4 => output10_4,
        full_other0 => full_other10_0,
        full_other1 => full9,
        full_other2 => full_other10_2,
        full_other3 => full_other10_3,
        full_other4 => full_other10_4,
        wr_other0 => wr_other10_0,
        wr_other1 => wr_10to9,
        wr_other2 => wr_other10_2,
        wr_other3 => wr_other10_3,
        wr_other4 => wr_other10_4,
        wr_self0 => wr_self10_0,
        wr_self1 => wr_9to10,
        wr_self2 => wr_self10_2,
        wr_self3 => wr_self10_3,
        wr_self4 => wr_self10_4,
        input0 => input10_0,
        input1 => port_9to10,
        input2 => input10_2,
        input3 => input10_3,
        input4 => input10_4,
        full_self0 => full_self10_0,
        full_self1 => full10,
        full_self2 => full_self10_2,
        full_self3 => full_self10_3,
        full_self4 => full_self10_4
    );




end arch;