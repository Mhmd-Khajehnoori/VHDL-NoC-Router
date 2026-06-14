library ieee;
use ieee.std_logic_1164.all;

entity CrossbarSwitch is
	port( i0,i1,i2,i3,i4 : in std_logic_vector(11 downto 0); 
	slct0, slct1, slct2, slct3, slct4 : in std_logic_vector(1 downto 0); 
	o0,o1,o2,o3,o4 : out std_logic_vector(11 downto 0) 
	);
end entity;

architecture arch of CrossbarSwitch is  
	begin 
	with slct0 select 
	      	o0 <= i1 when "11",
	      	      i2 when "10",
	      	      i3 when "01",
	      	      i4 when "00",
              	  (others => 'X') when others;

	with slct1 select
	     	o1 <= i0 when "00",
		      i4 when "01",
		      i3 when "10",
		      i2 when "11",
		      (others => 'X') when others;

	with slct2 select
	     	o2 <= i1 when "00",
		      i0 when "01",
		      i4 when "10",
		      i3 when "11",
		      (others => 'X') when others;

	with slct3 select
	     	o3 <= i2 when "00",
		      i1 when "01",
		      i0 when "10",
		      i4 when "11",
		      (others => 'X') when others;

	with slct4 select
	     	o4 <= i3 when "00",
		      i2 when "01",
		      i1 when "10",
		      i0 when "11",
		      (others => 'X') when others;
		
end arch;
	
