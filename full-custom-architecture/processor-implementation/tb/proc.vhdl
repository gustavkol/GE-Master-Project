library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tce_util.all;
use work.tta0_globals.all;
use work.tta0_imem_mau.all;
use work.tta0_params.all;

entity proc is

  port (
    clk : in std_logic;
    rstx : in std_logic;
    locked : out std_logic_vector(0 downto 0));

end proc;

architecture structural of proc is

  signal dmem_data_d_wire : std_logic_vector(fu_lsu_dataw-1 downto 0);
  signal dmem_data_addr_wire : std_logic_vector(fu_lsu_addrw-2-1 downto 0);
  signal dmem_data_en_x_wire : std_logic;
  signal dmem_data_wr_x_wire : std_logic;
  signal dmem_data_bit_wr_x_wire : std_logic_vector(fu_lsu_dataw-1 downto 0);
  signal dmem_data_q_wire : std_logic_vector(fu_lsu_dataw-1 downto 0);
  signal imem0_addr_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal imem0_en_x_wire : std_logic;
  signal imem0_q_wire : std_logic_vector(IMEMDATAWIDTH-1 downto 0);
  signal tta_core_imem_en_x_wire : std_logic;
  signal tta_core_imem_addr_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal tta_core_imem_data_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal tta_core_fu_lsu_mem_en_x_wire : std_logic_vector(0 downto 0);
  signal tta_core_fu_lsu_wr_en_x_wire : std_logic_vector(0 downto 0);
  signal tta_core_fu_lsu_wr_mask_x_wire : std_logic_vector(31 downto 0);
  signal tta_core_fu_lsu_addr_wire : std_logic_vector(fu_lsu_addrw-2-1 downto 0);
  signal tta_core_fu_lsu_data_in_wire : std_logic_vector(31 downto 0);
  signal tta_core_fu_lsu_data_out_wire : std_logic_vector(31 downto 0);

  component tta0 is
    generic (
      core_id : integer);
    port (
      clk : in std_logic;
      rstx : in std_logic;
      busy : in std_logic;
      imem_en_x : out std_logic;
      imem_addr : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      imem_data : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      locked : out std_logic;
      fu_lsu_mem_en_x : out std_logic_vector(1-1 downto 0);
      fu_lsu_wr_en_x : out std_logic_vector(1-1 downto 0);
      fu_lsu_wr_mask_x : out std_logic_vector(fu_lsu_dataw-1 downto 0);
      fu_lsu_addr : out std_logic_vector(fu_lsu_addrw-2-1 downto 0);
      fu_lsu_data_in : in std_logic_vector(fu_lsu_dataw-1 downto 0);
      fu_lsu_data_out : out std_logic_vector(fu_lsu_dataw-1 downto 0));
  end component;

  component synch_sram is
    generic (
      DATAW : integer;
      ADDRW : integer;
      INITFILENAME : string;
      access_trace : boolean;
      ACCESSTRACEFILENAME : string);
    port (
      clk : in std_logic;
      d : in std_logic_vector(DATAW-1 downto 0);
      addr : in std_logic_vector(ADDRW-1 downto 0);
      en_x : in std_logic;
      wr_x : in std_logic;
      bit_wr_x : in std_logic_vector(DATAW-1 downto 0);
      q : out std_logic_vector(DATAW-1 downto 0));
  end component;


begin

  imem0_en_x_wire <= tta_core_imem_en_x_wire;
  imem0_addr_wire <= tta_core_imem_addr_wire;
  tta_core_imem_data_wire <= imem0_q_wire;
  dmem_data_en_x_wire <= tta_core_fu_lsu_mem_en_x_wire(0);
  dmem_data_wr_x_wire <= tta_core_fu_lsu_wr_en_x_wire(0);
  dmem_data_bit_wr_x_wire <= tta_core_fu_lsu_wr_mask_x_wire;
  dmem_data_addr_wire <= tta_core_fu_lsu_addr_wire;
  tta_core_fu_lsu_data_in_wire <= dmem_data_q_wire;
  dmem_data_d_wire <= tta_core_fu_lsu_data_out_wire;

  tta_core : tta0
    generic map (
      core_id => 0)
    port map (
      clk => clk,
      rstx => rstx,
      busy => '0',
      imem_en_x => tta_core_imem_en_x_wire,
      imem_addr => tta_core_imem_addr_wire,
      imem_data => tta_core_imem_data_wire,
      locked => locked(0),
      fu_lsu_mem_en_x => tta_core_fu_lsu_mem_en_x_wire,
      fu_lsu_wr_en_x => tta_core_fu_lsu_wr_en_x_wire,
      fu_lsu_wr_mask_x => tta_core_fu_lsu_wr_mask_x_wire,
      fu_lsu_addr => tta_core_fu_lsu_addr_wire,
      fu_lsu_data_in => tta_core_fu_lsu_data_in_wire,
      fu_lsu_data_out => tta_core_fu_lsu_data_out_wire);

  imem0 : synch_sram
    generic map (
      DATAW => IMEMDATAWIDTH,
      ADDRW => IMEMADDRWIDTH,
      INITFILENAME => "tb/imem_init.img",
      access_trace => true,
      ACCESSTRACEFILENAME => "core0_imem_access_trace.dump")
    port map (
      clk => clk,
      d => (others => '0'),
      addr => imem0_addr_wire,
      en_x => imem0_en_x_wire,
      wr_x => '1',
      bit_wr_x => (others => '1'),
      q => imem0_q_wire);

  dmem_data : synch_sram
    generic map (
      DATAW => fu_lsu_dataw,
      ADDRW => fu_lsu_addrw-2,
      INITFILENAME => "tb/dmem_data_init.img",
      access_trace => false,
      ACCESSTRACEFILENAME => "access_trace")
    port map (
      clk => clk,
      d => dmem_data_d_wire,
      addr => dmem_data_addr_wire,
      en_x => dmem_data_en_x_wire,
      wr_x => dmem_data_wr_x_wire,
      bit_wr_x => dmem_data_bit_wr_x_wire,
      q => dmem_data_q_wire);

end structural;
