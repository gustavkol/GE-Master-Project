library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.ext;
use IEEE.std_logic_arith.sxt;
use work.tta0_globals.all;
use work.tce_util.all;

entity tta0_interconn is

  port (
    clk : in std_logic;
    rstx : in std_logic;
    glock : in std_logic;
    socket_RF_i1_data : out std_logic_vector(31 downto 0);
    socket_RF_o1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_o1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_GCU_i1_data : out std_logic_vector(31 downto 0);
    socket_GCU_ra_o1_data0 : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    socket_GCU_ra_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_RF_o2_data0 : in std_logic_vector(31 downto 0);
    socket_RF_o2_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_GCU_i2_data : out std_logic_vector(31 downto 0);
    socket_GCU_i3_data : out std_logic_vector(31 downto 0);
    socket_GCU_apc_o1_data0 : in std_logic_vector(31 downto 0);
    socket_GCU_apc_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_GCU_ra_i1_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    socket_ALU_i2_data : out std_logic_vector(31 downto 0);
    socket_ALU_i2_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_ALU_i1_data : out std_logic_vector(31 downto 0);
    socket_ALU_o1_data0 : in std_logic_vector(31 downto 0);
    socket_ALU_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_LSU_i2_data : out std_logic_vector(31 downto 0);
    socket_LSU_i3_data : out std_logic_vector(31 downto 0);
    socket_LSU_i1_data : out std_logic_vector(31 downto 0);
    socket_LSU_o1_data0 : in std_logic_vector(31 downto 0);
    socket_LSU_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_STDOUT_i1_data : out std_logic_vector(7 downto 0);
    socket_STDOUT_i2_data : out std_logic_vector(0 downto 0);
    socket_STDOUT_o1_data0 : in std_logic_vector(0 downto 0);
    socket_STDOUT_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_MUL_DIV_i1_data : out std_logic_vector(31 downto 0);
    socket_MUL_DIV_i2_data : out std_logic_vector(31 downto 0);
    socket_MUL_DIV_o1_data0 : in std_logic_vector(31 downto 0);
    socket_MUL_DIV_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    simm_B3 : in std_logic_vector(31 downto 0);
    simm_cntrl_B3 : in std_logic_vector(0 downto 0));

end tta0_interconn;

architecture comb_andor of tta0_interconn is

  signal databus_B0 : std_logic_vector(31 downto 0);
  signal databus_B0_alt0 : std_logic_vector(31 downto 0);
  signal databus_B0_alt1 : std_logic_vector(31 downto 0);
  signal databus_B0_alt2 : std_logic_vector(31 downto 0);
  signal databus_B0_alt3 : std_logic_vector(31 downto 0);
  signal databus_B0_alt4 : std_logic_vector(31 downto 0);
  signal databus_B0_alt5 : std_logic_vector(31 downto 0);
  signal databus_B0_alt6 : std_logic_vector(0 downto 0);
  signal databus_B1 : std_logic_vector(31 downto 0);
  signal databus_B1_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_alt2 : std_logic_vector(31 downto 0);
  signal databus_B1_alt3 : std_logic_vector(31 downto 0);
  signal databus_B1_alt4 : std_logic_vector(31 downto 0);
  signal databus_B1_alt5 : std_logic_vector(31 downto 0);
  signal databus_B1_alt6 : std_logic_vector(0 downto 0);
  signal databus_B2 : std_logic_vector(31 downto 0);
  signal databus_B2_alt0 : std_logic_vector(31 downto 0);
  signal databus_B2_alt1 : std_logic_vector(31 downto 0);
  signal databus_B2_alt2 : std_logic_vector(31 downto 0);
  signal databus_B2_alt3 : std_logic_vector(31 downto 0);
  signal databus_B2_alt4 : std_logic_vector(31 downto 0);
  signal databus_B2_alt5 : std_logic_vector(0 downto 0);
  signal databus_B3 : std_logic_vector(31 downto 0);
  signal databus_B3_simm : std_logic_vector(31 downto 0);

  component tta0_input_mux_1 is
    generic (
      BUSW_0 : integer := 32;
      DATAW : integer := 32);
    port (
      databus0 : in std_logic_vector(BUSW_0-1 downto 0);
      data : out std_logic_vector(DATAW-1 downto 0));
  end component;

  component tta0_input_mux_2 is
    generic (
      BUSW_0 : integer := 32;
      BUSW_1 : integer := 32;
      DATAW : integer := 32);
    port (
      databus0 : in std_logic_vector(BUSW_0-1 downto 0);
      databus1 : in std_logic_vector(BUSW_1-1 downto 0);
      data : out std_logic_vector(DATAW-1 downto 0);
      databus_cntrl : in std_logic_vector(0 downto 0));
  end component;

  component tta0_output_socket_cons_1_1 is
    generic (
      BUSW_0 : integer := 32;
      DATAW_0 : integer := 32);
    port (
      databus0_alt : out std_logic_vector(BUSW_0-1 downto 0);
      data0 : in std_logic_vector(DATAW_0-1 downto 0);
      databus_cntrl : in std_logic_vector(0 downto 0));
  end component;

  component tta0_output_socket_cons_3_1 is
    generic (
      BUSW_0 : integer := 32;
      BUSW_1 : integer := 32;
      BUSW_2 : integer := 32;
      DATAW_0 : integer := 32);
    port (
      databus0_alt : out std_logic_vector(BUSW_0-1 downto 0);
      databus1_alt : out std_logic_vector(BUSW_1-1 downto 0);
      databus2_alt : out std_logic_vector(BUSW_2-1 downto 0);
      data0 : in std_logic_vector(DATAW_0-1 downto 0);
      databus_cntrl : in std_logic_vector(2 downto 0));
  end component;


begin -- comb_andor

  ALU_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1,
      data => socket_ALU_i1_data);

  ALU_i2 : tta0_input_mux_2
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B3,
      databus1 => databus_B0,
      data => socket_ALU_i2_data,
      databus_cntrl => socket_ALU_i2_bus_cntrl);

  ALU_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B0_alt0,
      databus1_alt => databus_B1_alt0,
      databus2_alt => databus_B2_alt0,
      data0 => socket_ALU_o1_data0,
      databus_cntrl => socket_ALU_o1_bus_cntrl);

  GCU_apc_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B2_alt1,
      databus1_alt => databus_B0_alt1,
      databus2_alt => databus_B1_alt1,
      data0 => socket_GCU_apc_o1_data0,
      databus_cntrl => socket_GCU_apc_o1_bus_cntrl);

  GCU_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B3,
      data => socket_GCU_i1_data);

  GCU_i2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1,
      data => socket_GCU_i2_data);

  GCU_i3 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B0,
      data => socket_GCU_i3_data);

  GCU_ra_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => IMEMADDRWIDTH)
    port map (
      databus0 => databus_B2,
      data => socket_GCU_ra_i1_data);

  GCU_ra_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => IMEMADDRWIDTH)
    port map (
      databus0_alt => databus_B2_alt2,
      databus1_alt => databus_B0_alt2,
      databus2_alt => databus_B1_alt2,
      data0 => socket_GCU_ra_o1_data0,
      databus_cntrl => socket_GCU_ra_o1_bus_cntrl);

  LSU_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1,
      data => socket_LSU_i1_data);

  LSU_i2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B3,
      data => socket_LSU_i2_data);

  LSU_i3 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B0,
      data => socket_LSU_i3_data);

  LSU_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B2_alt3,
      databus1_alt => databus_B0_alt3,
      databus2_alt => databus_B1_alt3,
      data0 => socket_LSU_o1_data0,
      databus_cntrl => socket_LSU_o1_bus_cntrl);

  MUL_DIV_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1,
      data => socket_MUL_DIV_i1_data);

  MUL_DIV_i2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B0,
      data => socket_MUL_DIV_i2_data);

  MUL_DIV_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B0_alt4,
      databus1_alt => databus_B1_alt4,
      databus2_alt => databus_B2_alt4,
      data0 => socket_MUL_DIV_o1_data0,
      databus_cntrl => socket_MUL_DIV_o1_bus_cntrl);

  RF_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B2,
      data => socket_RF_i1_data);

  RF_o1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_alt5,
      data0 => socket_RF_o1_data0,
      databus_cntrl => socket_RF_o1_bus_cntrl);

  RF_o2 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B0_alt5,
      data0 => socket_RF_o2_data0,
      databus_cntrl => socket_RF_o2_bus_cntrl);

  STDOUT_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 8)
    port map (
      databus0 => databus_B1,
      data => socket_STDOUT_i1_data);

  STDOUT_i2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 1)
    port map (
      databus0 => databus_B0,
      data => socket_STDOUT_i2_data);

  STDOUT_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 1,
      BUSW_1 => 1,
      BUSW_2 => 1,
      DATAW_0 => 1)
    port map (
      databus0_alt => databus_B1_alt6,
      databus1_alt => databus_B0_alt6,
      databus2_alt => databus_B2_alt5,
      data0 => socket_STDOUT_o1_data0,
      databus_cntrl => socket_STDOUT_o1_bus_cntrl);

  simm_socket_B3 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B3_simm,
      data0 => simm_B3,
      databus_cntrl => simm_cntrl_B3);

  databus_B0 <= tce_ext(databus_B0_alt0, databus_B0'length) or tce_ext(databus_B0_alt1, databus_B0'length) or tce_ext(databus_B0_alt2, databus_B0'length) or tce_ext(databus_B0_alt3, databus_B0'length) or tce_ext(databus_B0_alt4, databus_B0'length) or tce_ext(databus_B0_alt5, databus_B0'length) or tce_ext(databus_B0_alt6, databus_B0'length);
  databus_B1 <= tce_ext(databus_B1_alt0, databus_B1'length) or tce_ext(databus_B1_alt1, databus_B1'length) or tce_ext(databus_B1_alt2, databus_B1'length) or tce_ext(databus_B1_alt3, databus_B1'length) or tce_ext(databus_B1_alt4, databus_B1'length) or tce_ext(databus_B1_alt5, databus_B1'length) or tce_ext(databus_B1_alt6, databus_B1'length);
  databus_B2 <= tce_ext(databus_B2_alt0, databus_B2'length) or tce_ext(databus_B2_alt1, databus_B2'length) or tce_ext(databus_B2_alt2, databus_B2'length) or tce_ext(databus_B2_alt3, databus_B2'length) or tce_ext(databus_B2_alt4, databus_B2'length) or tce_ext(databus_B2_alt5, databus_B2'length);
  databus_B3 <= tce_sxt(databus_B3_simm, databus_B3'length);

end comb_andor;
