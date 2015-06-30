----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:36:11 06/26/2015 
-- Design Name: 
-- Module Name:    IDEX_flush_mux - Behavioral 
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

entity IDEX_flush_mux is
Port (	-- Steuersignal
			flush : in STD_LOGIC;
			-- alle Eingänge
			--ex
			reg_dst_ctrl_in : in STD_LOGIC;
			alu_src_in : in STD_LOGIC;
			alu_op_in : in STD_LOGIC_VECTOR (1 downto 0);
			--mem
			mem_write_in : in STD_LOGIC;
			mem_read_in : in STD_LOGIC;
			branch_in : in STD_LOGIC;
			branch_cond_in : in STD_LOGIC;
			--wb
			mem_to_reg_in : in STD_LOGIC;
			reg_write_in : in STD_LOGIC;
			
			-- alle Ausgänge
			--ex
			reg_dst_ctrl_out : out STD_LOGIC;
			alu_src_out : out STD_LOGIC;
			alu_op_out : out STD_LOGIC_VECTOR (1 downto 0);
			--mem
			mem_write_out : out STD_LOGIC;
			mem_read_out : out STD_LOGIC;
			branch_out : out STD_LOGIC;
			branch_cond_out : out STD_LOGIC;
			--wb
			mem_to_reg_out : out STD_LOGIC;
			reg_write_out : out STD_LOGIC);
end IDEX_flush_mux;

architecture Behavioral of IDEX_flush_mux is

begin
	PROCESS(flush, reg_dst_ctrl_in, alu_src_in, alu_op_in, mem_write_in, mem_read_in, branch_in, branch_cond_in, mem_to_reg_in, reg_write_in)
	BEGIN
	
		reg_dst_ctrl_out	<=	reg_dst_ctrl_in;
		alu_src_out 		<=	alu_src_in;
		alu_op_out 			<=	alu_op_in;
		mem_write_out 		<=	mem_write_in;
		mem_read_out 		<=	mem_read_in;
		branch_out	 		<=	branch_in;
		branch_cond_out 	<=	branch_cond_in;
		mem_to_reg_out 	<=	mem_to_reg_in;
		reg_write_out 		<=	reg_write_in;

		IF (flush = '1') THEN
			reg_dst_ctrl_out	<=	'0';
			alu_src_out 		<=	'0';
			alu_op_out 			<=	"00";
			mem_write_out 		<=	'0';
			mem_read_out 		<=	'0';
			branch_out 			<=	'0';
			branch_cond_out 	<=	'0';
			mem_to_reg_out 	<=	'0';
			reg_write_out 		<=	'0';
		END IF;
	END PROCESS;
end Behavioral;

