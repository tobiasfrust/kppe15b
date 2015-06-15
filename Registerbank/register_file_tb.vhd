--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:45:39 06/15/2015
-- Design Name:   
-- Module Name:   C:/Users/Alex/Xilinx/SysGen/14.7/MIPS/register_file_tb.vhd
-- Project Name:  MIPS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY register_file_tb IS
END register_file_tb;
 
ARCHITECTURE behavior OF register_file_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         read_address1_in : IN  std_logic_vector(4 downto 0);
         read_address2_in : IN  std_logic_vector(4 downto 0);
         write_address_in : IN  std_logic_vector(4 downto 0);
         write_data_in : IN  std_logic_vector(31 downto 0);
         read_data1_out : OUT  std_logic_vector(31 downto 0);
         read_data2_out : OUT  std_logic_vector(31 downto 0);
         clk_in : IN  std_logic;
         reg_write_in : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal read_address1_in : std_logic_vector(4 downto 0) := (others => '0');
   signal read_address2_in : std_logic_vector(4 downto 0) := (others => '0');
   signal write_address_in : std_logic_vector(4 downto 0) := (others => '0');
   signal write_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal clk_in : std_logic := '0';
   signal reg_write_in : std_logic := '0';

 	--Outputs
   signal read_data1_out : std_logic_vector(31 downto 0);
   signal read_data2_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          read_address1_in => read_address1_in,
          read_address2_in => read_address2_in,
          write_address_in => write_address_in,
          write_data_in => write_data_in,
          read_data1_out => read_data1_out,
          read_data2_out => read_data2_out,
          clk_in => clk_in,
          reg_write_in => reg_write_in
        );

   -- Clock process definitions
   clk_in_process :process
   begin
		clk_in <= '0';
		wait for clk_in_period/2;
		clk_in <= '1';
		wait for clk_in_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin	
	
		-- insert stimulus here
		
		read_address1_in <= "00010";
		read_address2_in <= "00010";
		write_data_in <= x"FFFFFFFF";
		write_address_in <= "00010";
		reg_write_in <= '1';
		
		wait for 5 ns;
		
		
		--############################################# Forwarding/Bypassing Test
		write_data_in <= x"FFFFFFFF";
		write_address_in <= "00010";
		reg_write_in <= '1';
		
		wait for 1 ps;		
		assert (read_data1_out = x"FFFFFFFF") report "Forwarding/Bypassing funktioniert nicht" severity error;
		assert (read_data2_out = x"FFFFFFFF") report "Forwarding/Bypassing funktioniert nicht" severity error;
		
		wait for 10 ns;
		
		reg_write_in <= '0';		
		
		wait for 10 ns;
		
		write_data_in <= x"AAAAAAAA";
		write_address_in <= "00010";
		reg_write_in <= '1';
		
		
		-- Mit Forwarding/Bypassing sollte der geschriebene Wert gleich am Ausgang erscheinen
		wait for 1 ps;
		assert (read_data1_out = x"AAAAAAAA") report "Forwarding/Bypassing funktioniert nicht" severity error;
		assert (read_data2_out = x"AAAAAAAA") report "Forwarding/Bypassing funktioniert nicht" severity error;		
				
		--############################################# Ende: Forwarding/Bypassing Test

		wait for 10 ns;
		
		--############################################# Register 0 Test
		
		write_data_in <= x"AAAAFFFF";
		write_address_in <= "00000";
		reg_write_in <= '1';
		
		wait for 10 ns;
		
		reg_write_in <= '0';				
		read_address1_in <= "00000";
		read_address2_in <= "00000";
		
		wait for 10 ns;
		
		assert (read_data1_out = x"00000000") report "Bei Zugriff auf Register 0 muss 0 gelesen werden" severity error;
		assert (read_data2_out = x"00000000") report "Bei Zugriff auf Register 0 muss 0 gelesen werden" severity error;
		
		--############################################# Ende: Register 0 Test	
      wait;
   end process;

END;
