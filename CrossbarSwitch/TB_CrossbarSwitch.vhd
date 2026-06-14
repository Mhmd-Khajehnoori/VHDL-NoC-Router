library ieee;
use ieee.std_logic_1164.all;

entity TB_CrossbarSwitch is
end TB_CrossbarSwitch;

architecture tb_arch of TB_CrossbarSwitch is
    -- component with the same name as our main Entity.
    component CrossbarSwitch
        port(
            i0, i1, i2, i3, i4 : in std_logic_vector(11 downto 0);
            slct0, slct1, slct2, slct3, slct4 : in std_logic_vector(1 downto 0);
            o0, o1, o2, o3, o4 : out std_logic_vector(11 downto 0)
        );
    end component;

    signal i0, i1, i2, i3, i4 : std_logic_vector(11 downto 0);
    signal o0, o1, o2, o3, o4 : std_logic_vector(11 downto 0);
    signal slct0, slct1, slct2, slct3, slct4 : std_logic_vector(1 downto 0);

begin
    uut: CrossbarSwitch
        port map(
            i0 => i0, i1 => i1, i2 => i2, i3 => i3, i4 => i4,
            slct0 => slct0, slct1 => slct1, slct2 => slct2, slct3 => slct3, slct4 => slct4,
            o0 => o0, o1 => o1, o2 => o2, o3 => o3, o4 => o4
        );

    process
    begin
        --
        i0 <= "000000000000"; i1 <= "000000000001"; i2 <= "000000000011";
        i3 <= "000000000111"; i4 <= "000000001111";
        slct0 <= "00"; slct1 <= "00"; slct2 <= "00"; slct3 <= "00"; slct4 <= "00";
        wait for 10 ns;

        -- 
        slct0 <= "01"; slct1 <= "01"; slct2 <= "01"; slct3 <= "01"; slct4 <= "01";
        wait for 10 ns;

        --  
        slct0 <= "10"; slct1 <= "10"; slct2 <= "10"; slct3 <= "10"; slct4 <= "10";
        wait for 10 ns;

        --  
        slct0 <= "11"; slct1 <= "11"; slct2 <= "11"; slct3 <= "11"; slct4 <= "11";
        wait for 10 ns;

        wait;
    end process;
end tb_arch;