----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:36:11 06/26/2015 
-- Design Name: 
-- Module Name:    MEMWB_flush_mux - Behavioral 
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

entity MEMWB_flush_mux is
Port (	-- Steuersignal
			flush : in STD_LOGIC;
			-- alle Eingänge
			--wb
			mem_to_reg_in : in STD_LOGIC;
			reg_write_in : in STD_LOGIC;
			
			-- alle Ausgänge
			--wb
			mem_to_reg_out : out STD_LOGIC;
			reg_write_out : out STD_LOGIC);
end MEMWB_flush_mux;

architecture Behavioral of MEMWB_flush_mux is

begin
	PROCESS(flush, mem_to_reg_in, reg_write_in)
	BEGIN
	
		mem_to_reg_out 	<=	mem_to_reg_in;
		reg_write_out 		<=	reg_write_in;

		IF (flush = '1') THEN
			mem_to_reg_out 	<=	'0';
			reg_write_out 		<=	'0';
		END IF;
	END PROCESS;
end Behavioral;

