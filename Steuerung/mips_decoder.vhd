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

entity mips_decoder is
  
  port (
    insn       : in  std_logic_vector(31 downto 0);
    alu_cmd    : out ALU_CMD_TYPE;
    reg_dst    : out std_logic;
    branch     : out std_logic;
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
    alu_cmd <= ALU_CMD_DNTC;

    -- Decode main opcode.
    case insn(31 downto 26) is
      
        -----------------------------------------------------------------------
      when "000000" =>                  -- SPECIAL
        -- Control-signal defaults already assigned above.
        -- Add defaults common for almost all special instructions here.

        mem_write  <= '0'; --es muss nicht in Speicher geschrieben werden
        mem_read   <= '0'; --es muss nicht aus Speicher gelesen werden
        mem_to_reg <= '0'; --ALU-Ergebnis wird direkt in Register gespeichert

        -- Function code dependent assignments follow now.
        case insn(5 downto 0) is
          when "000000" =>              -- SLL
            alu_cmd    <= ALU_CMD_SLL;
            alu_src    <= '1';           --shamt-Wert wird benötigt
            reg_dst    <= '1';           --in rd schreiben
            reg_write  <= '1';           --in Register schreiben
            branch     <= '0';           --kein Sprung
          when "000010" =>              -- SRL
            alu_cmd    <= ALU_CMD_SRL;
            alu_src    <= '1';           --shamt-Wert wird benötigt
            reg_dst    <= '1';           --in rd schreiben
            reg_write  <= '1';           --in Register schreiben
            branch     <= '0';           --kein Sprung
          when "000011" =>              -- SRA
            alu_cmd <= ALU_CMD_SRA;
            
          when "000100" =>              -- SLLV
            alu_cmd <= ALU_CMD_SLL;
            
          when "000110" =>              -- SRLV
            alu_cmd <= ALU_CMD_SRL;
            
          when "000111" =>              -- SRAV
            alu_cmd <= ALU_CMD_SRA;

          when "001000" =>              -- JR
			
          when "001001" =>              -- JALR
            
          when "100000" =>              -- ADD
            alu_cmd    <= ALU_CMD_ADD;
        	reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben	
          when "100001" =>              -- ADDU
            alu_cmd <= ALU_CMD_ADDU;
            reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben
          when "100010" =>              -- SUB
            alu_cmd <= ALU_CMD_SUB;
            reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben
          when "100011" =>              -- SUBU
            alu_cmd <= ALU_CMD_SUBU;
            reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben
          when "100100" =>              -- AND
            alu_cmd <= ALU_CMD_AND;
            reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben
          when "100101" =>              -- OR
            alu_cmd <= ALU_CMD_OR;
            reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben
          when "100110" =>              -- XOR
            alu_cmd <= ALU_CMD_XOR;
            reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben
          when "100111" =>              -- NOR
            alu_cmd <= ALU_CMD_NOR;
            reg_dst    <= '1';          --in rd schreiben
        	branch     <= '0';		  --kein Sprung
        	alu_src    <= '0';		  --Wert aus Register wird benötigt
        	reg_write  <= '1';          --in Register schreiben
          when "101010" =>              -- SLT
            alu_cmd    <= ALU_CMD_SLT;
            reg_dst    <= '1';          --in rd schreiben
            branch     <= '0';          --kein Sprung
            alu_src    <= '0';          --Wert aus Register wird benötigt
            reg_write  <= '1';          --in Register schreiben                        
          when "101011" =>              -- SLTU
            alu_cmd <= ALU_CMD_SLTU;
			reg_dst    <= '1';          --in rd schreiben
            branch     <= '0';          --kein Sprung
            alu_src    <= '0';          --Wert aus Register wird benötigt
            reg_write  <= '1';          --in Register schreiben    
          when others => null;
        end case;

        -----------------------------------------------------------------------
      when "000010" =>                  -- J

      when "000011" =>                  -- JAL

      when "000100" =>                  -- BEQ

      when "000101" =>                  -- BNE

        -----------------------------------------------------------------------
      when "001000" =>                  -- ADDI
        alu_cmd    <= ALU_CMD_ADD;
        reg_dst    <= '0';		  --in rt schreiben
        branch     <= '0';          --kein Sprung
        alu_src    <= '1';          --immediate-Wert nehmen
        reg_write  <= '1';          --in Register schreiben
        mem_write  <= '0';          --es muss nicht in Speicher geschrieben werden
        mem_read   <= '0';          --es muss nicht aus Speicher gelesen werden
        mem_to_reg <= '0';          --ALU-Ergebnis wird direkt in Register gespeichert
      when "001001" =>                  -- ADDIU
        alu_cmd <= ALU_CMD_ADDU;
        reg_dst    <= '0';		  --in rt schreiben
        branch     <= '0';          --kein Sprung
        alu_src    <= '1';          --immediate-Wert nehmen
        reg_write  <= '1';          --in Register schreiben
        mem_write  <= '0';          --es muss nicht in Speicher geschrieben werden
        mem_read   <= '0';          --es muss nicht aus Speicher gelesen werden
        mem_to_reg <= '0';          --ALU-Ergebnis wird direkt in Register gespeichert
      when "001010" =>                  -- SLTI
        alu_cmd <= ALU_CMD_SLT;
        
      when "001011" =>                  -- SLTIU
        alu_cmd <= ALU_CMD_SLTU;
        
      when "001100" =>                  -- ANDI
        alu_cmd <= ALU_CMD_AND;
        reg_dst    <= '0';		  --in rt schreiben
        branch     <= '0';          --kein Sprung
        alu_src    <= '1';          --immediate-Wert nehmen
        reg_write  <= '1';          --in Register schreiben
        mem_write  <= '0';          --es muss nicht in Speicher geschrieben werden
        mem_read   <= '0';          --es muss nicht aus Speicher gelesen werden
        mem_to_reg <= '0';          --ALU-Ergebnis wird direkt in Register gespeichert
      when "001101" =>                  -- ORI
        alu_cmd <= ALU_CMD_OR;
        reg_dst    <= '0';		  --in rt schreiben
        branch     <= '0';          --kein Sprung
        alu_src    <= '1';          --immediate-Wert nehmen
        reg_write  <= '1';          --in Register schreiben
        mem_write  <= '0';          --es muss nicht in Speicher geschrieben werden
        mem_read   <= '0';          --es muss nicht aus Speicher gelesen werden
        mem_to_reg <= '0';          --ALU-Ergebnis wird direkt in Register gespeichert
      when "001110" =>                  -- XORI
        alu_cmd <= ALU_CMD_XOR;
        reg_dst    <= '0';		  --in rt schreiben
        branch     <= '0';          --kein Sprung
        alu_src    <= '1';          --immediate-Wert nehmen
        reg_write  <= '1';          --in Register schreiben
        mem_write  <= '0';          --es muss nicht in Speicher geschrieben werden
        mem_read   <= '0';          --es muss nicht aus Speicher gelesen werden
        mem_to_reg <= '0';          --ALU-Ergebnis wird direkt in Register gespeichert
      when "001111" =>                  -- LUI
        alu_cmd <= ALU_CMD_LUI;

        -----------------------------------------------------------------------
      when "100011" =>                  -- LW
        --TODO: alu_cmd <= ...;
        
      when "101011" =>                  -- SW
        --TODO: alu_cmd <= ...;
        
      when others => null;
    end case;
  end process;

end rtl;
