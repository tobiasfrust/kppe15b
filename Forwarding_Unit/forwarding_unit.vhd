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
-- use work.mips.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

ENTITY forwarding_unit IS
PORT(
	EXMEM_reg_write : IN  std_logic;
	MEMWB_reg_write : IN  std_logic;
	EXMEM_adressRd : IN  std_logic_vector(31 downto 0);
	MEMWB_adressRd : IN  std_logic_vector(31 downto 0);
	IDEX_adressRs : IN  std_logic_vector(31 downto 0);
	IDEX_adressRt : IN  std_logic_vector(31 downto 0);
	forward_Rs : OUT  std_logic_vector(1 downto 0);
	forward_Rt : OUT  std_logic_vector(1 downto 0)
    );
END forwarding_unit;


ARCHITECTURE behavioural OF forwarding_unit IS

signal sig_forw_EXMEM_to_Rs	:	std_logic;
signal sig_forw_EXMEM_to_Rt	:	std_logic;
signal sig_forw_MEMWB_to_Rs	:	std_logic;
signal sig_forw_MEMWB_to_Rt	:	std_logic;

BEGIN
	PROCESS(EXMEM_reg_write, MEMWB_reg_write, EXMEM_adressRd, MEMWB_adressRd, IDEX_adressRs, IDEX_adressRt)
	BEGIN
	
		sig_forw_EXMEM_to_Rs	<=	'0';
		sig_forw_EXMEM_to_Rt	<=	'0';
		sig_forw_MEMWB_to_Rs	<=	'0';
		sig_forw_MEMWB_to_Rt	<=	'0';

		if ((EXMEM_reg_write = '1') and (EXMEM_adressRd /= x"00000000")) then
			if (EXMEM_adressRd = IDEX_adressRs) then
				sig_forw_EXMEM_to_Rs <= '1';
			end if;
			if (EXMEM_adressRd = IDEX_adressRt) then
				sig_forw_EXMEM_to_Rt <= '1';
			end if;
		end if;
		if ((MEMWB_reg_write = '1') and (MEMWB_adressRd /= x"00000000")) then
			if (MEMWB_adressRd = IDEX_adressRs) then
				sig_forw_MEMWB_to_Rs <= '1';
			end if;
			if (MEMWB_adressRd = IDEX_adressRt) then
				sig_forw_MEMWB_to_Rt <= '1';
			end if;
		end if;

	END PROCESS;
	
	PROCESS(sig_forw_EXMEM_to_Rs, sig_forw_EXMEM_to_Rt, sig_forw_MEMWB_to_Rs, sig_forw_MEMWB_to_Rt)
	BEGIN
	
		forward_Rs			<=	"00";		-- default: kein Forwarding
		forward_Rt			<=	"00";		-- default: kein Forwarding
		
		if (sig_forw_EXMEM_to_Rs = '1') then
			forward_Rs		<=	"01";
		elsif (sig_forw_MEMWB_to_Rs = '1') then
			forward_Rs		<=	"10";
		end if;
		if (sig_forw_EXMEM_to_Rt = '1') then
			forward_Rt		<=	"01";
		elsif (sig_forw_MEMWB_to_Rt = '1') then
			forward_Rt		<=	"10";
		end if;
		
	END PROCESS;
	
END behavioural;
