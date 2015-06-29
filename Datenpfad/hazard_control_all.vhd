----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:02:10 06/09/2015 
-- Design Name: 
-- Module Name:    hazard_control_all - Behavioral 
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

use work.mips.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_control_all is
	Port (alu_zero : in  STD_LOGIC;
			branch : in STD_LOGIC;
			branch_cond : in STD_LOGIC;
			
			-- IDEX_MUX-Eingänge
			--ex
			IDEX_reg_dst_ctrl_in : in STD_LOGIC;
			IDEX_alu_src_in : in STD_LOGIC;
			IDEX_alu_op_in : in STD_LOGIC_VECTOR (1 downto 0);
			--mem
			IDEX_mem_write_in : in STD_LOGIC;
			IDEX_mem_read_in : in STD_LOGIC;
			IDEX_branch_in : in STD_LOGIC;
			IDEX_branch_cond_in : in STD_LOGIC;
			--wb
			IDEX_mem_to_reg_in : in STD_LOGIC;
			IDEX_reg_write_in : in STD_LOGIC;
			
			-- EXMEM_MUX-Eingänge
			--mem
			EXMEM_mem_write_in : in STD_LOGIC;
			EXMEM_mem_read_in : in STD_LOGIC;
			EXMEM_branch_in : in STD_LOGIC;
			EXMEM_branch_cond_in : in STD_LOGIC;
			--wb
			EXMEM_mem_to_reg_in : in STD_LOGIC;
			EXMEM_reg_write_in : in STD_LOGIC;
			
			-- MEMWB_MUX-Eingänge
			--wb
			MEMWB_mem_to_reg_in : in STD_LOGIC;
			MEMWB_reg_write_in : in STD_LOGIC;
			
			-- IDEX_MUX-Ausgänge
			--ex
			IDEX_reg_dst_ctrl_out : out STD_LOGIC;
			IDEX_alu_src_out : out STD_LOGIC;
			IDEX_alu_op_out : out STD_LOGIC_VECTOR (1 downto 0);
			--mem
			IDEX_mem_write_out : out STD_LOGIC;
			IDEX_mem_read_out : out STD_LOGIC;
			IDEX_branch_out : out STD_LOGIC;
			IDEX_branch_cond_out : out STD_LOGIC;
			--wb
			IDEX_mem_to_reg_out : out STD_LOGIC;
			IDEX_reg_write_out : out STD_LOGIC;
			
			-- EXMEM_MUX-Ausgänge
			--mem
			EXMEM_mem_write_out : out STD_LOGIC;
			EXMEM_mem_read_out : out STD_LOGIC;
			EXMEM_branch_out : out STD_LOGIC;
			EXMEM_branch_cond_out : out STD_LOGIC;
			--wb
			EXMEM_mem_to_reg_out : out STD_LOGIC;
			EXMEM_reg_write_out : out STD_LOGIC;
			
			-- MEMWB_MUX-Ausgänge
			--wb
			MEMWB_mem_to_reg_out : out STD_LOGIC;
			MEMWB_reg_write_out : out STD_LOGIC);
end hazard_control_all;


architecture Structural of hazard_control_all is

	--output signale der hazard_control_unit
	signal flush_sig	: std_logic;
	
begin
	hazard_control_unit : entity work.hazard_control_unit
	port map (EXMEM_alu_zero 		=>	alu_zero,
				 EXMEM_branch 			=>	branch,
				 EXMEM_branch_cond 	=>	branch_cond,
				 flush					=> flush_sig
				 );
				 
	IDEX_flush_mux : entity work.IDEX_flush_mux
	port map (
			flush						=> flush_sig,
			
			reg_dst_ctrl_in		=> IDEX_reg_dst_ctrl_in,
			alu_src_in				=> IDEX_alu_src_in,
			alu_op_in				=> IDEX_alu_op_in,
			mem_write_in			=> IDEX_mem_write_in,
			mem_read_in				=> IDEX_mem_read_in,
			branch_in				=> IDEX_branch_in,
			branch_cond_in			=> IDEX_branch_cond_in,
			mem_to_reg_in			=> IDEX_mem_to_reg_in,
			reg_write_in			=> IDEX_reg_write_in,
			
			reg_dst_ctrl_out		=> IDEX_reg_dst_ctrl_out,
			alu_src_out				=> IDEX_alu_src_out,
			alu_op_out				=> IDEX_alu_op_out,
			mem_write_out			=> IDEX_mem_write_out,
			mem_read_out			=> IDEX_mem_read_out,
			branch_out				=> IDEX_branch_out,
			branch_cond_out		=> IDEX_branch_cond_out,
			mem_to_reg_out			=> IDEX_mem_to_reg_out,
			reg_write_out			=> IDEX_reg_write_out
			);
			
	EXMEM_flush_mux : entity work.EXMEM_flush_mux
	port map (
			flush						=> flush_sig,
			
			mem_write_in			=> EXMEM_mem_write_in,
			mem_read_in				=> EXMEM_mem_read_in,
			branch_in				=> EXMEM_branch_in,
			branch_cond_in			=> EXMEM_branch_cond_in,
			mem_to_reg_in			=> EXMEM_mem_to_reg_in,
			reg_write_in			=> EXMEM_reg_write_in,
			
			mem_write_out			=> EXMEM_mem_write_out,
			mem_read_out			=> EXMEM_mem_read_out,
			branch_out				=> EXMEM_branch_out,
			branch_cond_out		=> EXMEM_branch_cond_out,
			mem_to_reg_out			=> EXMEM_mem_to_reg_out,
			reg_write_out			=> EXMEM_reg_write_out
			);

	MEMWB_flush_mux : entity work.MEMWB_flush_mux
	port map (
			flush						=> flush_sig,
			
			mem_to_reg_in			=> MEMWB_mem_to_reg_in,
			reg_write_in			=> MEMWB_reg_write_in,
			
			mem_to_reg_out			=> MEMWB_mem_to_reg_out,
			reg_write_out			=> MEMWB_reg_write_out
			);

end Structural;

