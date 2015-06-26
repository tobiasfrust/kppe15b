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

function to_lui (a : boolean) return STD_LOGIC_VECTOR is
begin
	if a then
		return (31 DOWNTO 1 => '0') & '1';
	else
		return (31 DOWNTO 0 => '0');
	end if;
end;

signal s_intern : std_logic_vector(31 DOWNTO 0);

BEGIN
    PROCESS(A,B,CTRL)
    BEGIN	
        CASE CTRL IS
           WHEN ALU_CMD_AND	=>   s_intern <= A AND B;          																					-- and
           WHEN ALU_CMD_OR		=>   s_intern <= A OR B;           																					-- or
			  WHEN ALU_CMD_XOR	=>   s_intern <= A XOR B;          																					-- XOR
			  WHEN ALU_CMD_ADD	=>   s_intern <= std_logic_vector(signed(A) + signed(B));            									-- add
           WHEN ALU_CMD_ADDU  =>   s_intern <= std_logic_vector(unsigned(A) + unsigned(B));            								-- addu
			  WHEN ALU_CMD_SUB	=>   s_intern <= std_logic_vector(signed(A) - signed(B));            									-- sub
           WHEN ALU_CMD_SUBU  =>   s_intern <= std_logic_vector(unsigned(A) - unsigned(B));            								-- subu
           WHEN ALU_CMD_NOR	=>   s_intern <= A NOR B;          																					-- nor
           WHEN ALU_CMD_SLL	=>   s_intern <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B(10 DOWNTO 6))));			-- shift right
           WHEN ALU_CMD_SRL	=>   s_intern <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B(10 DOWNTO 6))));			-- shift left
			  WHEN ALU_CMD_SLT	=>   s_intern <= to_slv(signed(A) < signed(B));																	-- set on less than
			  WHEN ALU_CMD_SLTU	=>   s_intern <= to_slv(unsigned(A) < unsigned(B));															-- set less than unsigned
			  WHEN ALU_CMD_SRA	=>   s_intern <= std_logic_vector(shift_right(signed(A),to_integer(unsigned(B(10 DOWNTO 6)))));	--to_integer(unsigned(B(10 DOWNTO 6))));		-- shift left
			  WHEN ALU_CMD_LUI	=>   s_intern <= std_logic_vector((unsigned(B(15 DOWNTO 0))) & x"0000");								-- load upper immediate
           WHEN OTHERS			=>   s_intern <= (OTHERS => '-');  																					-- don't care for S
        END CASE;
    END PROCESS;
	 
	 PROCESS(s_intern)	 
    BEGIN
	 ZERO <= '0';
      IF (s_intern = x"00000000") THEN
			ZERO <= '0';
		END IF;
	 S <= s_intern;	
	 END PROCESS;
	 
END behavioural;