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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;
use work.mips.all;

 
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
	  A <= x"00000011";
	  B <= x"00000001";
	  
	  
	  
	  
--	  CTRL <= "0010";
--	  WAIT FOR 1ns;
--	  assert (S = x"00113CC7") report "Add falsch" severity error;
--	  CTRL <= "0110";
--	  WAIT FOR 1ns;
--	  assert (S = x"000339A3") report "Sub falsch" severity error;
--	  CTRL <= "0110";
--	  WAIT FOR 1ns;
--	  assert (S = x"000339A3") report "Sub falsch" severity error;





     CTRL <= ALU_CMD_AND;
	  WAIT FOR 1ns;
	  assert (S = x"00000001") report "AND falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
     CTRL <= ALU_CMD_OR;
	  WAIT FOR 1ns;
	  assert (S = x"00000011") report "OR falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  CTRL <= ALU_CMD_XOR;
	  WAIT FOR 1ns;
	  assert (S = x"00000010") report "XOR falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  CTRL <= ALU_CMD_ADDU;
	  WAIT FOR 1ns;
	  assert (S = x"00000100") report "ADDUfalsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  CTRL <= ALU_CMD_SUBU;
	  WAIT FOR 1ns;
	  assert (S = x"00000010") report "SUBU falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
     CTRL <= ALU_CMD_NOR;
	  WAIT FOR 1ns;
	  assert (S = x"11111100") report "NOR falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  CTRL <= ALU_CMD_LUI;
	  WAIT FOR 1ns;
	  assert (S = x"00010000") report "LUI falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;	  
	  
	  A <= x"00000001";
	  B <= x"00000011";
     CTRL <= ALU_CMD_SLTU;
	  WAIT FOR 1ns;
	  assert (S = x"00000001") report "SLTU falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  	  
	  A <= x"00000001";
	  B <= x"80000001";
	  CTRL <= ALU_CMD_ADD;
	  WAIT FOR 1ns;
	  assert (S = x"00000000") report "ADD falsch" severity error;
	  assert (ZERO = '1') report "Zero-Flag funktioniert nicht" severity error;
	  CTRL <= ALU_CMD_SUB;
	  WAIT FOR 1ns;
	  assert (S = x"00000010") report "SUB falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  
	  A <= x"00000010";
	  B <= x"00000100";
	  CTRL <= ALU_CMD_SLL;
	  WAIT FOR 1ns;
	  assert (S = x"00000100") report "SLL falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
     CTRL <= ALU_CMD_SRL;
	  WAIT FOR 1ns;
	  assert (S = x"00000001") report "SRL falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  
	  A <= x"80000001";
	  B <= x"00000001";
	  CTRL <= ALU_CMD_SLT;
	  WAIT FOR 1ns;
	  assert (S = x"00000001") report "SLT falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  
	  A <= x"80000000";
	  B <= x"00000100";
	  CTRL <= ALU_CMD_SRA;
	  WAIT FOR 1ns;
	  assert (S = x"F8000000") report "SRA falsch" severity error;
	  assert (ZERO = '0') report "Zero-Flag funktioniert nicht" severity error;
	  
	  
	  

      wait;
   end process;

END;
