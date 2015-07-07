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
			jump_addr_out : OUT std_logic_vector(31 downto 0);
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
	signal jump_addr_out : std_logic_vector (31 downto 0);
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
			 jump_addr_out => jump_addr_out,
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
		opcode		:= "001110";			--xori
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
		opcode		:= "001110";			--xori
		rs 			:= "00001";				--operand 1
		rt				:= "01010";				--soll in register 10
		immediate	:= x"FFFF";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		wait until rising_edge(clk_in);
--		--#############################################
--		--# SLL Test 2 Takt 11
--		--#############################################
--		opcode		:= "000000";			--ori
--		rs 			:= "00000";				--operand 1
--		rt				:= "00001";				
--		rd          := "01011";
--		shamt       := "00001";
--		funct       := "000000";
--		
--		instruction_in <= opcode & rs & rt & rd &shamt & funct;	
--		wait until rising_edge(clk_in);
--		--#############################################
--		--# load upper immediate test
--		--#############################################
		opcode		:= "001111";			--lui
		rs 			:= "00000";				--nicht genutzt
		rt				:= "11110";				--soll in register 1
		immediate	:= x"ABCD";
		
		instruction_in <= opcode & rs & rt & immediate;
--		
		--4 mal nop ()
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait for 2 ns;
		assert test_write_address_in = "11110" report "Adresse falsch angelegt!, LUI" severity error;
		assert test_write_data_in = (x"abcd0000") report "Falsches Datum berechnet!, LUI" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, LUI" severity error;
		
-- 	 ___     ___       __     _    _     
-- 	| _ \___| _ ) ___ / _|___| |_ | |___ 
-- 	|   /___| _ \/ -_)  _/ -_) ' \| / -_)
-- 	|_|_\   |___/\___|_| \___|_||_|_\___|
-- 	                               
		
		--#############################################
		--# diese TB geht davon aus, dass in den Registern bestimmt Werte schon drin stehen:
		--# Reg 1: 			FFFFABCD
		--# Reg 2: 			FFFFEBCD
		--# Reg 5: 			00000101
		--# Reg 8: 			FFFFFFFF
		--# Reg 10:			00005432
		--#############################################
		
		--#############################################
		--# ADD Test 1 Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "00101";				--quellregister: 5 (0x00000101)
		rt				:= "01010";				--quellregister: 10 (0x00005432)
		rd          := "11111";				--zielregister:31
		shamt       := "00000";				--shamt ist egal
		funct       := "100000";			--add
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;	
		wait until rising_edge(clk_in);
		
      
		--#############################################
		--# ADD Test 2 Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "00101";				--quellregister: 5 (0x00000101)
		rt				:= "00001";				--quellregister: 1 (0xFFFFABCD)
		rd          := "11110";				--zielregister:30
		shamt       := "00000";				--shamt ist egal
		funct       := "100000";			--add
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;		
		wait until rising_edge(clk_in);

		--#############################################
		--# ADDU Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "00101";				--quellregister: 5 (0x00000101)
		rt				:= "00001";				--quellregister: 1 (0xFFFFABCD)
		rd          := "11101";				--zielregister:29
		shamt       := "00000";				--shamt ist egal
		funct       := "100001";			--addu
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;		
		wait until rising_edge(clk_in);

		--#############################################
		--# SUB Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01010";				--quellregister: 10 (0x00005432)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "11100";				--zielregister:28
		shamt       := "00000";				--shamt ist egal
		funct       := "100010";			--sub
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;			
		wait until rising_edge(clk_in);	
		
		--#############################################
		--# SUBU Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "11011";				--zielregister:27
		shamt       := "00000";				--shamt ist egal
		funct       := "100011";			--subu
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;	


		--ASSERT fuer ADD Befehl 1
		wait for 2 ns;
		assert test_write_address_in = "11111" report "Adresse falsch angelegt!, ADD 1" severity error;
		assert test_write_data_in = x"00005533" report "Falsches Datum berechnet!, ADD 1" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, ADD 1" severity error;		
		wait until rising_edge(clk_in);		
		
		--#############################################
		--# AND Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "11010";				--zielregister:26
		shamt       := "00000";				--shamt ist egal
		funct       := "100100";			--and
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;	
		
		--ASSERT fuer ADD Befehl 2
		wait for 2 ns;
		assert test_write_address_in = "11110" report "Adresse falsch angelegt!, ADD 2" severity error;
		assert test_write_data_in = x"FFFFACCE" report "Falsches Datum berechnet!, ADD 2" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, ADD 2" severity error;		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# OR Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "11001";				--zielregister:25
		shamt       := "00000";				--shamt ist egal
		funct       := "100101";			--or
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;
		
		--ASSERT fuer ADDU Befehl
		wait for 2 ns;
		assert test_write_address_in = "11101" report "Adresse falsch angelegt!, ADDU" severity error;
		assert test_write_data_in = x"FFFFACCE" report "Falsches Datum berechnet!, ADDU" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, ADDU" severity error;		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# XOR Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "11000";				--zielregister:24
		shamt       := "00000";				--shamt ist egal
		funct       := "100110";			--xor
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;
		
		--ASSERT fuer SUB Befehl
		wait for 2 ns;
		assert test_write_address_in = "11100" report "Adresse falsch angelegt!, SUB" severity error;
		assert test_write_data_in = x"00005331" report "Falsches Datum berechnet!, SUB" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SUB" severity error;		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# NOR Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "10111";				--zielregister:23
		shamt       := "00000";				--shamt ist egal
		funct       := "100111";			--nor
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;
		
		--ASSERT fuer SUBU Befehl
		wait for 2 ns;
		assert test_write_address_in = "11011" report "Adresse falsch angelegt!, SUBU" severity error;
		assert test_write_data_in = x"FFFFFEFE" report "Falsches Datum berechnet!, SUBU" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SUBU" severity error;		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# SLT Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "10110";				--zielregister:22
		shamt       := "00000";				--shamt ist egal
		funct       := "101010";			--slt
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;		
		
		--ASSERT fuer AND Befehl
		wait for 2 ns;
		assert test_write_address_in = "11010" report "Adresse falsch angelegt!, AND" severity error;
		assert test_write_data_in = x"00000101" report "Falsches Datum berechnet!, AND" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, AND" severity error;
		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# SLL Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00000";				--rt ist egal
		rd          := "10101";				--zielregister:21
		shamt       := "00101";				--shift amount = 5
		funct       := "000000";			--sll
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;
		
		--ASSERT fuer OR Befehl
		wait for 2 ns;
		assert test_write_address_in = "11001" report "Adresse falsch angelegt!, OR" severity error;
		assert test_write_data_in = x"FFFFFFFF" report "Falsches Datum berechnet!, OR" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, OR" severity error;
		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# SRL Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00000";				--rt ist egal
		rd          := "10100";				--zielregister:20
		shamt       := "00101";				--shift amount = 5
		funct       := "000010";			--srl
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;
		
		--ASSERT fuer XOR Befehl
		wait for 2 ns;
		assert test_write_address_in = "11000" report "Adresse falsch angelegt!, XOR" severity error;
		assert test_write_data_in = x"FFFFFEFE" report "Falsches Datum berechnet!, XOR" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, XOR" severity error;
		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# SRA Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00000";				--rt ist egal
		rd          := "10011";				--zielregister:19
		shamt       := "00101";				--shift amount = 5
		funct       := "000011";			--sra
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;
		
		--ASSERT fuer NOR Befehl
		wait for 2 ns;
		assert test_write_address_in = "10111" report "Adresse falsch angelegt!, NOR" severity error;
		assert test_write_data_in = x"00000000" report "Falsches Datum berechnet!, NOR" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, NOR" severity error;
		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# SLTU Test Takt X
		--#############################################
		opcode		:= "000000";			--special
		rs 			:= "01000";				--quellregister: 8  (0xFFFFFFFF)
		rt				:= "00101";				--quellregister: 5  (0x00000101)
		rd          := "10010";				--zielregister:18
		shamt       := "00000";				--shamt ist egal
		funct       := "101011";			--sltu
		
		instruction_in <= opcode & rs & rt & rd &shamt & funct;	
		
		--ASSERT fuer SLT Befehl
		wait for 2 ns;
		assert test_write_address_in = "10110" report "Adresse falsch angelegt!, SLT" severity error;
		assert test_write_data_in = x"00000001" report "Falsches Datum berechnet!, SLT" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SLT" severity error;
		
		wait until rising_edge(clk_in);
		
		--ASSERT fuer SLL Befehl
		wait for 2 ns;
		assert test_write_address_in = "10101" report "Adresse falsch angelegt!, SLL" severity error;
		assert test_write_data_in = x"FFFFFFE0" report "Falsches Datum berechnet!, SLL" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SLL" severity error;
		
		wait until rising_edge(clk_in);
		
		--ASSERT fuer SRL Befehl
		wait for 2 ns;
		assert test_write_address_in = "10100" report "Adresse falsch angelegt!, SRL" severity error;
		assert test_write_data_in = x"07FFFFFF" report "Falsches Datum berechnet!, SRL" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SRL" severity error;
		
		wait until rising_edge(clk_in);
		
		--ASSERT fuer SRA Befehl
		wait for 2 ns;
		assert test_write_address_in = "10011" report "Adresse falsch angelegt!, SRA" severity error;
		assert test_write_data_in = x"FFFFFFFF" report "Falsches Datum berechnet!, SRA" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SRA" severity error;
		
		wait until rising_edge(clk_in);
		
		--ASSERT fuer SLTU Befehl
		wait for 2 ns;
		assert test_write_address_in = "10010" report "Adresse falsch angelegt!, SLTU" severity error;
		assert test_write_data_in = x"00000000" report "Falsches Datum berechnet!, SLTU" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, SLTU" severity error;
		
		wait until rising_edge(clk_in);
		
--	 _    ___   _   ___   _____ _____ ___  ___ ___         ___       __     _    _     
-- | |  / _ \ /_\ |   \ / / __|_   _/ _ \| _ \ __|  ___  | _ ) ___ / _|___| |_ | |___ 
-- | |_| (_) / _ \| |) / /\__ \ | || (_) |   / _|  |___| | _ \/ -_)  _/ -_) ' \| / -_)
-- |____\___/_/ \_\___/_/ |___/ |_| \___/|_|_\___|       |___/\___|_| \___|_||_|_\___|
      --#############################################
		--# LW Test Takt XXX
		--#############################################                                                                              
		opcode		:= "100011";			--LW
		rs 			:= "00000";				--operand 1
		rt				:= "00010";				--soll in register 2
		immediate	:= x"E0FD";
		
		instruction_in <= opcode & rs & rt & immediate;	
		
		--4x nop
		wait until rising_edge(clk_in);		
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wb_ack_in <= '1';
		wb_dat_in <= x"deadbeef";
		
		wait until rising_edge(clk_in);
		wb_ack_in <= '0';
		instruction_in <= x"00000000";		
		
		wait for 2 ns;
		assert test_write_address_in = "00010" report "Adresse falsch angelegt!, LW" severity error;
		assert test_write_data_in = (x"deadbeef") report "Falsches Datum berechnet!, LW" severity error;
		assert test_reg_write = '1' report "Wert wird nicht in Register geschrieben!, LW" severity error;
		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# SW Test Takt XXX
		--#############################################                                                                              
		opcode		:= "101011";			--SW
		rs 			:= "00000";				--operand 1
		rt				:= "00010";				--wert aus rt wird in speicher geschrieben
		immediate	:= x"ABCD";
		
		instruction_in <= opcode & rs & rt & immediate;
		
		--4x nop
		wait until rising_edge(clk_in);		
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		
		wait for 2 ns;
		
		assert wb_adr_out 	= x"FFFFABCD" 				report "write test failed1" severity error;
		assert wb_dat_out 	= x"deadbeef"				report "write test failed2" severity error;
		
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wb_ack_in <= '1';     
		
		wait for 2 ns;
		assert test_reg_write = '0' report "Es wird in Register geschrieben!, SW" severity error;
		
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wb_ack_in <= '0';
		
		wait until rising_edge(clk_in);		
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		
		--     _                     ___       __     _    _     
		--  _ | |_  _ _ __  _ __ ___| _ ) ___ / _|___| |_ | |___ 
		-- | || | || | '  \| '_ \___| _ \/ -_)  _/ -_) ' \| / -_)
		--  \__/ \_,_|_|_|_| .__/   |___/\___|_| \___|_||_|_\___|
		--                 |_|                                                                                             
		--#############################################
		--# Jump test
		--#############################################                                                                              
		opcode		:= "000010";			--jump
		address 	   := "11" & x"beeeef";	--jump offset

		pc_inc_in 	<= x"11111111";		--basis fr jump

		instruction_in <= opcode & address;

		wait until rising_edge(clk_in);
		
		--#############################################
		--# Jump and Link test
		--#############################################		
		opcode		:= "000011";			--JAL
		address 	   := "11" & x"beeeef";	--jump offset

		pc_inc_in 	<= x"11111111";		--basis fr jump

		instruction_in <= opcode & address;
		
		
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";

		--ASSERT fr jump befehl
		wait for 2 ns;
		assert pc_src = '1' report "jump test failed: falsche quelle fr pc gewhlt" severity error;		
		assert jump_addr_out = "0001" & "11" & x"beeeef" & "00" report "jump test failed: zu falscher addresse gesprungen" severity error;

		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		
		--ASSERT fr JAL befehl
		wait for 2 ns;		
		assert pc_src = '1' report "JAL test failed: falsche quelle fr pc gewhlt" severity error;		
		assert jump_addr_out = "0001" & "11" & x"beeeef" & "00" report "JAL test failed: zu falscher addresse gesprungen" severity error;
		
		wait until rising_edge(clk_in);
		
		--ASSERT fr JAL befehl(WB luft erst spter aus)
		wait for 2 ns;	
		assert test_write_address_in = "11111" report "JAL test failed: Adresse falsch angelegt! " severity error;
		assert test_write_data_in = x"11111115" report "JAL test failed: Falschen PC reingeschrieben! " severity error;
		assert test_reg_write = '1' report "JAL test failed:Wert wird nicht in Register geschrieben!" severity error;
		
		wait until rising_edge(clk_in);
		
		--#############################################
		--# Branch tests
		--#############################################	
		
		--#############################################
		--# Branch on equal beq =
		--#############################################
		opcode		:= "000100";			--beq
		rs 	      := "00001";	         
		rt          := "00001";
		immediate   := x"0004";      --offset
 
		pc_inc_in 	<= x"00000000";		--basis fr jump

		instruction_in <= opcode & rs & rt & immediate;		
		
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		--ASSERT fr beq befehl
		wait for 2 ns;
		assert pc_src = '1' report "beq = test failed: falsche quelle fr pc gewhlt" severity error;		
		assert jump_addr_out = x"00000010" report "beq test failed: zu falscher addresse gesprungen" severity error;
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		
		--#############################################
		--# Branch on  equal beq !=
		--#############################################
		opcode		:= "000100";			--beq
		rs 	      := "00001";	         
		rt          := "00010";
		immediate   := x"0004";      --offset
 
		pc_inc_in 	<= x"00000000";		--basis fr jump

		instruction_in <= opcode & rs & rt & immediate;		
		
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		--ASSERT fr beq befehl
		wait for 2 ns;
		assert pc_src = '0' report "beq != test failed: falsche quelle fr pc gewhlt" severity error;		
		assert jump_addr_out = x"00000004" report "beq test failed: zu falscher addresse gesprungen" severity error;
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		wait until rising_edge(clk_in);
		instruction_in <= x"00000000";
		
		wait;
   end process;

END;
