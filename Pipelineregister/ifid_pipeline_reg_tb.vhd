--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:12:39 06/15/2015
-- Design Name:   
-- Module Name:   C:/Users/Alex/Xilinx/SysGen/14.7/MIPS/ifid_pipeline_reg_tb.vhd
-- Project Name:  MIPS
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
         clk_in : IN  std_logic;
         pipeline_en_in : IN  std_logic;
         program_counter_out : OUT  std_logic_vector(31 downto 0);
         instruction_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal program_counter_in : std_logic_vector(31 downto 0) := (others => '0');
   signal instruction_in : std_logic_vector(31 downto 0) := (others => '0');
   signal clk_in : std_logic := '0';
   signal pipeline_en_in : std_logic := '0';

 	--Outputs
   signal program_counter_out : std_logic_vector(31 downto 0);
   signal instruction_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ifid_pipeline_reg PORT MAP (
          program_counter_in => program_counter_in,
          instruction_in => instruction_in,
          clk_in => clk_in,
          pipeline_en_in => pipeline_en_in,
          program_counter_out => program_counter_out,
          instruction_out => instruction_out
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
      -- hold reset state for 100 ns.
		
		pipeline_en_in <= '1';
      wait for 100 ns;
		
		--#####################################
		--# pipeline enabled test
		--#####################################
		
		program_counter_in		<= x"AAAAAAAA";
		instruction_in				<= x"BBBBBBBB";
		
		wait for 11 ns;
		
		assert program_counter_out = x"AAAAAAAA" report "pipeline enabled test failed" severity error;
		assert instruction_out		= x"BBBBBBBB" report "pipeline enabled test failed" severity error;		
		
		wait until rising_edge(clk_in);

		--#####################################
		--# pipeline disabled test
		--#####################################

		program_counter_in		<= x"CCCCCCCC";
		instruction_in				<= x"DDDDDDDD";
		pipeline_en_in				<= '0';
		
		wait for 11 ns;
		
		assert program_counter_out = x"AAAAAAAA" report "pipeline disabled test failed" severity error;
		assert instruction_out		= x"BBBBBBBB" report "pipeline disabled test failed" severity error;
		
		wait until rising_edge(clk_in);
		
		wait for 15 ns;
		pipeline_en_in				<= '1';
		
		wait until rising_edge(clk_in);
		wait for 1 ns;
		
		assert program_counter_out = x"CCCCCCCC" report "pipeline disabled test failed" severity error;
		assert instruction_out		= x"DDDDDDDD" report "pipeline disabled test failed" severity error;
		

      wait;
   end process;

END;
