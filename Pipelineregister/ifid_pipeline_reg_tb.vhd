--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:48:22 05/05/2015
-- Design Name:   
-- Module Name:   /home/kppe15b/MIPS-Prozessor/ifid_pipeline_reg_tb.vhd
-- Project Name:  MIPS-Prozessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ifid_pipeline_reg
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
 
ENTITY ifid_pipeline_reg_tb IS
END ifid_pipeline_reg_tb;
 
ARCHITECTURE behavior OF ifid_pipeline_reg_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ifid_pipeline_reg
    PORT(
         program_counter_in : IN  std_logic_vector(31 downto 0);
         instruction_in : IN  std_logic_vector(31 downto 0);
         program_counter_out : OUT  std_logic_vector(31 downto 0);
         instruction_out : OUT  std_logic_vector(31 downto 0);
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal program_counter_in : std_logic_vector(31 downto 0) := (others => '0');
   signal instruction_in : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';

 	--Outputs
   signal program_counter_out : std_logic_vector(31 downto 0);
   signal instruction_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ifid_pipeline_reg PORT MAP (
          program_counter_in => program_counter_in,
          instruction_in => instruction_in,
          program_counter_out => program_counter_out,
          instruction_out => instruction_out,
          clk => clk
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
      program_counter_in <= x"01234567";
		instruction_in <= x"76543210";
		wait for 10 ns;
		program_counter_in <= x"AAAAAAAA";
		instruction_in <= x"00000000";
		wait for 10 ns;

      wait;
   end process;

END;
