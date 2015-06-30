--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:16:29 06/27/2015
-- Design Name:   
-- Module Name:   C:/Users/Tobias/Dropbox/TU Dresden/08_semester/Prozessorentwurf_Dateien/alu32_design/MEMWB_flush_mux_tb.vhd
-- Project Name:  alu32_design
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEMWB_flush_mux
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
 
ENTITY MEMWB_flush_mux_tb IS
END MEMWB_flush_mux_tb;
 
ARCHITECTURE behavior OF MEMWB_flush_mux_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEMWB_flush_mux
    PORT(
         flush : IN  std_logic;
         mem_to_reg_in : IN  std_logic;
         reg_write_in : IN  std_logic;
         mem_to_reg_out : OUT  std_logic;
         reg_write_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal flush : std_logic := '0';
   signal mem_to_reg_in : std_logic := '0';
   signal reg_write_in : std_logic := '0';

 	--Outputs
   signal mem_to_reg_out : std_logic;
   signal reg_write_out : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEMWB_flush_mux PORT MAP (
          flush => flush,
          mem_to_reg_in => mem_to_reg_in,
          reg_write_in => reg_write_in,
          mem_to_reg_out => mem_to_reg_out,
          reg_write_out => reg_write_out
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- insert stimulus here
		flush <= '0';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '0') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '0') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;
		
		flush <= '1';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '0') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '0') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;
		
		flush <= '0';
		mem_to_reg_in <= '0';
		reg_write_in <= '1';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '0') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '1') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;
		
		flush <= '1';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '0') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '0') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;
		
		flush <= '0';
		mem_to_reg_in <= '1';
		reg_write_in <= '0';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '1') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '0') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;
		
		flush <= '1';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '0') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '0') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;
		
		flush <= '0';
		mem_to_reg_in <= '1';
		reg_write_in <= '1';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '1') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '1') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;
		
		flush <= '1';
		WAIT FOR 1ns;
		assert (mem_to_reg_out = '0') report "mem_to_reg_out ist falsch" severity error;
		assert (reg_write_out = '0') report "reg_write_out ist falsch" severity error;
		WAIT FOR 10ns;

      wait;
   end process;

END;
