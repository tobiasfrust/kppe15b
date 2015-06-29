--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:50:59 05/30/2015
-- Design Name:   
-- Module Name:   C:/Users/Alex/Xilinx/SysGen/14.7/Regfile_test/data_storage_tb.vhd
-- Project Name:  Regfile_test
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: data_storage
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
 
ENTITY data_storage_tb IS
END data_storage_tb;
 
ARCHITECTURE behavior OF data_storage_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT data_storage
    PORT(
         address_in : IN  std_logic_vector(31 downto 0);
         write_data_in : IN  std_logic_vector(31 downto 0);
         clk_in : IN  std_logic;
         mem_read_in : IN  std_logic;
         mem_write_in : IN  std_logic; 
         rst_in : IN  std_logic;
         wb_dat_in : IN  std_logic_vector(31 downto 0);
         wb_ack_in : IN  std_logic;
         read_data_out : OUT  std_logic_vector(31 downto 0);
         pipeline_en_out : OUT  std_logic;
         wb_adr_out : OUT  std_logic_vector(31 downto 0);
         wb_dat_out : OUT  std_logic_vector(31 downto 0);
         wb_we_out : OUT  std_logic;
         wb_sel_out : OUT  std_logic_vector(3 downto 0);
         wb_strobe_out : OUT  std_logic;
         wb_cyc_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal address_in : std_logic_vector(31 downto 0) := (others => '0');
   signal write_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal clk_in : std_logic := '0';
   signal mem_read_in : std_logic := '0';
   signal mem_write_in : std_logic := '0';
   signal rst_in : std_logic := '0';
   signal wb_dat_in : std_logic_vector(31 downto 0) := (others => '0');
   signal wb_ack_in : std_logic := '0';

 	--Outputs
   signal read_data_out : std_logic_vector(31 downto 0);
   signal pipeline_en_out : std_logic;
   signal wb_adr_out : std_logic_vector(31 downto 0);
   signal wb_dat_out : std_logic_vector(31 downto 0);
   signal wb_we_out : std_logic;
   signal wb_sel_out : std_logic_vector(3 downto 0);
   signal wb_strobe_out : std_logic;
   signal wb_cyc_out : std_logic;

   -- Clock period definitions
   constant clk_in_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: data_storage PORT MAP (
          address_in => address_in,
          write_data_in => write_data_in,
          clk_in => clk_in,
          mem_read_in => mem_read_in,
          mem_write_in => mem_write_in,
          rst_in => rst_in,
          wb_dat_in => wb_dat_in,
          wb_ack_in => wb_ack_in,
          read_data_out => read_data_out,
          pipeline_en_out => pipeline_en_out,
          wb_adr_out => wb_adr_out,
          wb_dat_out => wb_dat_out,
          wb_we_out => wb_we_out,
          wb_sel_out => wb_sel_out,
          wb_strobe_out => wb_strobe_out,
          wb_cyc_out => wb_cyc_out
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
   begin		
      -- hold reset state for 100 ns.
		rst_in <= '1';
		
      wait for 100 ns;
		rst_in <= '0';
		wait until rising_edge(clk_in);
		
		--###############################################
		--idle test
		--###############################################
		mem_read_in <= '0';
		mem_write_in <= '0';
		
		wait until rising_edge(clk_in);
		assert pipeline_en_out = '1' report "idle test failed" severity error;

		--###############################################
		--read test (1 takt)
		--###############################################
		mem_read_in <= '1';
		mem_write_in <= '0';
		address_in <= x"AAAAAAAA";
		
		--propagate delay of data_storage
		wait for 1 ns;
		--hier noch kein Buszyklus
		assert wb_strobe_out = '0' 						report "read test failed" severity error;
		assert wb_cyc_out 	= '0' 						report "read test failed" severity error;		
		
		-- 1 takt latenz durch data_storage
		wait until rising_edge(clk_in);
		
		--propagate delay of data_storage
		wait for 1 ns;
		--korrekt wb signale asserten
		assert wb_adr_out 	= x"AAAAAAAA" 				report "read test failed" severity error;
		assert wb_dat_out 	= (31 downto 0 => '0')	report "read test failed" severity error;
		assert wb_we_out  	= '0' 		  				report "read test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "read test failed" severity error;
		assert wb_strobe_out = '1' 						report "read test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "read test failed" severity error;		

		-- antwort von Busgeraet
		wait for 15 ns;
		wb_ack_in <= '1';
		wb_dat_in <= x"22222222";
		
		--propagate delay of data_storage
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "read test failed" severity error;
		--korrekt lesen
		assert read_data_out = x"22222222" report "read test failed" severity error;
		
		--Takt abschliessen
		wait until rising_edge(clk_in);
		wb_ack_in <= '0';
		wb_dat_in <= (others => '-');
		
		--###############################################
		--write test (1 takt)
		--###############################################
		mem_read_in 		<= '0';
		mem_write_in		<= '1';
		address_in 			<= x"BBBBBBBB";
		write_data_in 		<= x"01234567";
		
		--verggerung fr assert
		wait for 1 ns;
		--korrekt wb signale asserten
		assert wb_adr_out 	= x"BBBBBBBB" 				report "write test failed" severity error;
		assert wb_dat_out 	= x"01234567"				report "write test failed" severity error;
		assert wb_we_out  	= '1' 		  				report "write test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "write test failed" severity error;
		assert wb_strobe_out = '1' 						report "write test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "write test failed" severity error;		
		
		--verggerung fr assert
		wait for 9 ns;	
		
		mem_write_in 		<= '0';
		address_in 			<= (others => '-');
		write_data_in 		<= (others => '-');
		
		wb_ack_in 			<= '1';
		
		--verggerung fr assert
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "write test failed" severity error;
		--verggerung fr assert
		wait for 9 ns;
		wb_ack_in <= '0';
		
		--###############################################
		--read test (5 takte)
		--###############################################
		mem_read_in <= '1';
		mem_write_in <= '0';
		address_in <= x"AAAAAAAA";
		
		--verggerung fr assert
		wait for 1 ns;
		--korrekt wb signale asserten
		assert wb_adr_out 	= x"AAAAAAAA" 				report "read test failed" severity error;
		assert wb_dat_out 	= (31 downto 0 => '-')	report "read test failed" severity error;
		assert wb_we_out  	= '0' 		  				report "read test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "read test failed" severity error;
		assert wb_strobe_out = '1' 						report "read test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "read test failed" severity error;		
		
		--verggerung fr assert
		wait for 9 ns;		
		mem_read_in <= '0';
		
		wait for 40 ns;
		
		wb_ack_in <= '1';
		wb_dat_in <= x"22222222";
		address_in <= (others => '-');
		
		--verzgerung fr assert
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "read test failed" severity error;
		--korrekt lesen
		assert read_data_out = x"22222222" report "read test failed" severity error;
		
		--verggerung fr assert
		wait for 9 ns;
		wb_ack_in <= '0';		
		
		wait for 10 ns;
			
		--###############################################
		--write test (5 takte)
		--###############################################
		mem_read_in 		<= '0';
		mem_write_in		<= '1';
		address_in 			<= x"BBBBBBBB";
		write_data_in 		<= x"01234567";
		
		--verggerung fr assert
		wait for 1 ns;
		--korrekt wb signale asserten
		assert wb_adr_out 	= x"BBBBBBBB" 				report "write test failed" severity error;
		assert wb_dat_out 	= x"01234567"				report "write test failed" severity error;
		assert wb_we_out  	= '1' 		  				report "write test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "write test failed" severity error;
		assert wb_strobe_out = '1' 						report "write test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "write test failed" severity error;		
		
		--verggerung fr assert
		wait for 9 ns;			
		mem_write_in 		<= '0';
		
		wait for 40 ns;
		
		wb_ack_in 			<= '1';
		address_in 			<= (others => '-');
		write_data_in 		<= (others => '-');
		
		--verggerung fr assert
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "write test failed" severity error;
		--verggerung fr assert
		wait for 9 ns;
		wb_ack_in <= '0';		

		wait for 10 ns;
		
		--###############################################
		--read und sofort write test
		--###############################################
		
		mem_read_in <= '1';
		mem_write_in <= '0';
		address_in <= x"AAAAAAAA";
		
		--verggerung fr assert
		wait for 1 ns;
		--korrekt wb signale asserten
		assert wb_adr_out 	= x"AAAAAAAA" 				report "read test failed" severity error;
		assert wb_dat_out 	= (31 downto 0 => '-')	report "read test failed" severity error;
		assert wb_we_out  	= '0' 		  				report "read test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "read test failed" severity error;
		assert wb_strobe_out = '1' 						report "read test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "read test failed" severity error;		
		
		--verggerung fr assert
		wait for 9 ns;
		address_in <= (others => '-');
		mem_read_in <= '0';		
		
		wb_ack_in <= '1';
		wb_dat_in <= x"22222222";
				
		--sofort write
		mem_write_in		<= '1';
		address_in 			<= x"BBBBBBBB";
		write_data_in 		<= x"01234567";
		
		--verggerung fr assert
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "read/immediate write test failed" severity error;
		--korrekt lesen
		assert read_data_out = x"22222222" report "read/immediate write test failed" severity error;
		--write asserts
		assert wb_adr_out 	= x"BBBBBBBB" 				report "read/immediate write test failed" severity error;
		assert wb_dat_out 	= x"01234567"				report "read/immediate write test failed" severity error;
		assert wb_we_out  	= '1' 		  				report "read/immediate write test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "read/immediate write test failed" severity error;
		assert wb_strobe_out = '1' 						report "read/immediate write test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "read/immediate write test failed" severity error;	
		
		--verggerung fr assert
		wait for 9 ns;				
		
		mem_write_in 		<= '0';		
		wb_ack_in 			<= '1';
		address_in 			<= (others => '-');
		write_data_in 		<= (others => '-');
		
		--verggerung fr assert
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "write test failed" severity error;
		--verggerung fr assert
		wait for 9 ns;
		wb_ack_in <= '0';
		wb_dat_in <= (others => '-');			
		
		--pause
		wait for 20 ns;
		
		--###############################################
		--write und sofort read test
		--###############################################
		
		mem_read_in 		<= '0';
		mem_write_in		<= '1';
		address_in 			<= x"BBBBBBBB";
		write_data_in 		<= x"01234567";
		
		--verggerung fr assert
		wait for 1 ns;
		--korrekt wb signale asserten
		assert wb_adr_out 	= x"BBBBBBBB" 				report "write test failed" severity error;
		assert wb_dat_out 	= x"01234567"				report "write test failed" severity error;
		assert wb_we_out  	= '1' 		  				report "write test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "write test failed" severity error;
		assert wb_strobe_out = '1' 						report "write test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "write test failed" severity error;		
		
		--verggerung fr assert
		wait for 9 ns;	
		
		mem_write_in 		<= '0';		
		wb_ack_in 			<= '1';
		
		--verggerung fr assert
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "write test failed" severity error;
		--verggerung fr assert
		wait for 9 ns;
		wb_ack_in <= '0';
		address_in 			<= (others => '-');
		write_data_in 		<= (others => '-');
		
		--sofort read
		mem_read_in <= '1';
		mem_write_in <= '0';
		address_in <= x"AAAAAAAA";
		
		--verggerung fr assert
		wait for 1 ns;
		--korrekt wb signale asserten
		assert wb_adr_out 	= x"AAAAAAAA" 				report "read test failed" severity error;
		assert wb_dat_out 	= (31 downto 0 => '-')	report "read test failed" severity error;
		assert wb_we_out  	= '0' 		  				report "read test failed" severity error;
		assert wb_sel_out 	= x"F"   					report "read test failed" severity error;
		assert wb_strobe_out = '1' 						report "read test failed" severity error;
		assert wb_cyc_out 	= '1' 						report "read test failed" severity error;		
		
		--verggerung fr assert
		wait for 9 ns;
		mem_read_in <= '0';
		
		wb_ack_in <= '1';
		wb_dat_in <= x"22222222";
		
		--verggerung fr assert
		wait for 1 ns;
		--soll wieder idle sein
		assert pipeline_en_out = '1' report "read test failed" severity error;
		--korrekt lesen
		assert read_data_out = x"22222222" report "read test failed" severity error;
		
		--verggerung fr assert
		wait for 9 ns;
		wb_ack_in <= '0';
		wb_dat_in <= (others => '-');	
		address_in 			<= (others => '-');
			
      wait;
   end process;	
END;
