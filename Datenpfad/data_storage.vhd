----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:42:46 05/16/2015 
-- Design Name: 
-- Module Name:    data_storage - Behavioral 
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

------------------------------------------------------------------------------------
-- dieses modul entspricht "Datenspeicher" aus der abbildung im buch.
------------------------------------------------------------------------------------

entity data_storage is
    Port ( --in 
			  address_in 		: in  STD_LOGIC_VECTOR (31 downto 0);
           write_data_in 	: in  STD_LOGIC_VECTOR (31 downto 0);				
			  clk_in 			: in STD_LOGIC;
			  
			  --in steuersignale
			  mem_read_in 	: in  STD_LOGIC;
           mem_write_in : in  STD_LOGIC;
			  rst_in 		: in STD_LOGIC;															--was fr ein reset braucht man? low oder high aktiv?
			  
			  --in wishbone bus			  
			  wb_dat_in : in STD_LOGIC_VECTOR (31 downto 0);
			  wb_ack_in : in STD_LOGIC;
			  
			  --out
           read_data_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  
			  --out steuersignale
			  pipeline_en_out : out STD_LOGIC;
			  
			  --out wishbone bus
			  wb_adr_out		: out STD_LOGIC_VECTOR (31 downto 0);
			  wb_dat_out		: out STD_LOGIC_VECTOR (31 downto 0);
           wb_we_out			: out STD_LOGIC;
			  wb_sel_out 		: out STD_LOGIC_VECTOR (3 downto 0);							--byte select fr byte oder halfword operationen, vereinfacht aber immer alles 1
			  
			  wb_strobe_out  	: out STD_LOGIC;														--The strobe output [STB_O] indicates a valid data transfer cycle. It is used
																												--to qualify various other signals on the interface such as [SEL_O()].
			  
			  wb_cyc_out  		: out STD_LOGIC														--The cycle output [CYC_O], when asserted, indicates that a valid bus cycle is in
																												--progress. The signal is asserted for the duration of all bus cycles. For example,
																												--during a BLOCK transfer cycle there can be multiple data transfers. The [CYC_O] 
																												--signal is asserted during the first data transfer,and remains asserted until the 
																												--last data transfer
			);
			  
end data_storage;

architecture Behavioral of data_storage is

	type statevector is (idle_state, read_state, write_state);

	signal state : statevector; 
	signal nextstate : statevector; 

	--constant c_zustand       : statevector := "1000";

begin

	state_chg :	process(clk_in)
	begin
		if rising_edge(clk_in) then
			if (rst_in='1') then
				state <= idle_state;
			else
				state 	<= nextstate;
			end if;
		end if;
	end process;
	
	process(state, mem_read_in, mem_write_in, wb_ack_in)
	begin
		nextstate <= state;
		
		case state is
		when idle_state =>
			pipeline_en_out   <= '1';
			--restliche signale
		   wb_we_out			<= '0';
		   wb_sel_out 			<= (others => '-');						
		   wb_strobe_out  	<= '0';					
		   wb_cyc_out  		<= '0';	
			
			if (mem_read_in='1') then
				nextstate <= read_state;
				
				pipeline_en_out   <= '0';
				--restliche signale
--				wb_we_out			<= '0';
--				wb_sel_out 			<= (others => '1');						
--				wb_strobe_out  	<= '1';					
--				wb_cyc_out  		<= '1';		
			end if;					
			
			if (mem_write_in='1') then
				nextstate <= write_state;
				
				pipeline_en_out   <= '0';					
				--restliche signale
--				wb_we_out			<= '1';
--				wb_sel_out 			<= (others => '1');						
--				wb_strobe_out  	<= '1';					
--				wb_cyc_out  		<= '1';
			end if;
			
		when read_state =>		
			wb_strobe_out  	<= '1';					
		   wb_cyc_out  		<= '1';
			wb_we_out			<= '0';
			wb_sel_out 			<= (others => '1');				
			pipeline_en_out   <= '0';
			
			if (wb_ack_in='1') then
				nextstate 			<= idle_state;
				pipeline_en_out   <= '1';
			end if;
			
		when write_state =>
			--write abgeschlossen --> pipeline enable
			wb_strobe_out  	<= '1';					
		   wb_cyc_out  		<= '1';
			wb_we_out			<= '1';
			wb_sel_out 			<= (others => '1');	
			pipeline_en_out   <= '0';
			
			if (wb_ack_in='1') then
				nextstate 			<= idle_state;
				pipeline_en_out   <= '1';
			end if;
		end case;			
	end process;
	
	wb_adr_out			<= address_in;
	wb_dat_out			<= write_data_in;
	read_data_out		<= wb_dat_in;
	
end Behavioral;

