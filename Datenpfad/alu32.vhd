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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY alu32 IS
PORT (
	CTRL : IN std_logic_vector(3 DOWNTO 0);
	A, B : IN std_logic_vector(31 DOWNTO 0);
	S : OUT std_logic_vector(31 DOWNTO 0);
	ZERO : std_logic);
	
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

--#################################################
--# TODO: zero ausgang
--#################################################

BEGIN
    PROCESS(A,B,CTRL)
    BEGIN	
        CASE CTRL IS
           WHEN "0000"  =>   S <= A AND B;          															-- and
           WHEN "0001"  =>   S <= A OR B;           															-- or
           WHEN "0010"  =>   S <= std_logic_vector(unsigned(A) + unsigned(B));            		-- add
           WHEN "0110"  =>   S <= std_logic_vector(unsigned(A) - unsigned(B));            		-- substract
           WHEN "1100"  =>   S <= A NOR B;          															-- nor
           WHEN "1101"  =>   S <= std_logic_vector(unsigned(A) sll to_integer(unsigned(B)));    -- shift right
           WHEN "1111"  =>   S <= std_logic_vector(unsigned(A) srl to_integer(unsigned(B)));    -- shift left
			  WHEN "0111"  =>   S <= to_slv(signed(A) > signed(B));            							-- set on less than
           WHEN OTHERS  =>   S <= (OTHERS => '-');  															-- don't care for S
        END CASE;
    END PROCESS;
END behavioural;