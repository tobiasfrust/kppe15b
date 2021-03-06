----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:26:07 05/05/2015 
-- Design Name: 
-- Module Name:    ifid_pipeline_reg - Behavioral 
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

entity ifid_pipeline_reg is
    Port ( --in
			  program_counter_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  instruction_in : in  STD_LOGIC_VECTOR (31 downto 0);
			  
			  --in steuersignale
			  clk_in : in STD_LOGIC;
			  pipeline_en_in : in STD_LOGIC;
			  flush_in : in STD_LOGIC;
			  
			  --out			  
			  program_counter_out : out  STD_LOGIC_VECTOR (31 downto 0) := x"00000000";
			  instruction_out : out  STD_LOGIC_VECTOR (31 downto 0):= x"00000000");
end ifid_pipeline_reg;

architecture Behavioral of ifid_pipeline_reg is

begin
	process(clk_in)
	begin
		if rising_edge(clk_in) then
			if pipeline_en_in = '1' then
				if flush_in = '1' then
					program_counter_out 	<= 	program_counter_in;
					instruction_out 		<= 	(others => '0');
				else
					program_counter_out 	<= 	program_counter_in;
					instruction_out 		<= 	instruction_in;
				end if;
			end if;
		end if;
	end process;

end Behavioral;

