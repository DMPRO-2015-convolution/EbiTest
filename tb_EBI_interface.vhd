LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_EBI_interface IS
END tb_EBI_interface;
 
ARCHITECTURE behavior OF tb_EBI_interface IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EBI_interface
    PORT(
         data_in : INOUT  std_logic_vector(15 downto 0);
         write_enable : IN  std_logic;
         reset : IN  std_logic;
         clk : IN  std_logic;
         read_enable : IN  std_logic;
         leds : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal write_enable : std_logic := '0';
   signal reset : std_logic := '0';
   signal clk : std_logic := '0';
   signal read_enable : std_logic := '0';

	--BiDirs
   signal data_in : std_logic_vector(15 downto 0);

 	--Outputs
   signal leds : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EBI_interface PORT MAP (
          data_in => data_in,
          write_enable => write_enable,
          reset => reset,
          clk => clk,
          read_enable => read_enable,
          leds => leds
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		write_enable <= '1';
		read_enable <= '1';

      -- hold reset state for 100 ns.
		reset <= '1';
		wait for 100 ns;
		reset <= '0';

      wait for clk_period*10;

      -- insert stimulus here

	  for i in 0 to 65535 loop

		  data_in <= std_logic_vector(to_unsigned(i, 16));
		  wait for clk_period;-- - 1 ns;
		  write_enable <= '0';
		  wait for clk_period;
		  write_enable <= '1';
		  
		  wait for clk_period;-- - 7 ns;

	  end loop;

		report "done";
   end process;

END;
