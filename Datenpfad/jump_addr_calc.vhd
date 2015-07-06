----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:12:40 05/16/2015 
-- Design Name: 
-- Module Name:    jump_addr_calc - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

------------------------------------------------------------------------------------
-- dieses module entspricht "verschiebe um 2 nach links" und "addiere ergebnis" 
-- aus der abbildung im buch. (jump addr berechnung)
------------------------------------------------------------------------------------

entity jump_addr_calc is
    Port ( pc_inc_in : in  STD_LOGIC_VECTOR (31 downto 0);
           offset : in  STD_LOGIC_VECTOR (31 downto 0);
			  branch_in : in std_logic_vector (1 downto 0);
			  address_in : in STD_LOGIC_VECTOR (25 downto 0);
           pc_out : out  STD_LOGIC_VECTOR (31 downto 0));
end jump_addr_calc;

architecture Behavioral of jump_addr_calc is

begin
	process(pc_inc_in, offset)
	begin
		
		if (branch_in="10") then			--unconditional Jump
			pc_out <= pc_inc_in(31 downto 28) & address_in (25 downto 0) & "00";
		else
			pc_out <= std_logic_vector(unsigned(offset (29 downto 0) & "00") + unsigned(pc_inc_in));		--berechnung bei IMMEDIATE format
		end if;
	
	end process;
end Behavioral;

