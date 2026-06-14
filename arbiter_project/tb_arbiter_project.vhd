library ieee;
use ieee.std_logic_1164.all;

entity tb_arbiter_project is
end;

architecture sim of tb_arbiter_project is

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

    signal data_in0,data_in1,data_in2,data_in3,data_in4 :
           std_logic_vector(11 downto 0);

    signal req0,req1,req2,req3,req4 : std_logic;

    signal g0,g1,g2,g3,g4 : std_logic;

    signal wr_req0,wr_req1,wr_req2,wr_req3,wr_req4 : std_logic;

    signal credit_in : std_logic_vector(4 downto 0);

    signal out0,out1,out2,out3,out4 :
           std_logic_vector(2 downto 0);

    signal data_out0,data_out1,data_out2,data_out3,data_out4 :
           std_logic_vector(11 downto 0);

    signal slct0,slct1,slct2,slct3,slct4 :
           std_logic_vector(1 downto 0);

begin

--     uut : entity work.arbiter_project
--     port map(
--         clk => clk,
--         reset => reset,

--         data_in0 => data_in0,
--         data_in1 => data_in1,
--         data_in2 => data_in2,
--         data_in3 => data_in3,
--         data_in4 => data_in4,

--         req0 => req0,
--         req1 => req1,
--         req2 => req2,
--         req3 => req3,
--         req4 => req4,

--         g0 => g0,
--         g1 => g1,
--         g2 => g2,
--         g3 => g3,
--         g4 => g4,

--         wr_req0 => wr_req0,
--         wr_req1 => wr_req1,
--         wr_req2 => wr_req2,
--         wr_req3 => wr_req3,
--         wr_req4 => wr_req4,

--         credit_in => credit_in,

--         out0 => out0,
--         out1 => out1,
--         out2 => out2,
--         out3 => out3,
--         out4 => out4,

--         data_out0 => data_out0,
--         data_out1 => data_out1,
--         data_out2 => data_out2,
--         data_out3 => data_out3,
--         data_out4 => data_out4,

--         slct0 => slct0,
--         slct1 => slct1,
--         slct2 => slct2,
--         slct3 => slct3,
--         slct4 => slct4
--     );

--     clk <= not clk after 10 ns;

--     stim_proc : process
-- begin

--     ------------------------------------------------------------------
--     -- INITIAL VALUES
--     ------------------------------------------------------------------

--     reset <= '1';

--     req0 <= '0';
--     req1 <= '0';
--     req2 <= '0';
--     req3 <= '0';
--     req4 <= '0';

--     credit_in <= "11111";

--     data_in0 <= x"111";
--     data_in1 <= x"222";
--     data_in2 <= x"333";
--     data_in3 <= x"444";
--     data_in4 <= x"555";

--     out0 <= "000";
--     out1 <= "001";
--     out2 <= "010";
--     out3 <= "011";
--     out4 <= "100";

--     wait for 20 ns;

--     reset <= '0';

--     wait for 20 ns;

--     ------------------------------------------------------------------
--     -- TEST 1
--     -- SINGLE REQUEST FROM INPUT0 TO OUTPUT0
--     ------------------------------------------------------------------

--     req0 <= '1';

--     wait for 40 ns;

--     req0 <= '0';

--     wait for 40 ns;

--     -- Expected:
--     -- g0 = 1
--     -- wr_req0 = 1
--     -- data_out0 = data_in0
--     -- slct0 = "11"



--     ------------------------------------------------------------------
--     -- TEST 2
--     -- SINGLE REQUEST FROM INPUT1 TO OUTPUT1
--     ------------------------------------------------------------------

--     out1 <= "001";
--     req1 <= '1';

--     wait for 40 ns;

--     req1 <= '0';

--     wait for 40 ns;

--     -- Expected:
--     -- g1 = 1
--     -- wr_req1 = 1
--     -- slct1 = "10"



--     ------------------------------------------------------------------
--     -- TEST 3
--     -- ALL INPUTS REQUEST DIFFERENT OUTPUTS
--     ------------------------------------------------------------------

--     req0 <= '1';
--     req1 <= '1';
--     req2 <= '1';
--     req3 <= '1';
--     req4 <= '1';

--     out0 <= "000";
--     out1 <= "001";
--     out2 <= "010";
--     out3 <= "011";
--     out4 <= "100";

--     wait for 60 ns;

--     req0 <= '0';
--     req1 <= '0';
--     req2 <= '0';
--     req3 <= '0';
--     req4 <= '0';

--     wait for 40 ns;

--     -- Expected:
--     -- g0..g4 all become active
--     -- wr_req0..wr_req4 active



--     ------------------------------------------------------------------
--     -- TEST 4
--     -- CONTENTION
--     -- INPUT0 + INPUT1 WANT OUTPUT0
--     ------------------------------------------------------------------

--     out0 <= "000";
--     out1 <= "000";

--     req0 <= '1';
--     req1 <= '1';

--     wait for 100 ns;

--     req0 <= '0';
--     req1 <= '0';

--     wait for 40 ns;

--     -- Expected:
--     -- Only one grant initially
--     -- Then round-robin gives turn to other requester



--     ------------------------------------------------------------------
--     -- TEST 5
--     -- THREE INPUTS WANT SAME OUTPUT
--     ------------------------------------------------------------------

--     out0 <= "010";
--     out1 <= "010";
--     out2 <= "010";

--     req0 <= '1';
--     req1 <= '1';
--     req2 <= '1';

--     wait for 150 ns;

--     req0 <= '0';
--     req1 <= '0';
--     req2 <= '0';

--     wait for 50 ns;

--     -- Expected:
--     -- Round-robin arbitration visible



--     ------------------------------------------------------------------
--     -- TEST 6
--     -- CREDIT BLOCKING
--     ------------------------------------------------------------------

--     credit_in <= "11110";

--     out0 <= "000";
--     req0 <= '1';

--     wait for 60 ns;

--     req0 <= '0';

--     wait for 40 ns;

--     -- Expected:
--     -- wr_req0 = 0
--     -- because credit_in(0)=0

	

--     ------------------------------------------------------------------
--     -- TEST 7
--     -- CHECK SELECT SIGNALS
--     ------------------------------------------------------------------

--     out0 <= "001";
--     out1 <= "010";
--     out2 <= "011";
--     out3 <= "100";
--     out4 <= "000";

--     wait for 40 ns;

--     -- Expected:
--     -- slct0 = "00"
--     -- slct1 = "00"
--     -- slct2 = "00"
--     -- slct3 = "00"
--     -- slct4 = "00"



--     ------------------------------------------------------------------
--     -- TEST 8
--     -- DATA PATH CHECK
--     ------------------------------------------------------------------

--     data_in0 <= x"AAA";
--     data_in1 <= x"BBB";
--     data_in2 <= x"CCC";
--     data_in3 <= x"DDD";
--     data_in4 <= x"EEE";

--     wait for 40 ns;

--     -- Expected:
--     -- data_out0 = AAA
--     -- data_out1 = BBB
--     -- data_out2 = CCC
--     -- data_out3 = DDD
--     -- data_out4 = EEE



--     ------------------------------------------------------------------
--     -- FINISH
--     ------------------------------------------------------------------

--     wait;

-- end process;

end sim;
