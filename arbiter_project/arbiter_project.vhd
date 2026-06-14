library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity arbiter_project is
	
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
	

end entity;


architecture arch of arbiter_project is
	
	component single_arbiter 
		port(
		clk, reset : in std_logic;
		-- all of the requests to the output 
		req : in std_logic_vector(4 downto 0);

		-- the winner input which gets this input.
		grant : out std_logic_vector(4 downto 0)
		);
	end component;


	-- all of the requests to a single output
	signal req_out0, req_out1, req_out2, req_out3, req_out4 : std_logic_vector(4 downto 0);
	-- the winner input which gets the output 
	signal grant_out0, grant_out1, grant_out2, grant_out3, grant_out4 : std_logic_vector(4 downto 0);
	-- 
	signal final_grant_comb : std_logic_vector(4 downto 0);

begin

	data_out0 <= data_in0; 
	data_out1 <= data_in1; 
	data_out2 <= data_in2; 
	data_out3 <= data_in3; 
	data_out4 <= data_in4; 

	-- data_out0 <= data_in0 when final_grant_comb(0)='1'
    --          else (others=>'0');

	-- data_out1 <= data_in1 when final_grant_comb(1)='1'
	-- 			else (others=>'0');

	-- data_out2 <= data_in2 when final_grant_comb(2)='1'
	-- 			else (others=>'0');

	-- data_out3 <= data_in3 when final_grant_comb(3)='1'
	-- 			else (others=>'0');

	-- data_out4 <= data_in4 when final_grant_comb(4)='1'
	-- 			else (others=>'0');
					

	process(req0,req1,req2,req3,req4,out0,out1,out2,out3,out4)
	begin
		req_out0 <= (others => '0');
		req_out1 <= (others => '0');
		req_out2 <= (others => '0');
		req_out3 <= (others => '0');
		req_out4 <= (others => '0');

		-- for input number 0
		if req0 = '1' then
			case out0 is
				when "000" =>
					req_out0(0) <= '1';
				when "001" =>
					req_out1(0) <= '1';
				when "010" =>
					req_out2(0) <= '1';
				when "011" =>
					req_out3(0) <= '1';
				when others =>
					req_out4(0) <= '1';
			end case;
		end if;


		-- for input number 1
		if req1 = '1' then
			case out1 is
				when "000" =>
					req_out0(1) <= '1';
				when "001" =>
					req_out1(1) <= '1';
				when "010" =>
					req_out2(1) <= '1';
				when "011" =>
					req_out3(1) <= '1';
				when others =>
					req_out4(1) <= '1';
			end case;
		end if;


		-- for input number 2
		if req2 = '1' then
			case out2 is
				when "000" =>
					req_out0(2) <= '1';
				when "001" =>
					req_out1(2) <= '1';
				when "010" =>
					req_out2(2) <= '1';
				when "011" =>
					req_out3(2) <= '1';
				when others =>
					req_out4(2) <= '1';
			end case;
		end if;


		-- for input number 3
		if req3 = '1' then
			case out3 is
				when "000" =>
					req_out0(3) <= '1';
				when "001" =>
					req_out1(3) <= '1';
				when "010" =>
					req_out2(3) <= '1';
				when "011" =>
					req_out3(3) <= '1';
				when others =>
					req_out4(3) <= '1';
			end case;
		end if;


		-- for input number 4
		if req4 = '1' then
			case out4 is
				when "000" =>
					req_out0(4) <= '1';
				when "001" =>
					req_out1(4) <= '1';
				when "010" =>
					req_out2(4) <= '1';
				when "011" =>
					req_out3(4) <= '1';
				when others =>
					req_out4(4) <= '1';
			end case;
		end if;

	end process;

	-- deciding for output number #0
	arb0 : single_arbiter 
	port map(
	clk => clk,
	reset => reset,
 	req => req_out0,
	grant => grant_out0
	);

	-- deciding for output number #1
	arb1 : single_arbiter 
	port map(
	clk => clk,
	reset => reset,
 	req => req_out1,
	grant => grant_out1
	);

	-- deciding for output number #2
	arb2 : single_arbiter 
	port map(
	clk => clk,
	reset => reset,
 	req => req_out2,
	grant => grant_out2
	);


	-- deciding for output number #3
	arb3 : single_arbiter 
	port map(
	clk => clk,
	reset => reset,
 	req => req_out3,
	grant => grant_out3
	);


	-- deciding for output number #4
	arb4 : single_arbiter 
	port map(
	clk => clk,
	reset => reset,
 	req => req_out4,
	grant => grant_out4
	);

	final_grant_comb <= grant_out0 or grant_out1 or grant_out2 or grant_out3 or grant_out4;

	g0 <= final_grant_comb(0);
	g1 <= final_grant_comb(1);
	g2 <= final_grant_comb(2);
	g3 <= final_grant_comb(3);
	g4 <= final_grant_comb(4);


	-- setting wr_req signals.
	-- process(credit_in, final_grant_comb)
	-- begin
	-- 	if credit_in(0) = '1' and grant_out0 /= "00000" then
	-- 		wr_req0 <= '1';
	-- 	else 
	-- 		wr_req0 <= '0';
	-- 	end if;

	-- 	if credit_in(1) = '1' and grant_out1 /= "00000" then
	-- 		wr_req1 <= '1';
	-- 	else 
	-- 		wr_req1 <= '0';
	-- 	end if;

	-- 	if credit_in(2) = '1' and grant_out2 /= "00000" then
	-- 		wr_req2 <= '1';
	-- 	else 
	-- 		wr_req2 <= '0';
	-- 	end if;

	-- 	if credit_in(3) = '1' and grant_out3 /= "00000" then
	-- 		wr_req3 <= '1';
	-- 	else 
	-- 		wr_req3 <= '0';
	-- 	end if;

	-- 	if credit_in(4) = '1' and grant_out4 /= "00000" then
	-- 		wr_req4 <= '1';
	-- 	else 
	-- 		wr_req4 <= '0';
	-- 	end if;

	-- end process;

-- 	process(clk, reset)
-- begin
--     if reset='1' then
--         wr_req0 <= '0';
--         wr_req1 <= '0';
--         wr_req2 <= '0';
--         wr_req3 <= '0';
--         wr_req4 <= '0';

--     elsif rising_edge(clk) then

-- 		if credit_in(0) = '1' and req_out0 /= "00000" then
-- 			wr_req0 <= '1';
-- 		else 
-- 			wr_req0 <= '0';
-- 		end if;

-- 		if credit_in(1) = '1' and req_out1 /= "00000" then
-- 			wr_req1 <= '1';
-- 		else 
-- 			wr_req1 <= '0';
-- 		end if;

-- 		if credit_in(2) = '1' and req_out2 /= "00000" then
-- 			wr_req2 <= '1';
-- 		else 
-- 			wr_req2 <= '0';
-- 		end if;

-- 		if credit_in(3) = '1' and req_out3 /= "00000" then
-- 			wr_req3 <= '1';
-- 		else 
-- 			wr_req3 <= '0';
-- 		end if;

-- 		if credit_in(4) = '1' and req_out4 /= "00000" then
-- 			wr_req4 <= '1';
-- 		else 
-- 			wr_req4 <= '0';
-- 		end if;
 
--     end if;
-- end process;


	process(credit_in, grant_out0, grant_out1, grant_out2, grant_out3, grant_out4)
	begin
			if credit_in(0) = '1' and grant_out0 /= "00000"   then
				wr_req0 <= '1';
			else 
				wr_req0 <= '0';
			end if;

			if credit_in(1) = '1' and grant_out1 /= "00000"   then
				wr_req1 <= '1';
			else 
				wr_req1 <= '0';
			end if;

			if credit_in(2) = '1' and grant_out2 /= "00000"   then
				wr_req2 <= '1';
			else 
				wr_req2 <= '0';
			end if;

			if credit_in(3) = '1' and grant_out3 /= "00000"   then
				wr_req3 <= '1';
			else 
				wr_req3 <= '0';
			end if;

			if credit_in(4) = '1' and grant_out4 /= "00000"   then
				wr_req4 <= '1';
			else 
				wr_req4 <= '0';
			end if;
	end process;


	
	process(out0,out1,out2,out3,out4, final_grant_comb)
	begin
		slct0 <= "XX";
		slct1 <= "XX";
		slct2 <= "XX";
		slct3 <= "XX";
		slct4 <= "XX";

		if (final_grant_comb(0) = '1') then
			case out0 is -- 0 -> ?
					when "001" => slct1 <= "00";
					when "010" => slct2 <= "01";
					when "011" => slct3 <= "10";
					when "100" => slct4 <= "11"; 
					when others => null;
			end case;
		end if;

		if (final_grant_comb(1) = '1') then 
			case out1 is -- 1 -> ?
				when "000" => slct0 <= "11";
				when "010" => slct2 <= "00";
				when "011" => slct3 <= "01";
				when "100" => slct4 <= "10"; 
				when others => null;
			end case;
		end if;

		if (final_grant_comb(2) = '1') then 
			case out2 is -- 2 -> ?
				when "001" => slct1 <= "11";
				when "000" => slct0 <= "10";
				when "011" => slct3 <= "00";
				when "100" => slct4 <= "01"; 
				when others => null;
			end case;
		end if;

		if (final_grant_comb(3) = '1') then 
			case out3 is -- 3 -> ?
				when "001" => slct1 <= "10";
				when "010" => slct2 <= "11";
				when "000" => slct0 <= "01";
				when "100" => slct4 <= "00"; 
				when others => null;
			end case;
		end if;

		if (final_grant_comb(4) = '1') then 
			case out4 is 
				when "001" => slct1 <= "01";
				when "010" => slct2 <= "10";
				when "011" => slct3 <= "11";
				when "000" => slct0 <= "00"; 
				when others => null;
			end case;
		end if;


	end process;
	 

end arch;
