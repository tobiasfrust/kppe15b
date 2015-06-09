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
-- Package: mips
-- Author(s): Martin Zabel
--
-- Start of "mips" package.
-- Provided for "Komplexpraktikum Prozessorentwurf".
--
-- Text editor setup: tab-width = 8, indentation = 2
--
-- Revision:    $Revision: 1.2 $
-- Last change: $Date: 2009-02-10 14:45:28 $
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package mips is

  -----------------------------------------------------------------------------
  -- Type definitions
  -----------------------------------------------------------------------------
  
  -- The encoding of the ALU operations. Only change in conjunction
  -- with the ALU implementation.
  -- To be used by the decoder.
  subtype ALU_CMD_TYPE is std_logic_vector(3 downto 0);
  constant ALU_CMD_SLL  : ALU_CMD_TYPE := "0000";
  constant ALU_CMD_LUI  : ALU_CMD_TYPE := "0001";
  constant ALU_CMD_SRL  : ALU_CMD_TYPE := "0010";
  constant ALU_CMD_SRA  : ALU_CMD_TYPE := "0011";
  constant ALU_CMD_AND  : ALU_CMD_TYPE := "0100";
  constant ALU_CMD_OR   : ALU_CMD_TYPE := "0101";
  constant ALU_CMD_XOR  : ALU_CMD_TYPE := "0110";
  constant ALU_CMD_NOR  : ALU_CMD_TYPE := "0111";
  constant ALU_CMD_ADD  : ALU_CMD_TYPE := "1000";
  constant ALU_CMD_ADDU : ALU_CMD_TYPE := "1001";
  constant ALU_CMD_SUB  : ALU_CMD_TYPE := "1010";
  constant ALU_CMD_SUBU : ALU_CMD_TYPE := "1011";
  constant ALU_CMD_SLT  : ALU_CMD_TYPE := "1110";
  constant ALU_CMD_SLTU : ALU_CMD_TYPE := "1111";
  constant ALU_CMD_DNTC : ALU_CMD_TYPE := "----";
  
  -----------------------------------------------------------------------------
  -- Component Declarations
  -----------------------------------------------------------------------------
  component mips_alu
    port (
      src1 : in  std_logic_vector(31 downto 0);
      src2 : in  std_logic_vector(31 downto 0);
      sa   : in  std_logic_vector(4 downto 0);
      cmd  : in  ALU_CMD_TYPE;
      ov   : out std_logic;
      res  : out std_logic_vector (31 downto 0));
  end component;
end mips;
