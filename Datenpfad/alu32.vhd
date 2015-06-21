----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.05.2015 17:22:43
-- Design Name: 
-- Module Name: alu - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use work.mips.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY alu32 IS
PORT (
	CTRL : IN std_logic_vector(3 DOWNTO 0);
	A, B : IN std_logic_vector(31 DOWNTO 0);
	S : OUT std_logic_vector(31 DOWNTO 0);
	ZERO : OUT std_logic);
	
END alu32;

ARCHITECTURE behavioural OF alu32 IS

function to_slv (a : boolean) return STD_LOGIC_VECTOR is
begin
	if a then
		return (31 DOWNTO 1 => '0') & '1';
	else
		return (31 DOWNTO 0 => '0');
	end if;
end;

BEGIN
    PROCESS(A,B,CTRL)
    BEGIN	
        CASE CTRL IS
           WHEN ALU_CMD_AND	=>   S <= A AND B;          															-- and
           WHEN ALU_CMD_OR		=>   S <= A OR B;           															-- or
			  WHEN ALU_CMD_XOR	=>   S <= A XOR B;          															-- XOR
			  WHEN ALU_CMD_ADD	=>   S <= std_logic_vector(signed(A) + signed(B));            				-- add
           WHEN ALU_CMD_ADDU  =>   S <= std_logic_vector(unsigned(A) + unsigned(B));            		-- addu
			  WHEN ALU_CMD_SUB	=>   S <= std_logic_vector(signed(A) - signed(B));            				-- sub
           WHEN ALU_CMD_SUBU  =>   S <= std_logic_vector(unsigned(A) - unsigned(B));            		-- subu
           WHEN ALU_CMD_NOR	=>   S <= A NOR B;          															-- nor
           WHEN ALU_CMD_SLL	=>   S <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B)));    -- shift right
           WHEN ALU_CMD_SRL	=>   S <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B)));    -- shift left
			  WHEN ALU_CMD_SLT	=>   S <= to_slv(signed(A) > signed(B));											-- set on less than
				--TODO: SLTU, SRA, LUI
           WHEN OTHERS			=>   S <= (OTHERS => '-');  															-- don't care for S
        END CASE;
    END PROCESS;
END behavioural;