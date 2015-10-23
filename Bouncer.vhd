library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Bouncer is
    Port(
        data_in : inout std_logic_vector (15 downto 0);
        write_enable : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        read_enable : in std_logic;

        leds : out std_logic_vector(3 downto 0)
    );
    
end Bouncer;

architecture Behavioral of Bouncer is
	type mem is array(1023 downto 0) of std_logic_vector(15 downto 0);
	
	signal memory : mem;
	signal write_pointer, read_pointer, next_read, next_write : natural range 0 to 1023;

begin

    --data_in <= "0011001101011010" when read_enable = '0' else (others => 'Z');

    test: process(write_enable, read_enable)
    begin
		if falling_edge(write_enable) then
			write_pointer <= next_write;
			memory(write_pointer) <= data_in;
      elsif falling_edge(read_enable) then
			read_pointer <= next_read;
			data_in <= memory(read_pointer);
		elsif rising_edge(read_enable) then
			data_in <= (others => 'Z');
		elsif rising_edge(write_enable) then
			data_in <= (others => 'Z');
		end if;
		  
    end process;
    
	 
	 next_read <= read_pointer + 1;
	 next_write <= write_pointer + 1;

    leds(0) <= '1'; --d5
    leds(1) <= '1'; --d4
    leds(2) <= '1'; --d2
    leds(3) <= '1'; --d1
    
end Behavioral;