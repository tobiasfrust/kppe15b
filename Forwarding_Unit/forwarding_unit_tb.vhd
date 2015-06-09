--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:50:11 06/02/2015
-- Design Name:   
-- Module Name:   /home/kppe15b/MIPS-Prozessor/forwarding_unit_tb.vhd
-- Project Name:  MIPS-Prozessor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: forwarding_unit
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
 
ENTITY forwarding_unit_tb IS
END forwarding_unit_tb;
 
ARCHITECTURE behavioural OF forwarding_unit_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT forwarding_unit
    PORT(
         EXMEM_reg_write : IN  std_logic;
         MEMWB_reg_write : IN  std_logic;
         EXMEM_adressRd : IN  std_logic_vector(31 downto 0);
         MEMWB_adressRd : IN  std_logic_vector(31 downto 0);
         IDEX_adressRs : IN  std_logic_vector(31 downto 0);
         IDEX_adressRt : IN  std_logic_vector(31 downto 0);
         forward_Rs : OUT  std_logic_vector(1 downto 0);
         forward_Rt : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal EXMEM_reg_write : std_logic := '0';
   signal MEMWB_reg_write : std_logic := '0';
   signal EXMEM_adressRd : std_logic_vector(31 downto 0) := (others => '0');
   signal MEMWB_adressRd : std_logic_vector(31 downto 0) := (others => '0');
   signal IDEX_adressRs : std_logic_vector(31 downto 0) := (others => '0');
   signal IDEX_adressRt : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal forward_Rs : std_logic_vector(1 downto 0);
   signal forward_Rt : std_logic_vector(1 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: forwarding_unit PORT MAP (
          EXMEM_reg_write => EXMEM_reg_write,
          MEMWB_reg_write => MEMWB_reg_write,
          EXMEM_adressRd => EXMEM_adressRd,
          MEMWB_adressRd => MEMWB_adressRd,
          IDEX_adressRs => IDEX_adressRs,
          IDEX_adressRt => IDEX_adressRt,
          forward_Rs => forward_Rs,
          forward_Rt => forward_Rt
        );

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- initial values
		EXMEM_reg_write	<=		'0';
      MEMWB_reg_write	<=		'0';
      EXMEM_adressRd		<=		x"00000000";
      MEMWB_adressRd		<=		x"00000001";
		IDEX_adressRs		<=		x"00000010";
		IDEX_adressRt		<=		x"00000100";
	  WAIT FOR 10ns;
     
	-- create stimuli
	  WAIT FOR 1ns;
	  assert (forward_Rs = "00") report "forward_A ist falsch" severity error;
	  assert (forward_Rt = "00") report "forward_B ist falsch" severity error;
	  WAIT FOR 10ns;
	  
	  EXMEM_adressRd <= x"00000010";
	  WAIT FOR 1ns;
	  assert (forward_Rs = "00") report "forward_A ist falsch" severity error;
	  assert (forward_Rt = "00") report "forward_B ist falsch" severity error;
	  WAIT FOR 10ns;
	  
	  EXMEM_reg_write <= '1';
	  WAIT FOR 1ns;
	  assert (forward_Rs = "01") report "forward_A ist falsch" severity error;
	  assert (forward_Rt = "00") report "forward_B ist falsch" severity error;
	  WAIT FOR 10ns;
	  
	  MEMWB_reg_write <= '1';
	  EXMEM_reg_write <= '0';
	  WAIT FOR 1ns;
	  assert (forward_Rs = "10") report "forward_A ist falsch" severity error;
	  assert (forward_Rt = "00") report "forward_B ist falsch" severity error;
	  WAIT FOR 10ns;
	  
	  EXMEM_reg_write <= '1';
	  WAIT FOR 1ns;
	  assert (forward_Rs = "01") report "forward_A ist falsch" severity error;
	  assert (forward_Rt = "00") report "forward_B ist falsch" severity error;
	  WAIT FOR 10ns;
	  
	  
	  
	  
	  
	  
--	  EXMEM_adressRd <= x"00000100";
--	  WAIT FOR 1ns;
--	  assert (forward_Rs = "00") report "forward_A ist falsch" severity error;
--	  assert (forward_Rt = "00") report "forward_B ist falsch" severity error;
--	  
--	  EXMEM_reg_write	<=		'1';
--	  WAIT FOR 1ns;
--	  assert (forward_Rs = "01") report "forward_A ist falsch" severity error;
--	  assert (forward_Rt = "00") report "forward_B ist falsch" severity error;
	  
	   wait;
   end process;

END behavioural;
