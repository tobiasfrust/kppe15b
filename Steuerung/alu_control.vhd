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
use work.mips.all;

entity alu_control is
    Port ( alu_op : in  STD_LOGIC_VECTOR (1 downto 0);
           funct : in  STD_LOGIC_VECTOR (5 downto 0);
			  instruction : in STD_LOGIC_VECTOR (5 downto 0);
           alu_control_sig : out  ALU_CMD_TYPE);
end alu_control;

architecture Behavioral of alu_control is

begin
	process(alu_op, funct, instruction)
	variable temp: STD_LOGIC_VECTOR(7 downto 0);
	begin
		temp := alu_op & funct;
		--Load-Befehle
		if std_match(temp, "00------") then
			alu_control_sig <= ALU_CMD_ADD;
		--Branch-Befehle
		elsif std_match(temp, "01------") then
			alu_control_sig <= ALU_CMD_SUB;
		--R-Befehle
		elsif std_match(temp, "10000000") then
			alu_control_sig <= ALU_CMD_SLL;
		elsif std_match(temp, "10000010") then
			alu_control_sig <= ALU_CMD_SRL;
		elsif std_match(temp, "10000011") then
			alu_control_sig <= ALU_CMD_SRA;
		elsif std_match(temp, "10100100") then
			alu_control_sig <= ALU_CMD_AND;
		elsif std_match(temp, "10100101") then
			alu_control_sig <= ALU_CMD_OR;
		elsif std_match(temp, "10100110") then
			alu_control_sig <= ALU_CMD_XOR;
		elsif std_match(temp, "10100111") then
			alu_control_sig <= ALU_CMD_NOR;
		elsif std_match(temp, "10100000") then
			alu_control_sig <= ALU_CMD_ADD;
		elsif std_match(temp, "10100001") then
			alu_control_sig <= ALU_CMD_ADDU;
		elsif std_match(temp, "10100010") then
			alu_control_sig <= ALU_CMD_SUB;
		elsif std_match(temp, "10100011") then
			alu_control_sig <= ALU_CMD_SUBU;
		elsif std_match(temp, "10101010") then
			alu_control_sig <= ALU_CMD_SLT;
		elsif std_match(temp, "10101011") then
			alu_control_sig <= ALU_CMD_SLTU;
		--immediate-befehle
		elsif (alu_op = "11") AND (instruction = "001100") then
			alu_control_sig <= ALU_CMD_AND;
		elsif (alu_op = "11") AND (instruction = "001101") then
			alu_control_sig <= ALU_CMD_OR;
		elsif (alu_op = "11") AND (instruction = "001110") then
			alu_control_sig <= ALU_CMD_XOR;
		elsif (alu_op = "11") AND (instruction = "001010") then
			alu_control_sig <= ALU_CMD_SLT;
		elsif (alu_op = "11") AND (instruction = "001011") then
			alu_control_sig <= ALU_CMD_SLTU;
		elsif (alu_op = "11") AND (instruction = "001000") then
			alu_control_sig <= ALU_CMD_ADD;
		elsif (alu_op = "11") AND (instruction = "001001") then
			alu_control_sig <= ALU_CMD_ADDU;
			
		else
			alu_control_sig <= ALU_CMD_DNTC;
		end if;
	end process;

end Behavioral;

