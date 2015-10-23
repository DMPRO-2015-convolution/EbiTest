library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EBI_interface is
    Port(
        data_in : inout std_logic_vector (15 downto 0);
        write_enable : in std_logic;
        reset : in std_logic;
        clk : in std_logic;
        read_enable : in std_logic;

        leds : out std_logic_vector(3 downto 0)
    );
    
end EBI_interface;

architecture Behavioral of EBI_interface is
    signal wr_clk, wr_en, rd_en, full, empty, valid : std_logic;
    signal dout, din : std_logic_vector(15 downto 0);
    signal counter : unsigned(15 downto 0);
    signal r_led_d5, r_led_d4, r_led_d2, r_led_d1 : std_logic;
    signal counter2 : unsigned(15 downto 0);
begin

queue: entity work.fifo_generator_v6_2 Port map (
    wr_clk => not write_enable,
    rd_clk => clk,
    din => data_in,
    wr_en => '1',
    rd_en => '1',
    dout => dout,
    full => open,
    empty => empty,
    valid => valid
    );

    data_in <= "0011001101011010" when read_enable = '0' else (others => 'Z');

    test: process(clk, valid)
    begin
		if (reset = '1') then
			counter <= (others => '0');
		elsif(rising_edge(clk) and valid = '1') then
--            r_led_d5 <= dout(0);
--				r_led_d4 <= dout(1);
--				r_led_d2 <= dout(2);
--				r_led_d1 <= dout(3);
--
--            if r_led_d4 = '1' then
--                r_led_d4 <= '0';
--            else 
--                r_led_d4 <= '1';
--            end if;
				if unsigned(dout) = 0 then
					counter <= (0 => '1', others => '0');
--					r_led_d1 <= '1';
				else
--					r_led_d1 <= '0';
					if(counter = unsigned(dout)) then
						counter <= counter + 1;
						r_led_d5 <= '1';
						r_led_d4 <= '0';
					else
						r_led_d5 <= '0';
						r_led_d4 <= '1';
					end if;
				end if;
        end if;
    end process;
    
    test2: process(clk, valid)    
    begin
    if(rising_edge(clk) and rd_en = '1') then
        --data_in <= "0011001101011010";
    end if;
    end process;
    
    leds(0) <= r_led_d5; --d5
    leds(1) <= r_led_d4; --d4
    leds(2) <= dout(7); --d2
    leds(3) <= dout(15);--d1
    
end Behavioral;








