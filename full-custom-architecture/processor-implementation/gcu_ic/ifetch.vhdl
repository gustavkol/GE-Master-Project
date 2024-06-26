-- Copyright (c) 2002-2009 Tampere University.
--
-- This file is part of TTA-Based Codesign Environment (TCE).
--
-- Permission is hereby granted, free of charge, to any person obtaining a
-- copy of this software and associated documentation files (the "Software"),
-- to deal in the Software without restriction, including without limitation
-- the rights to use, copy, modify, merge, publish, distribute, sublicense,
-- and/or sell copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
-- DEALINGS IN THE SOFTWARE.

library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.numeric_std.all;
use work.tta0_globals.all;
use work.tta0_gcu_opcodes.all;
use work.tta0_imem_mau.all;
use work.tce_util.all;

entity tta0_ifetch is

  generic (
    no_glock_loopback_g        : std_logic := '0';
    extra_fetch_cycles         : integer   := 0;
    sync_reset_g               : boolean   := false;
    debug_logic_g              : boolean   := false;

    pc_init_g : std_logic_vector(IMEMADDRWIDTH-1 downto 0) := (others => '0'));

  port (
    -- program counter in
    pc_in      : in  std_logic_vector (IMEMADDRWIDTH-1 downto 0);
    --return address out
    ra_out     : out std_logic_vector (IMEMADDRWIDTH-1 downto 0);
    -- return address in
    ra_in      : in  std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    -- ifetch control signals
    pc_load    : in  std_logic;
    ra_load    : in  std_logic;
    pc_opcode  : in  std_logic_vector(0 downto 0);
    --instruction memory interface
    imem_data  : in  std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
    imem_addr  : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    imem_en_x  : out std_logic;
    fetchblock : out std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
    busy       : in  std_logic;

    -- global lock
    glock : out std_logic;

    -- external control interface
    fetch_en  : in std_logic;             --fetch_enable
    

    clk  : in std_logic;
    rstx : in std_logic);
end tta0_ifetch;

architecture rtl_andor of tta0_ifetch is

  -- signals for program counter.
  signal pc_reg      : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal pc_wire     : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal pc_prev_reg : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal next_pc     : std_logic_vector(IMEMADDRWIDTH-1 downto 0);

  signal increased_pc    : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal return_addr_reg : std_logic_vector(IMEMADDRWIDTH-1 downto 0);

  -- internal signals for initializing and locking execution
  signal lock       : std_logic;
  signal mem_en_lock_r : std_logic;

  signal reset_cntr : integer;
  signal reset_lock : std_logic;

  -- Placeholder signals for debug ports
  constant db_rstx     : std_logic := '1';
  constant db_lockreq  : std_logic := '0';
  constant db_pc_start : std_logic_vector(IMEMADDRWIDTH-1 downto 0)
                         := (others => '0');
  signal cyclecnt_r, lockcnt_r   : unsigned(64 - 1 downto 0);
  signal db_cyclecnt, db_lockcnt : std_logic_vector(64 - 1 downto 0);
  signal db_pc, db_pc_next       : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  

    
  constant IFETCH_DELAY : integer := 1;
  
begin

  -- enable instruction memory.
  imem_en_x <= '0'    when (fetch_en = '1' and mem_en_lock_r = '0') else '1';
  -- do not fetch new instruction when processor is locked.
  imem_addr <= pc_wire;

  -- propagate lock to global lock

  glock  <= busy or reset_lock or (not (fetch_en or no_glock_loopback_g));
  ra_out <= return_addr_reg;
  lock   <= not fetch_en or busy or mem_en_lock_r;


    pc_update_proc : process (clk, rstx)
    begin
      if not sync_reset_g and rstx = '0' then
        pc_reg      <= pc_init_g;
        pc_prev_reg <= (others => '0');
      elsif clk'event and clk = '1' then    -- rising clock edge.
        if (sync_reset_g and rstx = '0') or db_rstx = '0' then
          pc_reg      <= db_pc_start;
          pc_prev_reg <= (others => '0');
        elsif lock = '0' then
          pc_reg      <= next_pc;
          pc_prev_reg <= pc_reg;
        end if;
      end if;
    end process pc_update_proc;



  -----------------------------------------------------------------------------
  ra_block : block
    signal ra_source : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  begin  -- block ra_block

    -- Default choice generate
    ra_source <= increased_pc;

    ra_update_proc : process (clk, rstx)
    begin  -- process ra_update_proc
      if not sync_reset_g and rstx = '0' then -- asynchronous reset (active low)
        return_addr_reg <= (others => '0');
      elsif clk'event and clk = '1' then  -- rising clock edge
        if (sync_reset_g and rstx = '0') or db_rstx = '0' then
          return_addr_reg <= (others => '0');
        elsif lock = '0' then
          -- return address
          if (ra_load = '1') then
            return_addr_reg <= ra_in;
          elsif (pc_load = '1' and unsigned(pc_opcode) = IFE_CALL) then
            -- return address transformed to same form as all others addresses
            -- provided as input
            return_addr_reg <= ra_source;
          end if;

        end if;
      end if;
    end process ra_update_proc;
  end block ra_block;

  -----------------------------------------------------------------------------
  -- Keeps memory enable inactive during reset
  imem_lock_proc : process (clk, rstx)
  begin
    if not sync_reset_g and rstx = '0' then
      mem_en_lock_r <= '1';
    elsif clk'event and clk = '1' then  -- rising clock edge
        if (sync_reset_g and rstx = '0') or db_rstx = '0' then
        mem_en_lock_r <= '1';
      else
        mem_en_lock_r <= '0';
      end if;
    end if;
  end process imem_lock_proc;

  -----------------------------------------------------------------------------
  -- Default fetch implementation
  fetch_block : block
    signal instruction_reg : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH*
                                                (extra_fetch_cycles+1)-1 downto 0);
    begin  -- block fetch_block

      fetch_block_proc : process (clk, rstx)
      begin  -- process fetch_block_proc
        if not sync_reset_g and rstx = '0' then   -- asynchronous reset (active low)
          instruction_reg <= (others => '0');
          reset_cntr      <= 0;
          reset_lock      <= '1';
        elsif clk'event and clk = '1' then  -- rising clock edge
          if (sync_reset_g and rstx = '0') or db_rstx = '0' then
            instruction_reg <= (others => '0');
            reset_cntr      <= 0;
            reset_lock      <= '1';
          elsif lock = '0' then
            if reset_cntr < IFETCH_DELAY then
              reset_cntr <= reset_cntr + 1;
            else
              reset_lock <= '0';
            end if;
            if (extra_fetch_cycles > 0) then
              instruction_reg(instruction_reg'length-fetchblock'length-1 downto 0)
                   <= instruction_reg(instruction_reg'length-1 downto fetchblock'length);
            end if;
            instruction_reg(instruction_reg'length-1
                            downto instruction_reg'length - fetchblock'length)
            <= imem_data;
          end if;
        end if;
      end process fetch_block_proc;
      fetchblock <= instruction_reg(fetchblock'length-1 downto 0);
    end block fetch_block;

--------------------------------------------------------------------------------

    pc_wire <= pc_reg when (lock = '0') else pc_prev_reg;
    -- increase program counter
    increased_pc <= std_logic_vector(unsigned(pc_wire) + IMEMWIDTHINMAUS);

    sel_next_pc : process (pc_load, pc_in, increased_pc, pc_opcode)
    begin
      if pc_load = '1' and ((unsigned(pc_opcode) = IFE_CALL or 
          unsigned(pc_opcode) = IFE_JUMP))
       then
        next_pc <= pc_in;
      else -- no branch
        next_pc <= increased_pc;
      end if;
    end process sel_next_pc;

  -----------------------------------------------------------------------------
  debug_counters : if debug_logic_g generate
  -----------------------------------------------------------------------------
  -- Debugger processes and signal assignments
  -----------------------------------------------------------------------------
    db_counters : process(clk, rstx)
    begin
      if not sync_reset_g and rstx = '0' then -- async reset (active low)
        lockcnt_r  <= (others => '0');
        cyclecnt_r <= (others => '0');
      elsif rising_edge(clk) then
        if (sync_reset_g and rstx = '0') or db_rstx = '0' then
          lockcnt_r  <= (others => '0');
          cyclecnt_r <= (others => '0');
        elsif db_lockreq = '0' then
          if lock = '1' then
            lockcnt_r  <= lockcnt_r  + 1;
          else
            cyclecnt_r <= cyclecnt_r + 1;
          end if;
        end if;
      end if;
    end process;

    db_cyclecnt <= std_logic_vector(cyclecnt_r);
    db_lockcnt  <= std_logic_vector(lockcnt_r);
    db_pc       <= pc_reg;
    db_pc_next  <= next_pc;
  end generate debug_counters;

  

end rtl_andor;

