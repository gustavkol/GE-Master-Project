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

  signal dmem_data_avalid_wire : std_logic;
  signal dmem_data_aready_wire : std_logic;
  signal dmem_data_aaddr_wire : std_logic_vector(17-2-1 downto 0);
  signal dmem_data_awren_wire : std_logic;
  signal dmem_data_astrb_wire : std_logic_vector(32/8-1 downto 0);
  signal dmem_data_rready_wire : std_logic;
  signal dmem_data_rdata_wire : std_logic_vector(32-1 downto 0);
  signal dmem_data_adata_wire : std_logic_vector(32-1 downto 0);
  signal dmem_data_rvalid_wire : std_logic;
  signal imem0_addr_wire : std_logic_vector(IMEMADDRWIDTH-2-1 downto 0);
  signal imem0_en_x_wire : std_logic;
  signal imem0_q_wire : std_logic_vector(IMEMDATAWIDTH-1 downto 0);
  signal tta_core_imem_en_x_wire : std_logic;
  signal tta_core_imem_addr_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal tta_core_imem_data_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal tta_core_fu_LSU_avalid_out_wire : std_logic_vector(0 downto 0);
  signal tta_core_fu_LSU_aready_in_wire : std_logic_vector(0 downto 0);
  signal tta_core_fu_LSU_aaddr_out_wire : std_logic_vector(17-2-1 downto 0);
  signal tta_core_fu_LSU_awren_out_wire : std_logic_vector(0 downto 0);
  signal tta_core_fu_LSU_astrb_out_wire : std_logic_vector(3 downto 0);
  signal tta_core_fu_LSU_rvalid_in_wire : std_logic_vector(0 downto 0);
  signal tta_core_fu_LSU_rready_out_wire : std_logic_vector(0 downto 0);
  signal tta_core_fu_LSU_rdata_in_wire : std_logic_vector(31 downto 0);
  signal tta_core_fu_LSU_adata_out_wire : std_logic_vector(31 downto 0);

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
      fu_LSU_avalid_out : out std_logic_vector(1-1 downto 0);
      fu_LSU_aready_in : in std_logic_vector(1-1 downto 0);
      fu_LSU_aaddr_out : out std_logic_vector(17-2-1 downto 0);
      fu_LSU_awren_out : out std_logic_vector(1-1 downto 0);
      fu_LSU_astrb_out : out std_logic_vector(4-1 downto 0);
      fu_LSU_rvalid_in : in std_logic_vector(1-1 downto 0);
      fu_LSU_rready_out : out std_logic_vector(1-1 downto 0);
      fu_LSU_rdata_in : in std_logic_vector(32-1 downto 0);
      fu_LSU_adata_out : out std_logic_vector(32-1 downto 0));
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

  component synch_byte_mask_sram is
    generic (
      DATAW : integer;
      ADDRW : integer;
      INITFILENAME : string;
      access_trace : boolean;
      ACCESSTRACEFILENAME : string);
    port (
      clk : in std_logic;
      avalid : in std_logic;
      aready : out std_logic;
      aaddr : in std_logic_vector(ADDRW-1 downto 0);
      awren : in std_logic;
      astrb : in std_logic_vector(32/8-1 downto 0);
      rready : in std_logic;
      rdata : out std_logic_vector(DATAW-1 downto 0);
      adata : in std_logic_vector(DATAW-1 downto 0);
      rvalid : out std_logic);
  end component;


begin

  imem0_en_x_wire <= tta_core_imem_en_x_wire;
  imem0_addr_wire(14 downto 0) <= tta_core_imem_addr_wire(16 downto 2);
  tta_core_imem_data_wire <= imem0_q_wire;
  dmem_data_avalid_wire <= tta_core_fu_LSU_avalid_out_wire(0);
  tta_core_fu_LSU_aready_in_wire(0) <= dmem_data_aready_wire;
  dmem_data_aaddr_wire <= tta_core_fu_LSU_aaddr_out_wire;
  dmem_data_awren_wire <= tta_core_fu_LSU_awren_out_wire(0);
  dmem_data_astrb_wire <= tta_core_fu_LSU_astrb_out_wire;
  tta_core_fu_LSU_rvalid_in_wire(0) <= dmem_data_rvalid_wire;
  dmem_data_rready_wire <= tta_core_fu_LSU_rready_out_wire(0);
  tta_core_fu_LSU_rdata_in_wire <= dmem_data_rdata_wire;
  dmem_data_adata_wire <= tta_core_fu_LSU_adata_out_wire;

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
      fu_LSU_avalid_out => tta_core_fu_LSU_avalid_out_wire,
      fu_LSU_aready_in => tta_core_fu_LSU_aready_in_wire,
      fu_LSU_aaddr_out => tta_core_fu_LSU_aaddr_out_wire,
      fu_LSU_awren_out => tta_core_fu_LSU_awren_out_wire,
      fu_LSU_astrb_out => tta_core_fu_LSU_astrb_out_wire,
      fu_LSU_rvalid_in => tta_core_fu_LSU_rvalid_in_wire,
      fu_LSU_rready_out => tta_core_fu_LSU_rready_out_wire,
      fu_LSU_rdata_in => tta_core_fu_LSU_rdata_in_wire,
      fu_LSU_adata_out => tta_core_fu_LSU_adata_out_wire);

  imem0 : synch_sram
    generic map (
      DATAW => IMEMDATAWIDTH,
      ADDRW => IMEMADDRWIDTH-2,
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

  dmem_data : synch_byte_mask_sram
    generic map (
      DATAW => 32,
      ADDRW => 17-2,
      INITFILENAME => "tb/dmem_data_init.img",
      access_trace => false,
      ACCESSTRACEFILENAME => "access_trace")
    port map (
      clk => clk,
      avalid => dmem_data_avalid_wire,
      aready => dmem_data_aready_wire,
      aaddr => dmem_data_aaddr_wire,
      awren => dmem_data_awren_wire,
      astrb => dmem_data_astrb_wire,
      rready => dmem_data_rready_wire,
      rdata => dmem_data_rdata_wire,
      adata => dmem_data_adata_wire,
      rvalid => dmem_data_rvalid_wire);

end structural;
