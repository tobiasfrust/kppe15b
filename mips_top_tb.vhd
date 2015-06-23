--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:04:05 06/16/2015
-- Design Name:   
-- Module Name:   C:/Users/Alex/Xilinx/SysGen/14.7/MIPS/mips_top_tb.vhd
-- Project Name:  MIPS
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mips_top
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
 
ENTITY mips_top_tb IS
END mips_top_tb;
 
ARCHITECTURE behavior OF mips_top_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mips_top
    PORT(
         instruction_in : IN  std_logic_vector(31 downto 0);
         clk_in : IN  std_logic;
         rst_in : IN  std_logic;
         pc_inc_in : IN  std_logic_vector(31 downto 0);
         pc_src : OUT  std_logic;
         wb_dat_in : IN  std_logic_vector(31 downto 0);
         wb_ack_in : IN  std_logic;
         wb_adr_out : OUT  std_logic_vector(31 downto 0);
         wb_dat_out : OUT  std_logic_vector(31 downto 0);
         wb_we_out : OUT  std_logic;
         wb_sel_out : OUT  std_logic_vector(3 downto 0);
         wb_strobe_out : OUT  std_logic;
         wb_cyc_out : OUT  std_logic;
			--############################################
			--#	testbench signale
			--############################################	
			test_write_data_in : out std_logic_vector(31 downto 0);
			test_write_address_in : out std_logic_vector(4 downto 0);
			test_reg_write : out std_logic);
    END COMPONENT;
    

   --Inputs
   signal instruction_in : std_logic_vector(31 downto 0) := (others => '0');
   signal clk_in : std_logic := '0';
   signal rst_in : std_logic := '0';
   signal pc_inc_in : std_logic_vector(31 downto 0) := (others => '0');
   signal wb_dat_in : std_logic_vector(31 downto 0) := (others => '0');
   signal wb_ack_in : std_logic := '0';

 	--Outputs
   signal pc_src : std_logic;
   signal wb_adr_out : std_logic_vector(31 downto 0);
   signal wb_dat_out : std_logic_vector(31 downto 0);
   signal wb_we_out : std_logic;
   signal wb_sel_out : std_logic_vector(3 downto 0);
   signal wb_strobe_out : std_logic;
   signal wb_cyc_out : std_logic;
	
	--############################################
	--#	testbench signale
	--############################################	
	signal test_write_data_in : std_logic_vector(31 downto 0);
	signal test_write_address_in : std_logic_vector(4 downto 0);
	signal test_reg_write : std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mips_top PORT MAP (
          instruction_in => instruction_in,
          clk_in => clk_in,
          rst_in => rst_in,
          pc_inc_in => pc_inc_in,
          pc_src => pc_src,
          wb_dat_in => wb_dat_in,
          wb_ack_in => wb_ack_in,
          wb_adr_out => wb_adr_out,
          wb_dat_out => wb_dat_out,
          wb_we_out => wb_we_out,
          wb_sel_out => wb_sel_out,
          wb_strobe_out => wb_strobe_out,
          wb_cyc_out => wb_cyc_out,
			 test_write_address_in => test_write_address_in,
			 test_write_data_in => test_write_data_in,
			 test_reg_write => test_reg_write
        );

   -- Clock process definitions
   clk_in_process :process
   begin
		clk_in <= '1';
		wait for clk_in_period/2;
		clk_in <= '0';
		wait for clk_in_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
		--variablen fuer R befehle
		variable opcode : std_logic_vector (5 downto 0);
		variable rs : std_logic_vector (4 downto 0);
		variable rt : std_logic_vector (4 downto 0);
		variable rd : std_logic_vector (4 downto 0);
		variable shamt : std_logic_vector (4 downto 0);
		variable funct : std_logic_vector (5 downto 0);
		
		--zusatz fuer immediate
		variable immediate: std_logic_vector (15 downto 0);
		
		--zusatz fr jump
		variable address : std_logic_vector (25 downto 0);
   begin		
      -- hold reset state for 100 ns.
		rst_in <= '1';
      wait for 100 ns;
		rst_in <= '0';		
		
--		  ___                        _  _        _          ___        __       _     _      
--		 |_ _| _ __   _ __   ___  __| |(_) __ _ | |_  ___  | _ ) ___  / _| ___ | |_  | | ___ 
--		  | | | '  \ | '  \ / -_)/ _` || |/ _` ||  _|/ -_) | _ \/ -_)|  _|/ -_)| ' \ | |/ -_)
--		 |___||_|_|_||_|_|_|\___|\__,_||_|\__,_| \__|\___| |___/\___||_|  \___||_||_||_|\___|
		
		--#############################################
		--# ADDI test Takt1
		--#############################################
		opcode		:= "001000";			--addi
		rs 			:= "00000";				--operand 1
		rt				:= "00001";				--soll in register 1
		immediate	:= x"ABCD";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		wait until rising_edge(clk_in);
		--#############################################
		--# ADDIU test Takt2
		--#############################################
		--TODO: guten Testcase ausdenken
		opcode		:= "001001";			--addiu
		rs 			:= "00000";				--operand 1
		rt				:= "00010";				--soll in register 2
		immediate	:= x"EBCD";
		
		instruction_in <= opcode & rs & rt & immediate;	
		wait until rising_edge(clk_in);
		--#############################################
		--# SLTI Test 1 Takt3
		--#############################################
		opcode		:= "001010";			--slti
		rs 			:= "00000";				--operand 1
		rt				:= "00011";				--soll in register 3
		immediate	:= x"EBCD";
		
		instruction_in <= opcode & rs & rt & immediate;	
		wait until rising_edge(clk_in);
		--#############################################
		--# SLTI Test 2 Takt4
		--#############################################
		opcode		:= "001010";			--slti
		rs 			:= "00000";				--operand 1
		rt				:= "00100";				--soll in register 4
		immediate	:= x"0000";
		
		instruction_in <= opcode & rs & rt & immediate;	
		wait until rising_edge(clk_in);
		--#############################################
		--# ANDII Test 1 Takt 5
		--#############################################
		opcode		:= "001100";			--andi
		rs 			:= "00001";				--operand 1
		rt				:= "00101";				--soll in register 5
		immediate	:= x"1111";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		wait for 2 ns;
		assert test_write_address_in = "00001" report "Adresse falsch angelegt!, ADDI" severity error;
		assert test_write_data_in = x"FFFFABCD" report "Falsches Datum berechnet!, ADDI" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, ADDI" severity error;

		wait until rising_edge(clk_in);
		--#############################################
		--# ANDII Test 1 Takt 6
		--#############################################
		opcode		:= "001100";			--andi
		rs 			:= "00001";				--operand 1
		rt				:= "00110";				--soll in register 6
		immediate	:= x"0000";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		wait for 2 ns;
		assert test_write_address_in = "00010" report "Adresse falsch angelegt!, ADDIU" severity error;
		assert test_write_data_in = x"FFFFEBCD" report "Falsches Datum berechnet!, ADDIU" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, ADDIU" severity error;
		
		wait until rising_edge(clk_in);
		--#############################################
		--# ORI Test 1 Takt 7
		--#############################################
		opcode		:= "001101";			--ori
		rs 			:= "00001";				--operand 1
		rt				:= "00111";				--soll in register 7
		immediate	:= x"0000";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		wait for 2 ns;
		assert test_write_address_in = "00011" report "Adresse falsch angelegt!, SLTI" severity error;
		assert test_write_data_in = x"00000000" report "Falsches Datum berechnet!, SLTI" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SLTI" severity error;
		
		wait until rising_edge(clk_in);
		--#############################################
		--# ORI Test 1 Takt 8
		--#############################################
		opcode		:= "001101";			--ori
		rs 			:= "00001";				--operand 1
		rt				:= "01000";				--soll in register 8
		immediate	:= x"FFFF";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		wait for 2 ns;
		assert test_write_address_in = "00100" report "Adresse falsch angelegt!, SLTI" severity error;
		assert test_write_data_in = x"00000000" report "Falsches Datum berechnet!, SLTI" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SLTI" severity error;
		
		wait until rising_edge(clk_in);
		--#############################################
		--# XORI Test 1 Takt 9
		--#############################################
		opcode		:= "001110";			--ori
		rs 			:= "00001";				--operand 1
		rt				:= "01001";				--soll in register 9
		immediate	:= x"0000";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		wait for 2 ns;
		assert test_write_address_in = "00101" report "Adresse falsch angelegt!, ANDI" severity error;
		assert test_write_data_in = (x"00001111" and x"ffffabcd") report "Falsches Datum berechnet!, ANDI" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, ANDI" severity error;
		
		wait until rising_edge(clk_in);
		--#############################################
		--# XORI Test 2 Takt 10
		--#############################################
		opcode		:= "001110";			--ori
		rs 			:= "00001";				--operand 1
		rt				:= "01010";				--soll in register 10
		immediate	:= x"FFFF";
		
		instruction_in <= opcode & rs & rt & immediate;	
		wait until rising_edge(clk_in);
		--#############################################
		--# SLL Test 2 Takt 11
		--#############################################
		opcode		:= "000000";			--ori
		rs 			:= "00000";				--operand 1
		rt				:= "00001";				
		rd          := "01011";
		shamt       := "00001";
		funct       := "000000";
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;	
		wait until rising_edge(clk_in);
--		--#############################################
--		--# load upper immediate test
--		--#############################################
--		opcode		:= "001111";			--lui
--		rs 			:= "00000";				--nicht genutzt
--		rt				:= "00001";				--soll in register 1
--		immediate	:= x"ABCD";
--		
--		instruction_in <= opcode & rs & rt & immediate;	
--		
--		--4 mal nop ()
--		wait for 10 ns;
--		instruction_in <= x"00000000";
--		wait for 10 ns;
--		instruction_in <= x"00000000";
--		wait for 10 ns;
--		instruction_in <= x"00000000";
--		wait for 10 ns;
--		instruction_in <= x"00000000";
		
		--assert

      wait;
   end process;

END;
