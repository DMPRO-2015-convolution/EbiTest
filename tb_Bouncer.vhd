LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_Bouncer IS
END tb_Bouncer;
 
ARCHITECTURE behavior OF tb_Bouncer IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Bouncer
    PORT(
         data_in : INOUT  std_logic_vector(15 downto 0);
         write_enable : IN  std_logic;
         reset : IN  std_logic;
         read_enable : IN  std_logic;
         leds : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal write_enable : std_logic := '0';
   signal reset : std_logic := '0';
   signal read_enable : std_logic := '0';

	--BiDirs
   signal data_in : std_logic_vector(15 downto 0);

 	--Outputs
   signal leds : std_logic_vector(3 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Bouncer PORT MAP (
          data_in => data_in,
          write_enable => write_enable,
          reset => reset,
          read_enable => read_enable,
          leds => leds
        );


   -- Stimulus process
   stim_proc: process
   begin
		write_enable <= '1';
		read_enable <= '1';
      wait for 10 ns;

		-- write some data
		for i in 0 to 100 loop
			data_in <= std_logic_vector(to_unsigned(i, 16));
			wait for 1 ns;
			write_enable <= '0';
			wait for 10 ns;
			write_enable <= '1';
			wait for 1 ns;
		end loop;
		
		data_in <= (others => 'Z');
		
		-- read the data
		for i in 0 to 100 loop
			wait for 1 ns;
			read_enable <= '0';
			wait for 4 ns;
			assert to_integer(unsigned(data_in)) = i
				report "Auch!"
				severity failure;
			read_enable <= '1';
			wait for 5 ns;
		end loop;
      report "DONE"
			severity failure;
   end process;

END;
