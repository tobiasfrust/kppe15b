----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:02:10 06/09/2015 
-- Design Name: 
-- Module Name:    mips_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.mips.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mips_top is
	Port (--in
			instruction_in 	  	: in STD_LOGIC_VECTOR (31 downto 0);
			clk_in            	: in std_logic;
			rst_in            	: in std_logic;
			pc_inc_in         	: in STD_LOGIC_VECTOR (31 downto 0);				--!!!hier noch ungenutzt!!!
				  
			--out					   		
			pc_src 		   	: out STD_LOGIC;												--ausgang fr den muxer vor dem program counter, der bei sprung die quelle auswhlt
																										--!!!hier noch ungenutzt!!!
			jump_addr_out 		: out STD_LOGIC_VECTOR (31 downto 0);						--berechnete Sprungzieladresse				
							
			--############################################
			--#	wishbone signale
			--############################################				
			--in wishbone bus			  
			wb_dat_in : in STD_LOGIC_VECTOR (31 downto 0);
			wb_ack_in : in STD_LOGIC;				
			--out wishbone bus
			wb_adr_out		: out STD_LOGIC_VECTOR (31 downto 0);
			wb_dat_out		: out STD_LOGIC_VECTOR (31 downto 0);
			wb_we_out		: out STD_LOGIC;
			wb_sel_out 		: out STD_LOGIC_VECTOR (3 downto 0);	
			wb_strobe_out  	: out STD_LOGIC;					
			wb_cyc_out  		: out STD_LOGIC;
			
			--############################################
			--#	testbench signale
			--############################################	
			test_write_data_in : out std_logic_vector(31 downto 0);
			test_write_address_in : out std_logic_vector(4 downto 0);
			test_reg_write : out std_logic);
			
			
end mips_top;

architecture Behavioral of mips_top is

	--output signale vom decoder
	signal alu_op_control_out    :  std_logic_vector(1 downto 0);
	signal reg_dst_control_out    : std_logic;
	signal branch_control_out     : std_logic_vector(1 downto 0);
	signal mem_read_control_out   : std_logic;
	signal mem_to_reg_control_out : std_logic;
	signal mem_write_control_out  : std_logic;
	signal alu_src_control_out    : std_logic;
	signal reg_write_control_out  : std_logic;
	signal pc_to_R31_control_out  : std_logic;
	
	--output signale vom datenpfad
	signal delayed_instruction_datapath_out : STD_LOGIC_VECTOR (31 downto 0);

begin
	decoder : entity work.mips_decoder
	port map (insn 			 => delayed_instruction_datapath_out,
				 alu_op         => alu_op_control_out,
				 reg_dst        => reg_dst_control_out,
				 branch         => branch_control_out,
				 mem_read       => mem_read_control_out,
				 mem_to_reg     => mem_to_reg_control_out,
				 mem_write      => mem_write_control_out,
				 alu_src        => alu_src_control_out,
				 reg_write      => reg_write_control_out,
				 pc_to_R31		 => pc_to_R31_control_out
				 );
				 
	datapath : entity work.datapath_module
	port map (	--in
					clk_in                  => clk_in,
					rst_in						=> rst_in,
					pc_inc_in					=> pc_inc_in,									--!!!hier ungenutzt!!!
					instruction_in          => instruction_in,
					reg_dst_ctrl_in 			=> reg_dst_control_out,
					alu_src_in					=>	alu_src_control_out,
					alu_op_in					=>	alu_op_control_out,
					mem_write_in				=>	mem_write_control_out,
					mem_read_in					=>	mem_read_control_out,
					branch_in					=>	branch_control_out,
					mem_to_reg_in				=>	mem_to_reg_control_out,
					mem_reg_write_in			=>	reg_write_control_out,
					pc_to_R31_in				=> pc_to_R31_control_out,
					wb_dat_in					=> wb_dat_in,
					wb_ack_in					=> wb_ack_in,
				 
					--out
					instruction_out 			=> delayed_instruction_datapath_out,	--befehl, der ans Steuerwerk geht. Er geht nicht direkt ans Steuerwerk, weil er erst durch 
																										--ein pipelineregister muss. (wie es im Buch eingezeichnet ist)
					pc_src 						=> pc_src,										--ausgang fr den muxer vor dem program counter, der bei sprung die quelle auswhlt
																										--!!!hier ungenutzt!!!
					jump_addr_out				=> jump_addr_out,
																									
					wb_adr_out 					=>	wb_adr_out,
					wb_dat_out 					=>	wb_dat_out,
					wb_we_out	 				=>	wb_we_out, 		
					wb_sel_out 					=> wb_sel_out,  	
					wb_strobe_out 				=> wb_strobe_out,					
					wb_cyc_out  			 	=> wb_cyc_out,
					--Testsignale
					test_write_address_in   => test_write_address_in,
					test_write_data_in      => test_write_data_in,
					test_reg_write          => test_reg_write);

end Behavioral;

