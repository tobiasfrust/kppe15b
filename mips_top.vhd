----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:02:10 06/09/2015 
-- Design Name: 
-- Module Name:    mips_top - Behavioral 
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

entity mips_top is
    Port ( instruction_in : in  STD_LOGIC_VECTOR (31 downto 0);
	        clk_in            : in std_logic);
end mips_top;

architecture Behavioral of mips_top is

signal alu_cmd_control_out    : ALU_CMD_TYPE;
signal reg_dst_control_out    : std_logic;
signal branch_control_out     : std_logic;
signal mem_read_control_out   : std_logic;
signal mem_to_reg_control_out : std_logic;
signal mem_write_control_out  : std_logic;
signal alu_src_control_out    : std_logic;
signal reg_write_control_out  : std_logic;

begin
	decoder : entity work.mips_decoder
	port map (instruction_in => insn,
				 alu_cmd        => alu_cmd_control_out,
				 reg_dst        => reg_dst_control_out,
				 branch         => branch_control_out,
				 mem_read       => mem_read_control_out,
				 mem_to_reg     => mem_to_reg_control_out,
				 mem_write      => mem_write_control_out,
				 alu_src        => alu_src_control_out,
				 reg_write      => reg_write_control_out
				 );
				 
	datapath : entity work.datapath_module
	port map (clk_in                 => clk,
				 instruction_in         => instruction_in,
				 reg_dst_control_out    => reg_dst_ctrl_in,
				 alu_src_control_out    => alu_src_in,
				 alu_cmd_control_out    => alu_op_in,
				 mem_write_control_out  => mem_write_in,
				 mem_red_control_out    => mem_read_in,
				 branch_control_out     => branch_in,
				 mem_to_reg_control_out => mem_to_reg_in,
				 reg_write_control_unit => mem_reg_write_in);

end Behavioral;

