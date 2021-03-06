----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:53:58 05/10/2015 
-- Design Name: 
-- Module Name:    exmem_pipeline_reg - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity exmem_pipeline_reg is
    Port ( --in steuerung
			  pipeline_en_in : in STD_LOGIC;
			  clk_in : in STD_LOGIC;
			  
			  --in
			  jump_addr_in : in  STD_LOGIC_VECTOR (31 downto 0);
           alu_zero_in : in  STD_LOGIC;
           alu_result_in : in  STD_LOGIC_VECTOR (31 downto 0);
           write_data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           reg_dst_addr_in : in  STD_LOGIC_VECTOR (4 downto 0);
			  program_counter_in : in STD_LOGIC_VECTOR (31 downto 0);
			  
			  --steuersignale
			  --mem
           mem_write_in : in  STD_LOGIC;
           mem_read_in : in  STD_LOGIC;
           branch_in : in STD_LOGIC_VECTOR (1 downto 0);			-- 00: bne		11: beq		01: kein Sprun		10: normaler (unconditional) Jump
			  --wb
           mem_to_reg_in : in  STD_LOGIC;
			  reg_write_in : in STD_LOGIC;
			  pc_to_R31_in : in STD_LOGIC;
			  
			  --out
           jump_addr_out : out  STD_LOGIC_VECTOR (31 downto 0);
           alu_zero_out : out  STD_LOGIC;
           alu_result_out : out  STD_LOGIC_VECTOR (31 downto 0);
           write_data_out : out  STD_LOGIC_VECTOR (31 downto 0);
           reg_dst_addr_out : out  STD_LOGIC_VECTOR (4 downto 0);
			  program_counter_out : out STD_LOGIC_VECTOR (31 downto 0);
			  
			  --steuersignale
			  --mem
           mem_write_out : out  STD_LOGIC;
           mem_read_out : out  STD_LOGIC;
           branch_out : out  STD_LOGIC_VECTOR (1 downto 0);
			  --wb
           mem_to_reg_out : out  STD_LOGIC;
			  reg_write_out : out STD_LOGIC;
			  pc_to_R31_out : out STD_LOGIC);
end exmem_pipeline_reg;

architecture Behavioral of exmem_pipeline_reg is

begin

	process(clk_in)
	begin
	
		if rising_edge(clk_in) then
			if pipeline_en_in = '1' then
			  jump_addr_out 		<= jump_addr_in; 
			  alu_zero_out 		<= alu_zero_in;
			  alu_result_out 		<= alu_result_in; 
			  write_data_out 		<= write_data_in; 
			  reg_dst_addr_out 	<= reg_dst_addr_in; 
			  mem_write_out 		<= mem_write_in;
			  mem_read_out 		<= mem_read_in;
			  branch_out 			<= branch_in;
			  mem_to_reg_out 		<= mem_to_reg_in;
			  reg_write_out		<= reg_write_in;
			  program_counter_out <= program_counter_in;
			  pc_to_R31_out 		<= pc_to_R31_in;
			end if;
		end if;
	
	end process;
	
end Behavioral;

