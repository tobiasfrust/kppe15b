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
			  EXMEM_branch : in STD_LOGIC_VECTOR(1 DOWNTO 0);
			  flush : out STD_LOGIC);
end hazard_control_unit;

-- wenn beq: EXMEM_branch = 11
-- wenn bne: EXMEM_branch = 00
-- sonst: EXMEM_branch = 01 (kein Sprung) bzw. 10 (unconditional Jump)

architecture Behavioral of hazard_control_unit is

begin

	PROCESS(EXMEM_alu_zero, EXMEM_branch)
	BEGIN
		flush <= '0';
		
		-- das Kodierung von EXMEM_branch wurde so gewählt, dass flush = '1' gesetzt werden muss, sobald alle Bits der beiden Eingangssignale gleich sind
		IF ((EXMEM_alu_zero = EXMEM_branch(1)) AND (EXMEM_branch(1) = EXMEM_branch(0))) THEN
			flush <= '1';
		END IF;
	END PROCESS;

end Behavioral;