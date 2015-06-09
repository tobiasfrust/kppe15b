--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:33:08 05/12/2015
-- Design Name:   
-- Module Name:   /home/kppe15b/MIPS-Prozessor/alu32_tb.vhd
-- Project Name:  MIPS-Prozessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: alu32
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
 
ENTITY alu32_tb IS
END alu32_tb;
 
ARCHITECTURE behavior OF alu32_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT alu32
    PORT(
         CTRL : IN  std_logic_vector(3 downto 0);
			A : IN  std_logic_vector(31 downto 0);
			B : IN  std_logic_vector(31 downto 0);
			S : OUT  std_logic_vector(31 downto 0);
			ZERO : IN  std_logic;
         COUT : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CTRL : std_logic_vector(3 downto 0) := (others => '0');
   signal A : std_logic_vector(31 downto 0) := (others => '0');
   signal B : std_logic_vector(31 downto 0) := (others => '0');
   signal ZERO : std_logic := '0';
   signal COUT : std_logic := '0';

 	--Outputs
   signal S : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: alu32 PORT MAP (
          CTRL => CTRL,
          A => A,
          B => B,
          S => S,
          ZERO => ZERO,
          COUT => COUT
        );

   -- Stimulus process
   stim_proc: process
   begin		
	-- initial values
	  A <= x"00000000";
	  B <= x"00000000";
	  CTRL <= "0000";
	  WAIT FOR 10ns;
     
	-- create stimuli
	  A <= x"000A3F6D";
	  B <= x"0006FD5A";
	  CTRL <= "0010";
	  WAIT FOR 1ns;
	  assert (S = x"00113CC7") report "Add falsch" severity error;
	  CTRL <= "0110";
	  WAIT FOR 1ns;
	  assert (S = x"000339A3") report "Sub falsch" severity error;
	  CTRL <= "0110";
	  WAIT FOR 1ns;
	  assert (S = x"000339A3") report "Sub falsch" severity error;

     

      wait;
   end process;

END;
