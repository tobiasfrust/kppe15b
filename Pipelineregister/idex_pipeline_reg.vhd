


----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:55:41 05/05/2015 
-- Design Name: 
-- Module Name:    idex-pipeline_reg - Behavioral 
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

entity idex_pipeline_reg is
    Port ( --in steuerung
				pipeline_en_in : in STD_LOGIC;
				clk_in : in STD_LOGIC;
			  --in
			  read_data1_in : in  STD_LOGIC_VECTOR (31 downto 0);
           read_data2_in : in  STD_LOGIC_VECTOR (31 downto 0);
           sign_extended_in : in  STD_LOGIC_VECTOR (31 downto 0);
           write_address_rt_in : in  STD_LOGIC_VECTOR (4 downto 0);
			  write_address_rd_in : in  STD_LOGIC_VECTOR (4 downto 0);
			  program_counter_in : in STD_LOGIC_VECTOR (31 downto 0);
			  instruction_in : in STD_LOGIC_VECTOR (5 downto 0);			  
			  
			  --in steuersignale
			  --ex
			  reg_dst_ctrl_in : in STD_LOGIC;											--entscheided, ob rd oder rt feld als write addr fr des regfile genutzt wird											
			  alu_src_in : in STD_LOGIC;
			  alu_op_in : in STD_LOGIC_VECTOR (1 downto 0);
			  --mem
			  mem_write_in : in STD_LOGIC;
			  mem_read_in : in STD_LOGIC;
			  branch_in : in STD_LOGIC;													--wenn branch und zero ausgang der alu beide 1 sind, wird gesprungen
			  --wb
			  mem_to_reg_in : in STD_LOGIC;
			  reg_write_in : in STD_LOGIC;
			  
			  --out
			  read_data1_out : out  STD_LOGIC_VECTOR (31 downto 0);
           read_data2_out : out  STD_LOGIC_VECTOR (31 downto 0);
           sign_extended_out : out  STD_LOGIC_VECTOR (31 downto 0);
           write_address_rt_out : out  STD_LOGIC_VECTOR (4 downto 0);
			  write_address_rd_out : out  STD_LOGIC_VECTOR (4 downto 0);
			  program_counter_out : out STD_LOGIC_VECTOR (31 downto 0);
			  instruction_out : out STD_LOGIC_VECTOR (5 downto 0);
			  --alu_ctrl_out : out STD_LOGIC_VECTOR (5 downto 0);					--hat keinen eigenen Eingang, sondern kann immer aus den unteren 6 Bit des immediate feldes bereitgestellt werden
			  
			  --out steuersignale
			  --ex
			  reg_dst_ctrl_out : out STD_LOGIC;
			  alu_src_out : out STD_LOGIC;
			  alu_op_out : out STD_LOGIC_VECTOR (1 downto 0);
			  --mem
			  mem_write_out : out STD_LOGIC;
			  mem_read_out : out STD_LOGIC;
			  branch_out : out STD_LOGIC;
			  --wb
			  mem_to_reg_out : out STD_LOGIC;
			  reg_write_out : out STD_LOGIC);
			  
end idex_pipeline_reg;

architecture Behavioral of idex_pipeline_reg is

begin
	process(clk_in)
	begin
		if rising_edge(clk_in) then
			if pipeline_en_in = '1' then
				read_data1_out 			<= read_data1_in;
				read_data2_out 			<= read_data2_in;
				sign_extended_out 		<= sign_extended_in;
				write_address_rt_out 	<= write_address_rt_in;
				write_address_rd_out 	<= write_address_rd_in;
				program_counter_out 		<= program_counter_in;	
				instruction_out 			<= instruction_in;
				
				--steuersignale
				--ex
				reg_dst_ctrl_out 			<= reg_dst_ctrl_in;
				alu_src_out 				<= alu_src_in;
				alu_op_out 					<= alu_op_in;
				--mem
				mem_write_out 				<= mem_write_in;
				mem_read_out 				<= mem_read_in;
				branch_out 					<= branch_in;
				--wb
				mem_to_reg_out 			<= mem_to_reg_in;
				reg_write_out				<= reg_write_in;
			end if;
		end if;
	end process;

end Behavioral;

