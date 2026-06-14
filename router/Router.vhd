library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY Router IS

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

END ENTITY;

architecture arch of Router is

    component CrossbarSwitch 
        port( i0,i1,i2,i3,i4 : in std_logic_vector(11 downto 0); 
        slct0, slct1, slct2, slct3, slct4 : in std_logic_vector(1 downto 0); 
        o0,o1,o2,o3,o4 : out std_logic_vector(11 downto 0) 
        );
    end component;
----------------------------------------------------------------------------------
    component RoutingUnit 
    	generic(router_id : integer range 0 to 15
        );

        port ( 
        clk, reset : in std_logic;
        valid_in  : in  std_logic;
		valid_out  : out  std_logic;
        data_in : in std_logic_vector(11 downto 0); 
        data_out : out std_logic_vector(11 downto 0); 
        output : out std_logic_vector(2 downto 0) -- the number of the current router's output.
        );
    end component;
----------------------------------------------------------------------
    component arbiter_project 
        port(
        clk, reset : in std_logic;
        -- input fifos
        data_in0, data_in1, data_in2, data_in3, data_in4 : in std_logic_vector(11 downto 0);
        req0 , req1, req2, req3, req4 : in std_logic := '0';

        -- the permission to pass.
        g0, g1, g2, g3, g4 : out std_logic := '0';

        -- write requests to destination fifo buffer
        wr_req0, wr_req1, wr_req2, wr_req3, wr_req4 : out std_logic := '0' ; 

        -- signals that shows the possibility to write on destination fifo
        credit_in : in std_logic_vector(4 downto 0); 
        
        -- output of routing unit : output numbers (0 to 4) -> routing unit respond
        out0, out1, out2, out3, out4 : in std_logic_vector(2 downto 0);

        valid0, valid1, valid2, valid3, valid4 : in std_logic;
        
        -- xbar signals
        data_out0, data_out1, data_out2, data_out3, data_out4 : out std_logic_vector(11 downto 0); 
        slct0, slct1, slct2, slct3, slct4 : out std_logic_vector(1 downto 0)
        );       
    end component; 
-----------------------------------------------------------------
    component my_fifo 
        generic (
        DATA_WIDTH : integer;
        ADDR_WIDTH : integer   
        );
        port (
        clk, reset : in  std_logic;
        wr, rd : in  std_logic;
        w_data : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        r_data : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        empty, full : out std_logic 
        );
    end component;
--------------------------------------------------------------
    -- connects fifo output to arbiter input.
    signal arb_i0, arb_i1, arb_i2, arb_i3, arb_i4 : std_logic_vector(11 downto 0) := (others => 'X');
    signal empty_self0, empty_self1, empty_self2, empty_self3, empty_self4 : std_logic;

    -- output of the routing unit
    signal dest_o0, dest_o1, dest_o2, dest_o3, dest_o4 : std_logic_vector(2 downto 0);

    signal arb_o0, arb_o1, arb_o2, arb_o3, arb_o4 : std_logic_vector(11 downto 0) := (others => 'X');
    signal arb_slct0, arb_slct1, arb_slct2, arb_slct3, arb_slct4 : std_logic_vector(1 downto 0);

    signal rou_in0, rou_in1, rou_in2, rou_in3, rou_in4 : std_logic_vector(11 downto 0);

    signal rd0, rd1, rd2, rd3, rd4 : std_logic := '0';

    signal req0, req1, req2, req3, req4 : std_logic := '0';

    signal credit_in : std_logic_vector(4 downto 0);
    signal full_other_set : std_logic_vector(4 downto 0);

    signal valid_arb0, valid_arb1, valid_arb2, valid_arb3, valid_arb4 : std_logic := '0';
    signal valid_fifo0, valid_fifo1, valid_fifo2, valid_fifo3, valid_fifo4 : std_logic;  -- ?? fifo

    signal valid_arb_reg0, valid_arb_reg1, valid_arb_reg2, valid_arb_reg3, valid_arb_reg4 : std_logic;

begin
    

    req0 <= not empty_self0 ;
    req1 <= not empty_self1 ;
    req2 <= not empty_self2 ;
    req3 <= not empty_self3 ;
    req4 <= not empty_self4 ;

    full_other_set(0) <= full_other0;
    full_other_set(1) <= full_other1;
    full_other_set(2) <= full_other2;
    full_other_set(3) <= full_other3;
    full_other_set(4) <= full_other4;
    
    credit_in <= not full_other_set;

    valid_fifo0 <= not empty_self0;
    valid_fifo1 <= not empty_self1;
    valid_fifo2 <= not empty_self2;
    valid_fifo3 <= not empty_self3;
    valid_fifo4 <= not empty_self4;

-- =======================================
--           CrossBar Switch
-- =======================================

    xbar : CrossbarSwitch
    port map(
        i0 => arb_o0,
        i1 => arb_o1,
        i2 => arb_o2,
        i3 => arb_o3,
        i4 => arb_o4,
        slct0 => arb_slct0,
        slct1 => arb_slct1,
        slct2 => arb_slct2,
        slct3 => arb_slct3,
        slct4 => arb_slct4,
        o0 => output0,
        o1 => output1,
        o2 => output2,
        o3 => output3,
        o4 => output4
    );

-- =======================================
--            routing units
-- =======================================

    routingU0 : RoutingUnit
    generic map(
        router_id => router_id
    )
    port map(
        clk => clk,
        reset => reset,
        valid_in  => valid_fifo0,
		valid_out  => valid_arb0,
        data_in => rou_in0,
        data_out => arb_i0,
        output => dest_o0
    );

    routingU1 : RoutingUnit
     generic map(
        router_id => router_id
    )
    port map(
        clk => clk,
        reset => reset,
        valid_in  => valid_fifo1,
		valid_out  => valid_arb1,
        data_in => rou_in1,
        data_out => arb_i1,
        output => dest_o1
    );

    routingU2 : RoutingUnit
     generic map(
        router_id => router_id
    )
    port map(
        clk => clk,
        reset => reset,
        valid_in  => valid_fifo2,
		valid_out  => valid_arb2,
        data_in => rou_in2,
        data_out => arb_i2,
        output => dest_o2
    );

    routingU3 : RoutingUnit
     generic map(
        router_id => router_id
    )
    port map(
        clk => clk,
        reset => reset,
        valid_in  => valid_fifo3,
		valid_out  => valid_arb3,
        data_in => rou_in3,
        data_out => arb_i3,
        output => dest_o3
    );

    routingU4 : RoutingUnit
     generic map(
        router_id => router_id
    )
    port map(
        clk => clk,
        reset => reset,
        valid_in  => valid_fifo4,
		valid_out  => valid_arb4,
        data_in => rou_in4,
        data_out => arb_i4,
        output => dest_o4
    );

-- =======================================
--                arbiter
-- =======================================

    arb : arbiter_project
     port map(
        clk => clk,
        reset => reset,
        data_in0 => arb_i0,
        data_in1 => arb_i1,
        data_in2 => arb_i2,
        data_in3 => arb_i3,
        data_in4 => arb_i4,
        req0 => req0,
        req1 => req1,
        req2 => req2,
        req3 => req3,
        req4 => req4,
        g0 => rd0,
        g1 => rd1,
        g2 => rd2,
        g3 => rd3,
        g4 => rd4,
        wr_req0 => wr_other0,
        wr_req1 => wr_other1,
        wr_req2 => wr_other2,
        wr_req3 => wr_other3,
        wr_req4 => wr_other4,
        credit_in => credit_in,
        out0 => dest_o0,
        out1 => dest_o1,
        out2 => dest_o2,
        out3 => dest_o3,
        out4 => dest_o4,
        valid0 => valid_arb0,      
        valid1 => valid_arb1,
        valid2 => valid_arb2,
        valid3 => valid_arb3,
        valid4 => valid_arb4,
        data_out0 => arb_o0,
        data_out1 => arb_o1,
        data_out2 => arb_o2,
        data_out3 => arb_o3,
        data_out4 => arb_o4,
        slct0 => arb_slct0,
        slct1 => arb_slct1,
        slct2 => arb_slct2,
        slct3 => arb_slct3,
        slct4 => arb_slct4
    );

-- =======================================
--                fifo
-- =======================================

    fifo0 : my_fifo
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        wr => wr_self0,
        rd => rd0,
        w_data => input0,
        r_data => rou_in0,
        empty => empty_self0,
        full => full_self0
    );

    fifo1 : my_fifo
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        wr => wr_self1,
        rd => rd1,
        w_data => input1,
        r_data => rou_in1,
        empty => empty_self1,
        full => full_self1
    );


    fifo2 : my_fifo
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        wr => wr_self2,
        rd => rd2,
        w_data => input2,
        r_data => rou_in2,
        empty => empty_self2,
        full => full_self2
    );


    fifo3 : my_fifo
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        wr => wr_self3,
        rd => rd3,
        w_data => input3,
        r_data => rou_in3,
        empty => empty_self3,
        full => full_self3
    );


    fifo4 : my_fifo
    generic map(
        DATA_WIDTH => DATA_WIDTH,
        ADDR_WIDTH => ADDR_WIDTH
    )
    port map(
        clk => clk,
        reset => reset,
        wr => wr_self4,
        rd => rd4,
        w_data => input4,
        r_data => rou_in4,
        empty => empty_self4,
        full => full_self4
    );

 

end arch;