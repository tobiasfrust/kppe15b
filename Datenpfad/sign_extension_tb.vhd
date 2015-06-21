--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:22:05 06/16/2015
-- Design Name:   
-- Module Name:   C:/Users/Alex/Xilinx/SysGen/14.7/MIPS/sign_extension_tb.vhd
-- Project Name:  MIPS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sign_extension
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
 
ENTITY sign_extension_tb IS
END sign_extension_tb;
 
ARCHITECTURE behavior OF sign_extension_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sign_extension
    PORT(
         imm : IN  std_logic_vector(15 downto 0);
         imm_ext : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal imm : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal imm_ext : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sign_extension PORT MAP (
          imm => imm,
          imm_ext => imm_ext
        );


 

   -- Stimulus process
   stim_proc: process
   begin	     
		imm <= x"FFFF";
		
		wait for 10 ns;
      assert imm_ext = x"FFFFFFFF" report "1 extend failed" severity error;
		
		
		imm <= x"0FFF";
		
		wait for 10 ns;
      assert imm_ext = x"00000FFF" report "0 extend failed" severity error;
		

      wait;
   end process;

END;
