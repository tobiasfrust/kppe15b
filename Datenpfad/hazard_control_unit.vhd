----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:15:58 06/24/2015 
-- Design Name: 
-- Module Name:    hazard_control_unit - Behavioral 
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

-- use IEEE.NUMERIC_STD.ALL;
use work.mips.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_control_unit is
    Port ( EXMEM_alu_zero : in  STD_LOGIC;
			  EXMEM_branch : in STD_LOGIC;
			  EXMEM_branch_cond : in STD_LOGIC;
			  flush : out STD_LOGIC);
end hazard_control_unit;

architecture Behavioral of hazard_control_unit is

begin

	PROCESS(EXMEM_alu_zero, EXMEM_branch, EXMEM_branch_cond)
	BEGIN
		flush <= '0';
		
		IF ((EXMEM_alu_zero = EXMEM_branch) AND (EXMEM_branch = EXMEM_branch_cond)) THEN
			flush <= '1';
		END IF;
	END PROCESS;

end Behavioral;