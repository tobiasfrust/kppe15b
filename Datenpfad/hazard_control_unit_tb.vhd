--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:17:52 06/26/2015
-- Design Name:   
-- Module Name:   C:/Users/Tobias/Dropbox/TU Dresden/08_semester/Prozessorentwurf_Dateien/alu32_design/hazard_control_unit_tb.vhd
-- Project Name:  alu32_design
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hazard_control_unit
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
 
ENTITY hazard_control_unit_tb IS
END hazard_control_unit_tb;
 
ARCHITECTURE behavior OF hazard_control_unit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hazard_control_unit
    PORT(
         EXMEM_alu_zero : IN  std_logic;
         EXMEM_branch : IN  std_logic;
         EXMEM_branch_cond : IN  std_logic;
         flush : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal EXMEM_alu_zero : std_logic := '0';
   signal EXMEM_branch : std_logic := '0';
   signal EXMEM_branch_cond : std_logic := '0';

 	--Outputs
   signal flush : std_logic;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: hazard_control_unit PORT MAP (
          EXMEM_alu_zero => EXMEM_alu_zero,
          EXMEM_branch => EXMEM_branch,
          EXMEM_branch_cond => EXMEM_branch_cond,
          flush => flush
        ); 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;

      -- insert stimulus here
		EXMEM_alu_zero			<= '0';
		EXMEM_branch			<= '0';
		EXMEM_branch_cond 	<= '0';
		WAIT FOR 1ns;
		assert (flush= '1') report "flush ist falsch" severity error;
		WAIT FOR 10ns;
		
		EXMEM_alu_zero			<= '0';
		EXMEM_branch			<= '0';
		EXMEM_branch_cond 	<= '1';
		WAIT FOR 1ns;
		assert (flush= '0') report "flush ist falsch" severity error;
		WAIT FOR 10ns;
		
		EXMEM_alu_zero			<= '0';
		EXMEM_branch			<= '1';
		EXMEM_branch_cond 	<= '0';
		WAIT FOR 1ns;
		assert (flush= '0') report "flush ist falsch" severity error;
		WAIT FOR 10ns;
		
		EXMEM_alu_zero			<= '0';
		EXMEM_branch			<= '1';
		EXMEM_branch_cond 	<= '1';
		WAIT FOR 1ns;
		assert (flush= '0') report "flush ist falsch" severity error;
		WAIT FOR 10ns;
		
		EXMEM_alu_zero			<= '1';
		EXMEM_branch			<= '0';
		EXMEM_branch_cond 	<= '0';
		WAIT FOR 1ns;
		assert (flush= '0') report "flush ist falsch" severity error;
		WAIT FOR 10ns;
		
		EXMEM_alu_zero			<= '1';
		EXMEM_branch			<= '0';
		EXMEM_branch_cond 	<= '1';
		WAIT FOR 1ns;
		assert (flush= '0') report "flush ist falsch" severity error;
		WAIT FOR 10ns;
		
		EXMEM_alu_zero			<= '1';
		EXMEM_branch			<= '1';
		EXMEM_branch_cond 	<= '0';
		WAIT FOR 1ns;
		assert (flush= '0') report "flush ist falsch" severity error;
		WAIT FOR 10ns;
		
		EXMEM_alu_zero			<= '1';
		EXMEM_branch			<= '1';
		EXMEM_branch_cond 	<= '1';
		WAIT FOR 1ns;
		assert (flush= '1') report "flush ist falsch" severity error;
		WAIT FOR 10ns;

      wait;
   end process;

END;
