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

entity tta0_ifetch is
  generic (
    debug_logic_g              : boolean   := false;
    bypass_fetchblock_register : boolean := false;
    pc_init_g : std_logic_vector(IMEMADDRWIDTH-1 downto 0) := (others => '0'));
  port (

    -- program counter in
    pc_in            : in  std_logic_vector (32-1 downto 0);
    --return address out
    ra_out           : out std_logic_vector (IMEMADDRWIDTH-1 downto 0);
    -- return address in
    ra_in            : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    -- ifetch control signals
    pc_load          : in std_logic;
    ra_load          : in std_logic;
    pc_opcode  : in  std_logic_vector(3 downto 0);
    --instruction memory interface
    imem_data         : in  std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
    imem_addr         : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    imem_en_x         : out std_logic;
    fetchblock        : out std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
    busy              : in  std_logic;

    -- global lock
    glock : out std_logic;

    -- external control interface
    fetch_en  : in std_logic;             --fetch_enable
    
    in_data    : in std_logic_vector(31 downto 0);
    in2_data    : in std_logic_vector(31 downto 0);
    in2_load  : in std_logic;
    in_load  : in std_logic;
    
    
    out_data  : out std_logic_vector(31 downto 0);
    ifetch_stall : in std_logic;

    rv_jump : in std_logic;
    rv_auipc : in std_logic;
    rv_offset : in std_logic_vector(31 downto 0);

    clk  : in std_logic;
    rstx : in std_logic);
end tta0_ifetch;

architecture rtl_andor of tta0_ifetch is

  -- signals for program counter
  signal pc_reg      : std_logic_vector (IMEMADDRWIDTH-1 downto 0);
  signal pc_prev_reg : std_logic_vector (IMEMADDRWIDTH-1 downto 0);
  signal next_pc     : std_logic_vector (IMEMADDRWIDTH-1 downto 0);

  signal control_pc : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal control_pc_next : std_logic_vector(IMEMADDRWIDTH-1 downto 0);

  signal increased_pc    : std_logic_vector (IMEMADDRWIDTH-1 downto 0);
  signal return_addr_reg : std_logic_vector (IMEMADDRWIDTH-1 downto 0);

  -- internal signals for initializing and locking execution
  signal lock       : std_logic;

  signal reset_lock : std_logic;  
  constant IFETCH_DELAY : integer := 1;

 signal take_cond_branch        : std_logic;
 signal cond : std_logic_vector(32-1 downto 0);
 signal comp : std_logic_vector(32-1 downto 0);
 
 -- Placeholder signals for debug ports
 constant db_rstx     : std_logic := '1';
 constant db_lockreq  : std_logic := '0';
 constant db_pc_start : std_logic_vector(IMEMADDRWIDTH-1 downto 0)
                        := (others => '0');
 signal cyclecnt_r, lockcnt_r   : unsigned(64 - 1 downto 0);
 signal db_cyclecnt, db_lockcnt : std_logic_vector(64 - 1 downto 0);
 signal db_pc, db_pc_next       : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
 
 signal calla_address : std_logic_vector(31 downto 0);
 signal apc_result_reg : std_logic_vector(31 downto 0);

begin

  -- enable instruction memory
  imem_en_x <= '0'    when (fetch_en = '1'  and ifetch_stall = '0') else '1';
  -- do not fetch new instruction when processor is locked
  imem_addr <= pc_reg when (lock = '0'  and ifetch_stall = '0')   else pc_prev_reg;

  -- propagate lock to global lock
  glock            <= busy or reset_lock or (not fetch_en);
  ra_out           <= return_addr_reg;

  lock <= not fetch_en or busy;

  calla_address <=std_logic_vector(resize(unsigned(pc_in), 32) + unsigned(cond));
  
  process (clk, rstx)
  begin
    if rstx = '0' then
      apc_result_reg <= (others => '0');
    elsif rising_edge(clk) then
      if rv_auipc = '1' and lock = '0' then
        apc_result_reg <= std_logic_vector(resize(unsigned(control_pc), 32) + unsigned(rv_offset));
      end if;
    end if;
  end process;

  out_data <= apc_result_reg;
  
  instruction_reg_generate : if not bypass_fetchblock_register generate
    instruction_reg_block : block
      signal instruction_reg : std_logic_vector (IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      signal   reset_cntr   : integer range 0 to IFETCH_DELAY;
      signal   pc_prev_prev_reg : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    begin
      control_pc <= pc_prev_prev_reg;
      control_pc_next <= pc_prev_reg;
      process(clk, rstx)
      begin
        if(rstx = '0') then
          instruction_reg <= (others => '0');
          reset_cntr      <= 0;
          reset_lock      <= '1';
          pc_prev_prev_reg <= (others => '0');
        elsif(clk'event and clk = '1') then
          if lock = '0' and ifetch_stall = '0' then
            pc_prev_prev_reg <= pc_prev_reg;
          end if;
          if lock = '0' then
            if reset_cntr < IFETCH_DELAY then
               reset_cntr <= reset_cntr + 1;
            else
               reset_lock <= '0';
            end if;
          end if;
          if lock = '0'  and ifetch_stall = '0' then
            instruction_reg <= imem_data(instruction_reg'length-1 downto 0);
          end if;
        end if;
      end process;

      fetchblock <= instruction_reg;

    end block instruction_reg_block;
  end generate instruction_reg_generate;

  instruction_reg_bypass_generate : if bypass_fetchblock_register generate
    fetchblock <= imem_data(fetchblock'length-1 downto 0);
    control_pc <= pc_prev_reg;
    control_pc_next <= pc_reg;
    process(clk, rstx)
    begin
      if(rstx = '0') then
        reset_lock      <= '1';
      elsif(clk'event and clk = '1') then
        if lock = '0' then
          reset_lock <= '0';
        end if;
      end if;
    end process;
  end generate instruction_reg_bypass_generate;


  process (clk, rstx)
  begin  -- process immediates
    if rstx = '0' then
      pc_reg          <= pc_init_g;
      pc_prev_reg     <= (others => '0');
      return_addr_reg <= (others => '0');
    elsif clk'event and clk = '1' then  -- rising clock edge
   
      if lock = '0' and ifetch_stall = '0' then
        pc_reg      <= next_pc;
        pc_prev_reg <= pc_reg;
      end if;

      if lock = '0' and (pc_load = '1' or rv_jump = '1') then
        return_addr_reg <= std_logic_vector(unsigned(control_pc) + IMEMWIDTHINMAUS);
      end if;

    end if;
  end process;

  take_cond_branch_proc : process(pc_opcode, cond, comp)
  begin
    take_cond_branch <= '0';
    if (unsigned(pc_opcode) = IFE_BGER) then
      if signed(cond) >= signed(comp) then
        take_cond_branch <= '1';
      end if;
    elsif (unsigned(pc_opcode) = IFE_BGEUR) then
      if unsigned(cond) >= unsigned(comp) then
        take_cond_branch <= '1';
      end if;
    elsif (unsigned(pc_opcode) = IFE_BLTR) then
      if signed(cond) < signed(comp) then
        take_cond_branch <= '1';
      end if;
    elsif (unsigned(pc_opcode) = IFE_BLTUR) then
      if unsigned(cond) < unsigned(comp) then
        take_cond_branch <= '1';
      end if;
    elsif (unsigned(pc_opcode) = IFE_BNER) then
      if signed(cond) /= signed(comp) then
        take_cond_branch <= '1';
      end if;
    elsif (unsigned(pc_opcode) = IFE_BEQR) then
      if signed(cond) = signed(comp)    then
        take_cond_branch <= '1';
      end if;
    end if;
  end process take_cond_branch_proc;
  
  cond <=in_data;
  comp <=in2_data;


  -- increase program counter
  increased_pc <= std_logic_vector(unsigned(pc_reg) + IMEMWIDTHINMAUS);

  sel_next_pc : process (rv_jump, rv_offset, pc_load, pc_in, increased_pc, pc_opcode , take_cond_branch , calla_address, control_pc, control_pc_next)
  begin
      --branch
      if pc_load = '1' and unsigned(pc_opcode) = IFE_CALLA then
        next_pc <= calla_address(IMEMADDRWIDTH-1 downto 0);
      elsif take_cond_branch = '1' and pc_load = '1' then
        next_pc <= std_logic_vector(unsigned(control_pc) + unsigned(pc_in(next_pc'length-1 downto 0)));
      elsif pc_load = '1' then
        next_pc <= control_pc_next;
      elsif rv_jump = '1' then
        next_pc <= std_logic_vector(unsigned(control_pc) + resize(unsigned(rv_offset), next_pc'length));
      --no branch
      else
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
      if rstx = '0' then -- async reset (active low)
        lockcnt_r  <= (others => '0');
        cyclecnt_r <= (others => '0');
      elsif rising_edge(clk) then
        if db_lockreq = '0' then
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



