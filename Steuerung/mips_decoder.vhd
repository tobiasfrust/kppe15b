--
-- Copyright (c) 2008
-- Technische Universitaet Dresden, Dresden, Germany
-- Faculty of Computer Science
-- Institute for Computer Engineering
-- Chair for VLSI-Design, Diagnostics and Architecture
-- 
-- For internal educational use only.
-- The distribution of source code or generated files
-- is prohibited.
--

--
-- Entity: mips_decoder
-- Author(s): Martin Zabel
--
-- Start of MIPS decoder.
-- Provided for "Komplexpraktikum Prozessorentwurf".
--
-- Text editor setup: tab-width = 8, indentation = 2
--
-- Revision:    $Revision: 1.1 $
-- Last change: $Date: 2009-02-10 15:00:28 $
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.mips.all;

--###############################################################################################
--# Es gibt 4 Befehlsklassen: R-Befehle, Speicherbefehle, Branch, Jump
--#
--# aluOp 00: Speicherbefehle (Alu fhrt Addition aus)
--# aluOp 10: Branch (Alu fhrt Subtraktion zb fr beq aus)
--# aluOp 10: R-Befehle (Alu Operation durch funct bestimmt)
--# aluOp 11: Immediate Befehle (Instruction bestimmt Alu Operation, weil funct Feld fehlt)
--###############################################################################################

entity mips_decoder is
  
  port (
    insn       : in  std_logic_vector(31 downto 0);
    alu_op    	: out std_logic_vector(1 downto 0);
    reg_dst    : out std_logic;
    branch     : out std_logic_vector(1 downto 0);		-- 00: bne		11: beq		01: kein Sprun		10: normaler (unconditional) Jump
    mem_read   : out std_logic;
    mem_to_reg : out std_logic;
    mem_write  : out std_logic;
    alu_src    : out std_logic;
    reg_write  : out std_logic
	);

end mips_decoder;

architecture rtl of mips_decoder is

begin  -- rtl

  -- Hierarchical decoding of MIPS instructions
  process (insn)
  begin  -- process
    -- Default Assignments

    -- Decode main opcode.
    case insn(31 downto 26) is
      
        -----------------------------------------------------------------------
      when "000000" =>                 -- SPECIAL
        -- Control-signal defaults already assigned above.
        -- Add defaults common for almost all special instructions here.

        mem_write  <= '0';					--es muss nicht in Speicher geschrieben werden
        mem_read   <= '0';					--es muss nicht aus Speicher gelesen werden
        mem_to_reg <= '0'; --standardmaessig wird das was der WB master ausgibt ins regfile gespeichert
		  reg_write  <= '0'; 

        -- Function code dependent assignments follow now.
        case insn(5 downto 0) is
          when "000000" =>             -- SLL
            alu_op     <= "10";        -- R-Befehl
            alu_src    <= '1';         --shamt-Wert wird bentigt
            reg_dst    <= '1';         --in rd schreiben
            reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';           --ALU-Ergebnis wird direkt in Register gespeichert
            branch     <= "01";        --kein Sprung
          when "000010" =>             -- SRL
            alu_op	  <= "10";
            alu_src    <= '1';         --shamt-Wert wird bentigt
            reg_dst    <= '1';         --in rd schreiben
            reg_write  <= '1';         --in Register schreiben
            branch     <= "01";        --kein Sprung
				mem_to_reg <= '1';           --ALU-Ergebnis wird direkt in Register gespeichert
          when "000011" =>             -- SRA
            alu_op <= "10";
				alu_src    <= '1';           --shamt-Wert wird bentigt
            reg_dst    <= '1';           --in rd schreiben
            reg_write  <= '1';           --in Register schreiben
            branch     <= '0';           --kein Sprung
				mem_to_reg <= '1';           --ALU-Ergebnis wird direkt in Register gespeichert
            
          when "000100" =>             -- SLLV
            alu_op <= "10";
            
          when "000110" =>             -- SRLV
            alu_op <= "10";
            
          when "000111" =>             -- SRAV
            alu_op <= "10";

          when "001000" =>             -- JR
				branch     <= "10";			--unconditional Jump
			
          when "001001" =>             -- JALR
				branch     <= "10";			--unconditional Jump
            
          when "100000" =>             -- ADD
            alu_op	  <= "10";
				reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben	
			mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "100001" =>             -- ADDU
            alu_op	  <= "10";
            reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "100010" =>             -- SUB
            alu_op     <= "10";
            reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "100011" =>             -- SUBU
            alu_op	  <= "10";
            reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "100100" =>             -- AND
            alu_op	  <= "10";
            reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "100101" =>             -- OR
            alu_op	  <= "10";
            reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "100110" =>             -- XOR
            alu_op	  <= "10";
            reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "100111" =>             -- NOR
            alu_op	  <= "10";
            reg_dst    <= '1';         --in rd schreiben
				branch     <= "01";			--kein Sprung
				alu_src    <= '0';			--Wert aus Register wird bentigt
				reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "101010" =>             -- SLT
            alu_op     <= "10";
            reg_dst    <= '1';         --in rd schreiben
            branch     <= "01";        --kein Sprung
            alu_src    <= '0';         --Wert aus Register wird bentigt
            reg_write  <= '1';         --in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when "101011" =>             -- SLTU
            alu_op	  <= "10";
				reg_dst    <= '1';         --in rd schreiben
            branch     <= "01";        --kein Sprung
            alu_src    <= '0';         --Wert aus Register wird bentigt
            reg_write  <= '1';      	--in Register schreiben
				mem_to_reg <= '1';          --ALU-Ergebnis wird direkt in Register gespeichert
          when others => null;
        end case;

		--TODO: Sprungbefehle fertig machen, reg_dst prüfen!!!
        -----------------------------------------------------------------------
		when "000010" =>              -- J
			alu_op 	  <= "01";
			reg_dst    <= '0';         --nicht in rd schreiben
			branch     <= "10";		  	--unconditional Jump
			alu_src    <= '0';         --Wert aus Register wird nicht bentigt
			reg_write  <= '0';         --nicht in Register schreiben        
		when "000011" =>              -- JAL
			alu_op 	  <= "01";
			reg_dst    <= '0';         --nicht in rd schreiben
			branch     <= "10";		  	--unconditional Jump
			alu_src    <= '0';         --Wert aus Register wird nicht bentigt
			reg_write  <= '0';         --nicht in Register schreiben        
		when "000100" =>              -- BEQ
			alu_op	  <= "01";
			reg_dst    <= '0';         --nicht in rd schreiben
			branch     <= "11";		  	--Sprung, wenn Zero = '1'
			alu_src    <= '0';         --Wert aus Register wird nicht bentigt
			reg_write  <= '0';         --nicht in Register schreiben        
		when "000101" =>              -- BNE
			alu_op	  <= "01";
			reg_dst    <= '0';         --nicht in rd schreiben
			branch     <= "00";		  	--Sprung, wenn Zero = '0'
			alu_src    <= '0';         --Wert aus Register wird nicht bentigt
			reg_write  <= '0';         --nicht in Register schreiben        
        -----------------------------------------------------------------------
		when "001000" =>              -- ADDI
			alu_op     <= "11";
			reg_dst    <= '0';		  	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';			--ALU-Ergebnis wird direkt in Register gespeichert
		when "001001" =>              -- ADDIU
			alu_op		 <= "11";
			reg_dst    <= '0';		  	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';         --ALU-Ergebnis wird direkt in Register gespeichert
		when "001010" =>              -- SLTI
			alu_op		 <= "11";
			reg_dst    <= '0';		  	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';         --ALU-Ergebnis wird direkt in Register gespeichert
		when "001011" =>              -- SLTIU
			alu_op		 <= "11";
			reg_dst    <= '0';		  	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';         --ALU-Ergebnis wird direkt in Register gespeichert
		when "001100" =>              -- ANDI
			alu_op		 <= "11";
			reg_dst    <= '0';		 	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';         --ALU-Ergebnis wird direkt in Register gespeichert
		when "001101" =>              -- ORI
			alu_op		 <= "11";
			reg_dst    <= '0';		  	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';         --ALU-Ergebnis wird direkt in Register gespeichert
		when "001110" =>              -- XORI
			alu_op		 <= "11";
			reg_dst    <= '0';		  	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';         --ALU-Ergebnis wird direkt in Register gespeichert
		when "001111" =>              -- LUI
			alu_op		 <= "11";
			reg_dst    <= '0';		  	--in rt schreiben
			branch     <= "01";        --kein Sprung
			alu_src    <= '1';         --immediate-Wert nehmen
			reg_write  <= '1';         --in Register schreiben
			mem_write  <= '0';         --es muss nicht in Speicher geschrieben werden
			mem_read   <= '0';         --es muss nicht aus Speicher gelesen werden
			mem_to_reg <= '1';         --ALU-Ergebnis wird direkt in Register gespeichert
			-----------------------------------------------------------------------
		when "100011" =>              -- LW
        alu_op  <= "11";
		  reg_dst <= '0';
        branch     <= '01';          --kein Sprung
        alu_src    <= '1';          --immediate-Wert nehmen
		  reg_write  <= '1';          --in Register schreiben
		  mem_write  <= '0';          --es muss nicht in Speicher geschrieben werden
		  mem_read   <= '1';          --es muss aus Speicher gelesen werden
		  mem_to_reg <= '0';          --ALU-Ergebnis wird nicht direkt in Register gespeichert
		when "101011" =>              -- SW
        alu_op  <= "11";
		  reg_dst <= '0';
        branch     <= '0';          --kein Sprung
        alu_src    <= '1';          --immediate-Wert nehmen
		  reg_write  <= '0';          --in Register schreiben
		  mem_write  <= '1';          --es muss in Speicher geschrieben werden
		  mem_read   <= '0';          --es muss nicht aus Speicher gelesen werden
		  mem_to_reg <= '0';          --ALU-Ergebnis wird nicht direkt in Register gespeichert

		when others => null;
    end case;
  end process;

end rtl;
