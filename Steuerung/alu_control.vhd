----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:07:12 04/29/2015 
-- Design Name: 
-- Module Name:    alu_control - Behavioral 
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



--nach Buch S. 308/Kapitel 4.4.1
entity alu_control is
    Port ( alu_op : in  STD_LOGIC_VECTOR (1 downto 0);
           funct : in  STD_LOGIC_VECTOR (5 downto 0);
           alu_control_sig : out  STD_LOGIC_VECTOR (3 downto 0));
end alu_control;

architecture Behavioral of alu_control is

begin
	process(alu_op, funct)
	variable temp: STD_LOGIC_VECTOR(7 downto 0);
	begin
		temp := alu_op & funct;
		if std_match(temp, "00------") then
			alu_control_sig <= "0010";
		elsif std_match(temp, "01------") then
			alu_control_sig <= "0110";
		elsif std_match(temp, "10--0000") then
			alu_control_sig <= "0010";
		elsif std_match(temp, "1---0010") then
			alu_control_sig <= "0110";
		elsif std_match(temp, "10--0100") then
			alu_control_sig <= "0000";
		elsif std_match(temp, "10--0101") then
			alu_control_sig <= "0001";
		elsif std_match(temp, "1---1010") then
			alu_control_sig <= "0111";
		else
			alu_control_sig <= "0000";
		end if;
	end process;

end Behavioral;

