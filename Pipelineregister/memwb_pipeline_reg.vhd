----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:18:08 05/10/2015 
-- Design Name: 
-- Module Name:    memwb_pipeline_reg - Behavioral 
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

entity memwb_pipeline_reg is
    Port ( --in steuerung
			  pipeline_en_in : in STD_LOGIC;
			  clk_in : in STD_LOGIC;
	 
			  --in
			  read_data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           alu_result_in : in  STD_LOGIC_VECTOR (31 downto 0);
           reg_dst_addr_in : in  STD_LOGIC_VECTOR (4 downto 0);
           mem_to_reg_in : in  STD_LOGIC;
			  reg_write_in : in  STD_LOGIC;			  
			  program_counter_in : in STD_LOGIC_VECTOR (31 downto 0);
			  pc_to_R31_in : in STD_LOGIC;
			  
			  --out
           read_data_out : out  STD_LOGIC_VECTOR (31 downto 0);
           alu_result_out : out  STD_LOGIC_VECTOR (31 downto 0);
           reg_dst_addr_out : out  STD_LOGIC_VECTOR (4 downto 0);
           mem_to_reg_out : out  STD_LOGIC;			  
			  reg_write_out : out  STD_LOGIC;			  
			  program_counter_out : out STD_LOGIC_VECTOR (31 downto 0);
			  pc_to_R31_out : out STD_LOGIC);
			  
end memwb_pipeline_reg;

architecture Behavioral of memwb_pipeline_reg is
begin

	process(clk_in)
	begin
	
		if rising_edge(clk_in) then
			if pipeline_en_in = '1' then
			  read_data_out 		<= read_data_in; 
			  alu_result_out 		<= alu_result_in;
			  reg_dst_addr_out 	<= reg_dst_addr_in; 
			  mem_to_reg_out 		<= mem_to_reg_in;
			  reg_write_out 		<= reg_write_in;
			  program_counter_out <= program_counter_in;
			  pc_to_R31_out 		<= pc_to_R31_in;
			 end if;
		end if;
	
	end process;

end Behavioral;

