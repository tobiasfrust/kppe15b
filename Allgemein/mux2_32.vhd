----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:23:41 04/29/2015 
-- Design Name: 
-- Module Name:    mux2_32 - Behavioral 
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

entity mux2_32 is
    Port ( x_0 : in  STD_LOGIC_VECTOR (31 downto 0);
           x_1 : in  STD_LOGIC_VECTOR (31 downto 0);
           control : in  STD_LOGIC;
           y : out  STD_LOGIC_VECTOR (31 downto 0));
end mux2_32;

architecture Behavioral of mux2_32 is

begin

	process(x_0, x_1, control)
	begin
		
		if control = '0' then
			y <= x_0;
		else
			y <= x_1;
		end if;
		
	end process;

end Behavioral;

