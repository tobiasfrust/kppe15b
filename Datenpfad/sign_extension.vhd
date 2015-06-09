----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:02:21 04/29/2015 
-- Design Name: 
-- Module Name:    sign_extension - Behavioral 
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

entity sign_extension is
    Port ( imm : in  STD_LOGIC_VECTOR (15 downto 0);
           imm_ext : out  STD_LOGIC_VECTOR (31 downto 0));
end sign_extension;

architecture Behavioral of sign_extension is

begin
	process(imm)
	begin
		if imm(15) = '1' then
			imm_ext <= "1111111111111111" & imm;
		else
			imm_ext <= "0000000000000000" & imm;
		end if;
	end process;

end Behavioral;

