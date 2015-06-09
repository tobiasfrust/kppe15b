--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:38:24 05/01/2015
-- Design Name:   
-- Module Name:   C:/Users/Alex/Xilinx/SysGen/14.7/Regfile_test/register_file_tb.vhd
-- Project Name:  Regfile_test
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
use IEEE.NUMERIC_STD.ALL;
 
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
         clk : IN  std_logic;
         reg_write_in : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal read_address1 : std_logic_vector(4 downto 0) := (others => '0');
   signal read_address2 : std_logic_vector(4 downto 0) := (others => '0');
   signal write_address : std_logic_vector(4 downto 0) := (others => '0');
   signal write_data : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal reg_write : std_logic := '0';

 	--Outputs
   signal read_data1 : std_logic_vector(31 downto 0);
   signal read_data2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          read_address1_in => read_address1,
          read_address2_in => read_address2,
          write_address_in => write_address,
          write_data_in => write_data,
          read_data1_out => read_data1,
          read_data2_out => read_data2,
          clk => clk,
          reg_write_in => reg_write
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
      -- insert stimulus here
		wait for 5 ns;
		
		read_address1 <= "00010";
		read_address2 <= "00010";
		--############################################# Forwarding/Bypassing Test
		write_data <= x"FFFFFFFF";
		write_address <= "00010";
		reg_write <= '1';
		
		wait for 1 ps;		
		assert (read_data1 = x"FFFFFFFF") report "Forwarding/Bypassing funktioniert nicht" severity error;
		assert (read_data2 = x"FFFFFFFF") report "Forwarding/Bypassing funktioniert nicht" severity error;
		
		wait for 10 ns;
		
		reg_write <= '0';		
		
		wait for 10 ns;
		
		write_data <= x"AAAAAAAA";
		write_address <= "00010";
		reg_write <= '1';
		
		
		-- Mit Forwarding/Bypassing sollte der geschriebene Wert gleich am Ausgang erscheinen
		wait for 1 ps;
		assert (read_data1 = x"AAAAAAAA") report "Forwarding/Bypassing funktioniert nicht" severity error;
		assert (read_data2 = x"AAAAAAAA") report "Forwarding/Bypassing funktioniert nicht" severity error;		
				
		--############################################# Ende: Forwarding/Bypassing Test

		wait for 10 ns;
		
		--############################################# Register 0 Test
		
		write_data <= x"AAAAFFFF";
		write_address <= "00000";
		reg_write <= '1';
		
		wait for 10 ns;
		
		reg_write <= '0';				
		read_address1 <= "00000";
		read_address2 <= "00000";
		
		wait for 10 ns;
		
		assert (read_data1 = x"00000000") report "Bei Zugriff auf Register 0 muss 0 gelesen werden" severity error;
		assert (read_data2 = x"00000000") report "Bei Zugriff auf Register 0 muss 0 gelesen werden" severity error;
		
		--############################################# Ende: Register 0 Test	
      wait;
   end process;

END;
