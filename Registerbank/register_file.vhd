library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port ( read_address1_in : in  STD_LOGIC_VECTOR (4 downto 0);
           read_address2_in : in  STD_LOGIC_VECTOR (4 downto 0);
           write_address_in : in  STD_LOGIC_VECTOR (4 downto 0);
           write_data_in : in  STD_LOGIC_VECTOR (31 downto 0);
           read_data1_out : out  STD_LOGIC_VECTOR (31 downto 0);
           read_data2_out : out  STD_LOGIC_VECTOR (31 downto 0);
			  clk : in STD_LOGIC;
			  --Steuersignale
			  reg_write_in : in STD_LOGIC);
end register_file;

architecture Behavioral of register_file is
	type reg is array(31 downto 0) of std_logic_vector(31 downto 0);   			--32 Register, die 32 Bit breit sind
	signal registers : reg;
begin	

	process(read_address1_in, read_address2_in, write_address_in, write_data_in)
	begin
		read_data1_out <= registers(to_integer(unsigned(read_address1_in)));					--asynchrones lesen, initiale Zuweisung
		read_data2_out <= registers(to_integer(unsigned(read_address2_in)));
		
		if read_address1_in = write_address_in then  												--Forwarding/Bypass
			read_data1_out <= write_data_in;
		end if;
		if read_address2_in = write_address_in then  
			read_data2_out <= write_data_in;
		end if;

		if (read_address1_in="00000") then															--Register 0 liefert immer 0
			read_data1_out <= x"00000000";
		end if;
		if (read_address2_in="00000") then
			read_data2_out <= x"00000000";
		end if;
	end process;
	

	process (clk)
	begin
		if rising_edge(clk) then
		
			if (reg_write_in = '1') then															--synchrones Schreiben
			  registers(to_integer(unsigned(write_address_in))) <= write_data_in;  	
			  
		end if;	
		
		end if;
	end process;

end Behavioral;

