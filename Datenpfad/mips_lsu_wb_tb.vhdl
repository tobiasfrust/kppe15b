--
-- Copyright (c) 2015
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
-- Entity: mips_lsu_wb_tb
-- Author(s): Martin Zabel
-- 
-- Testbench for mips_lsu_wb.
--
library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity mips_lsu_wb_tb is

end entity mips_lsu_wb_tb;

-------------------------------------------------------------------------------

architecture sim of mips_lsu_wb_tb is

  -- component generics
  constant WB_O_REG : boolean := true;
  constant WB_I_REG : boolean := false;

  -- component ports
  signal clk	  : std_logic := '1';
  signal rst	  : std_logic;
  signal cmd	  : std_logic_vector(1 downto 0);
  signal addr	  : std_logic_vector(31 downto 0);
  signal wdata	  : std_logic_vector(31 downto 0);
  signal rdata	  : std_logic_vector(31 downto 0);
  signal pipe_en  : std_logic;
  signal wb_cyc_o : std_logic;
  signal wb_stb_o : std_logic;
  signal wb_we_o  : std_logic;
  signal wb_sel_o : std_logic_vector(3 downto 0);
  signal wb_adr_o : std_logic_vector(31 downto 0);
  signal wb_dat_o : std_logic_vector(31 downto 0);
  signal wb_ack_i : std_logic;
  signal wb_dat_i : std_logic_vector(31 downto 0);

  -- simulation control
  signal STOPPED : boolean := false;
  
begin  -- architecture sim

  -- component instantiation
  UUT: entity work.data_storage
--    generic map (
--      WB_O_REG => WB_O_REG,
--      WB_I_REG => WB_I_REG
--		)
    port map (
      clk_in      => clk,
      rst_in      => rst,
		
      mem_read_in => cmd(1),
		mem_write_in => cmd(1) and cmd(0),
		
      address_in   => addr,
      write_data_in    => wdata,
      read_data_out    => rdata,
      pipeline_en_out  => pipe_en,
		
      wb_cyc_out => wb_cyc_o,
      wb_strobe_out => wb_stb_o,
      wb_we_out  => wb_we_o,
      wb_sel_out => wb_sel_o,
      wb_adr_out => wb_adr_o,
      wb_dat_out => wb_dat_o,
      wb_ack_in => wb_ack_i,
      wb_dat_in => wb_dat_i);

  -- clock generation
  clk <= not clk after 5 ns when not STOPPED;

  -- waveform generation & checking
  --
  -- a 2 ns propagate delay is assumed for UUT
  WaveGen_Proc: process
  begin
    -- initial bus reply
    wb_ack_i <= '0';
    wb_dat_i <= (others => '-');

    -- --------------------------------------------------------------------
    -- 1) Check if new commands are issued on bus with 1 cycle delay after
    -- reset. 
    -- --------------------------------------------------------------------
    -- do reset, outputs do not care
    rst  <= '1';
    wait until rising_edge(clk);

    -- issue command, bus-cycle must not start here even if not WB_O_REG!
    rst  <= '0';
    cmd   <= "10"; 	  -- read
    addr  <= x"00000010";
    wdata <= (others => '-');
    wait for 2 ns;
    assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '0')
      report "Reset failed." severity error;
    wait until rising_edge(clk);
    
    -- command is still present, bus-cycle should be started now
    wait for 2 ns;
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '0') and (wb_adr_o = x"00000010")
      report "Read@10 failed (a)." severity error;
    
    -- bus reply in same clock cycle
    wb_ack_i <= '1';
    wb_dat_i <= x"10101010";
    wait for 2 ns;
    if WB_I_REG then
      -- Pipeline should be still stalled.
      assert (pipe_en = '0') report "Read@10 failed (b)." severity error;
      wait until rising_edge(clk);
      wb_ack_i <= '0';
      wb_dat_i <= (others => '-');
      wait for 2 ns;
      -- Bus-cycle must be terminated now.
      assert (wb_cyc_o = '0') and (wb_stb_o = '0')
	report "Read@20 failed (f)." severity error;
    end if;

    -- check output for pipeline
    assert (pipe_en = '1') and (rdata = x"10101010")
      report "Read@10 failed (c)" severity error;
    wait until rising_edge(clk);
    wb_ack_i <= '0';
    wb_dat_i <= (others => '-');
    
    -- --------------------------------------------------------------------
    -- 2) No command
    -- --------------------------------------------------------------------
    cmd   <= "0-";
    addr  <= (others => '-');
    wdata <= (others => '-');
    wait for 2 ns;
    assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '1')
      report "Nop1 failed." severity error;
    wait until rising_edge(clk);

    -- still no command
    wait for 2 ns;
    assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '1')
      report "Nop2 failed." severity error;
    wait until rising_edge(clk);
    
    -- --------------------------------------------------------------------
    -- 3) Issue read with bus delay.
    -- --------------------------------------------------------------------
    -- Issue command, bus-cycle may start only if not WB_O_REG!
    cmd   <= "10"; 	  -- read
    addr  <= x"00000020";
    wdata <= (others => '-');
    wait for 2 ns;
    if WB_O_REG then
      assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '0')
	report "Read@20 failed (a)." severity error;
      wait until rising_edge(clk);
      wait for 2 ns;
    end if;

    -- Check bus-cycle. No reply yet, pipeline must be stalled.
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '0') and (wb_adr_o = x"00000020") and (pipe_en = '0')
      report "Read@20 failed (b)." severity error;
    
    -- Bus slave device inserts wait states, command must be hold and pipeline
    -- stalled.
    wait until rising_edge(clk);
    wait for 2 ns;
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '0') and (wb_adr_o = x"00000020") and (pipe_en = '0')
      report "Read@20 failed (c)." severity error;
    wait until rising_edge(clk);
    wait for 2 ns;
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '0') and (wb_adr_o = x"00000020") and (pipe_en = '0')
      report "Read@20 failed (d)." severity error;

    -- Bus reply.
    wb_ack_i <= '1';
    wb_dat_i <= x"20202020";
    wait for 2 ns;
    if WB_I_REG then
      -- pipeline should be still stalled.
      assert (pipe_en = '0') report "Read@20 failed (e)." severity error;
      wait until rising_edge(clk);
      wb_ack_i <= '0';
      wb_dat_i <= (others => '-');
      wait for 2 ns;
      -- Bus-cycle must be terminated now.
      assert (wb_cyc_o = '0') and (wb_stb_o = '0')
	report "Read@20 failed (f)." severity error;
    end if;

    -- check output for pipeline
    assert (pipe_en = '1') and (rdata = x"20202020")
      report "Read@20 failed (g)" severity error;
    wait until rising_edge(clk);
    wb_ack_i <= '0';
    wb_dat_i <= (others => '-');

    -- --------------------------------------------------------------------
    -- 4) Issue write with bus delay.
    -- --------------------------------------------------------------------
    -- Issue command, bus-cycle may start only if not WB_O_REG!
    cmd   <= "11"; 	  -- write
    addr  <= x"00000030";
    wdata <= x"30303030";
    wait for 2 ns;
    if WB_O_REG then
      assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '0')
	report "Write@30 failed (a)." severity error;
      wait until rising_edge(clk);
      wait for 2 ns;
    end if;

    -- Check bus-cycle. No reply yet, pipeline must be stalled.
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '1') and (wb_adr_o = x"00000030") and (wb_dat_o = x"30303030") and (pipe_en = '0')
      report "Write@30 failed (b)." severity error;
    
    -- Bus slave device inserts wait states, command must be hold and pipeline
    -- stalled.
    wait until rising_edge(clk);
    wait for 2 ns;
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '1') and (wb_adr_o = x"00000030") and (wb_dat_o = x"30303030") and (pipe_en = '0')
      report "Write@30 failed (c)." severity error;
    wait until rising_edge(clk);
    wait for 2 ns;
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '1') and (wb_adr_o = x"00000030") and (wb_dat_o = x"30303030") and (pipe_en = '0')
      report "Write@30 failed (d)." severity error;

    -- Bus reply.
    wb_ack_i <= '1';
    wait for 2 ns;
    if WB_I_REG then
      -- pipeline should be still stalled.
      assert (pipe_en = '0') report "Write@30 failed (e)." severity error;
      wait until rising_edge(clk);
      wb_ack_i <= '0';
      wb_dat_i <= (others => '-');
      wait for 2 ns;
      -- Bus-cycle must be terminated now.
      assert (wb_cyc_o = '0') and (wb_stb_o = '0')
	report "Write@30 failed (f)." severity error;
    end if;

    -- check output for pipeline
    assert (pipe_en = '1')
      report "Write@30 failed (g)" severity error;
    wait until rising_edge(clk);
    wb_ack_i <= '0';
    wb_dat_i <= (others => '-');

    -- --------------------------------------------------------------------
    -- 5) No command
    -- --------------------------------------------------------------------
    cmd   <= "0-";
    addr  <= (others => '-');
    wdata <= (others => '-');
    wait for 2 ns;
    assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '1')
      report "Nop1 failed." severity error;
    wait until rising_edge(clk);

    -- still no command
    wait for 2 ns;
    assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '1')
      report "Nop2 failed." severity error;
    wait until rising_edge(clk);
    
    -- --------------------------------------------------------------------
    -- 6) Issue read without bus delay.
    -- --------------------------------------------------------------------
    -- Issue command, bus-cycle may start only if not WB_O_REG!
    cmd   <= "10"; 	  -- read
    addr  <= x"00000040";
    wdata <= (others => '-');
    wait for 2 ns;
    if WB_O_REG then
      assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '0')
	report "Read@40 failed (a)." severity error;
      wait until rising_edge(clk);
      wait for 2 ns;
    end if;

    -- Check bus-cycle. No reply yet, pipeline must be stalled.
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '0') and (wb_adr_o = x"00000040") and (pipe_en = '0')
      report "Read@40 failed (b)." severity error;
    
    -- Bus reply.
    wb_ack_i <= '1';
    wb_dat_i <= x"40404040";
    wait for 2 ns;
    if WB_I_REG then
      -- pipeline should be still stalled.
      assert (pipe_en = '0') report "Read@40 failed (e)." severity error;
      wait until rising_edge(clk);
      wb_ack_i <= '0';
      wb_dat_i <= (others => '-');
      wait for 2 ns;
      -- Bus-cycle must be terminated now.
      assert (wb_cyc_o = '0') and (wb_stb_o = '0')
	report "Read@40 failed (f)." severity error;
    end if;

    -- check output for pipeline
    assert (pipe_en = '1') and (rdata = x"40404040")
      report "Read@40 failed (g)" severity error;
    wait until rising_edge(clk);
    wb_ack_i <= '0';
    wb_dat_i <= (others => '-');

    -- --------------------------------------------------------------------
    -- 7) Issue write without bus delay.
    -- --------------------------------------------------------------------
    -- Issue command, bus-cycle may start only if not WB_O_REG!
    cmd   <= "11"; 	  -- write
    addr  <= x"00000070";
    wdata <= x"70707070";
    wait for 2 ns;
    if WB_O_REG then
      assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '0')
	report "Write@70 failed (a)." severity error;
      wait until rising_edge(clk);
      wait for 2 ns;
    end if;

    -- Check bus-cycle. No reply yet, pipeline must be stalled.
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '1') and (wb_adr_o = x"00000070") and (wb_dat_o = x"70707070") and (pipe_en = '0')
      report "Write@70 failed (b)." severity error;
    
    -- Bus reply.
    wb_ack_i <= '1';
    wait for 2 ns;
    if WB_I_REG then
      -- pipeline should be still stalled.
      assert (pipe_en = '0') report "Write@70 failed (e)." severity error;
      wait until rising_edge(clk);
      wb_ack_i <= '0';
      wb_dat_i <= (others => '-');
      wait for 2 ns;
      -- Bus-cycle must be terminated now.
      assert (wb_cyc_o = '0') and (wb_stb_o = '0')
	report "Write@70 failed (f)." severity error;
    end if;

    -- check output for pipeline
    assert (pipe_en = '1')
      report "Write@70 failed (g)" severity error;
    wait until rising_edge(clk);
    wb_ack_i <= '0';
    wb_dat_i <= (others => '-');
    
    -- --------------------------------------------------------------------
    -- 8) Issue read without bus delay.
    -- --------------------------------------------------------------------
    -- Issue command, bus-cycle may start only if not WB_O_REG!
    cmd   <= "10"; 	  -- read
    addr  <= x"00000080";
    wdata <= (others => '-');
    wait for 2 ns;
    if WB_O_REG then
      assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '0')
	report "Read@80 failed (a)." severity error;
      wait until rising_edge(clk);
      wait for 2 ns;
    end if;

    -- Check bus-cycle. No reply yet, pipeline must be stalled.
    assert (wb_cyc_o = '1') and (wb_stb_o = '1') and (wb_we_o = '0') and (wb_adr_o = x"00000080") and (pipe_en = '0')
      report "Read@80 failed (b)." severity error;
    
    -- Bus reply.
    wb_ack_i <= '1';
    wb_dat_i <= x"80808080";
    wait for 2 ns;
    if WB_I_REG then
      -- pipeline should be still stalled.
      assert (pipe_en = '0') report "Read@80 failed (e)." severity error;
      wait until rising_edge(clk);
      wb_ack_i <= '0';
      wb_dat_i <= (others => '-');
      wait for 2 ns;
      -- Bus-cycle must be terminated now.
      assert (wb_cyc_o = '0') and (wb_stb_o = '0')
	report "Read@80 failed (f)." severity error;
    end if;

    -- check output for pipeline
    assert (pipe_en = '1') and (rdata = x"80808080")
      report "Read@80 failed (g)" severity error;
    wait until rising_edge(clk);
    wb_ack_i <= '0';
    wb_dat_i <= (others => '-');

    -- --------------------------------------------------------------------
    -- End) No command
    -- --------------------------------------------------------------------
    cmd   <= "0-";
    addr  <= (others => '-');
    wdata <= (others => '-');
    wait for 2 ns;
    assert (wb_cyc_o = '0') and (wb_stb_o = '0') and (pipe_en = '1')
      report "End failed." severity error;
    wait until rising_edge(clk);

    -- wait for ever
    STOPPED <= true;
    wait;
  end process WaveGen_Proc;

  

end architecture sim;
