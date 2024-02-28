library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tce_util.all;
use work.tta0_globals.all;
use work.tta0_imem_mau.all;

entity tta0 is

  generic (
    core_id : integer := 0);

  port (
    clk : in std_logic;
    rstx : in std_logic;
    busy : in std_logic;
    imem_en_x : out std_logic;
    imem_addr : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    imem_data : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
    locked : out std_logic;
    fu_LSU_avalid_out : out std_logic_vector(0 downto 0);
    fu_LSU_aready_in : in std_logic_vector(0 downto 0);
    fu_LSU_aaddr_out : out std_logic_vector(17-2-1 downto 0);
    fu_LSU_awren_out : out std_logic_vector(0 downto 0);
    fu_LSU_astrb_out : out std_logic_vector(3 downto 0);
    fu_LSU_rvalid_in : in std_logic_vector(0 downto 0);
    fu_LSU_rready_out : out std_logic_vector(0 downto 0);
    fu_LSU_rdata_in : in std_logic_vector(31 downto 0);
    fu_LSU_adata_out : out std_logic_vector(31 downto 0));

end tta0;

architecture structural of tta0 is

  signal decomp_fetch_en_wire : std_logic;
  signal decomp_lock_wire : std_logic;
  signal decomp_fetchblock_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal decomp_instructionword_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal decomp_glock_wire : std_logic;
  signal decomp_lock_r_wire : std_logic;
  signal fu_MUL_DIV_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_MUL_DIV_t1load_wire : std_logic;
  signal fu_MUL_DIV_t2data_wire : std_logic_vector(31 downto 0);
  signal fu_MUL_DIV_t2load_wire : std_logic;
  signal fu_MUL_DIV_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_MUL_DIV_t1opcode_wire : std_logic_vector(2 downto 0);
  signal fu_MUL_DIV_glock_wire : std_logic;
  signal fu_MUL_DIV_glock_req_wire : std_logic;
  signal fu_STDOUT_t1data_wire : std_logic_vector(7 downto 0);
  signal fu_STDOUT_t1load_wire : std_logic;
  signal fu_STDOUT_t2data_wire : std_logic_vector(0 downto 0);
  signal fu_STDOUT_t2load_wire : std_logic;
  signal fu_STDOUT_o1data_wire : std_logic_vector(0 downto 0);
  signal fu_STDOUT_glock_wire : std_logic;
  signal fu_alu_generated_glock_in_wire : std_logic;
  signal fu_alu_generated_operation_in_wire : std_logic_vector(4-1 downto 0);
  signal fu_alu_generated_glockreq_out_wire : std_logic;
  signal fu_alu_generated_data_P1_in_wire : std_logic_vector(32-1 downto 0);
  signal fu_alu_generated_load_P1_in_wire : std_logic;
  signal fu_alu_generated_data_P2_in_wire : std_logic_vector(32-1 downto 0);
  signal fu_alu_generated_load_P2_in_wire : std_logic;
  signal fu_alu_generated_data_P3_out_wire : std_logic_vector(32-1 downto 0);
  signal fu_lsu_generated_glock_in_wire : std_logic;
  signal fu_lsu_generated_operation_in_wire : std_logic_vector(3-1 downto 0);
  signal fu_lsu_generated_glockreq_out_wire : std_logic;
  signal fu_lsu_generated_data_in1t_in_wire : std_logic_vector(32-1 downto 0);
  signal fu_lsu_generated_load_in1t_in_wire : std_logic;
  signal fu_lsu_generated_data_in2_in_wire : std_logic_vector(32-1 downto 0);
  signal fu_lsu_generated_load_in2_in_wire : std_logic;
  signal fu_lsu_generated_data_out1_out_wire : std_logic_vector(32-1 downto 0);
  signal fu_lsu_generated_data_in3_in_wire : std_logic_vector(32-1 downto 0);
  signal fu_lsu_generated_load_in3_in_wire : std_logic;
  signal ic_glock_wire : std_logic;
  signal ic_socket_RF_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_o1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_GCU_i1_data_wire : std_logic_vector(32-1 downto 0);
  signal ic_socket_GCU_ra_o1_data0_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_GCU_ra_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_RF_o2_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_o2_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_GCU_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_GCU_i3_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_GCU_apc_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_GCU_apc_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_GCU_ra_i1_data_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_ALU_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ALU_i2_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_ALU_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ALU_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_ALU_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_LSU_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_LSU_i3_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_LSU_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_LSU_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_LSU_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_STDOUT_i1_data_wire : std_logic_vector(7 downto 0);
  signal ic_socket_STDOUT_i2_data_wire : std_logic_vector(0 downto 0);
  signal ic_socket_STDOUT_o1_data0_wire : std_logic_vector(0 downto 0);
  signal ic_socket_STDOUT_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_MUL_DIV_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_MUL_DIV_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_MUL_DIV_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_MUL_DIV_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_simm_B3_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B3_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_instructionword_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal inst_decoder_pc_load_wire : std_logic;
  signal inst_decoder_ra_load_wire : std_logic;
  signal inst_decoder_pc_opcode_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_lock_wire : std_logic;
  signal inst_decoder_lock_r_wire : std_logic;
  signal inst_decoder_simm_B3_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B3_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_o1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_GCU_ra_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_RF_o2_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_GCU_apc_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_ALU_i2_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_ALU_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_LSU_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_STDOUT_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_MUL_DIV_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_ALU_P1_load_wire : std_logic;
  signal inst_decoder_fu_ALU_P2_load_wire : std_logic;
  signal inst_decoder_fu_ALU_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_fu_LSU_in1t_load_wire : std_logic;
  signal inst_decoder_fu_LSU_in2_load_wire : std_logic;
  signal inst_decoder_fu_LSU_in3_load_wire : std_logic;
  signal inst_decoder_fu_LSU_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_STDOUT_P1_load_wire : std_logic;
  signal inst_decoder_fu_STDOUT_P2_load_wire : std_logic;
  signal inst_decoder_fu_MUL_DIV_in1t_load_wire : std_logic;
  signal inst_decoder_fu_MUL_DIV_in2_load_wire : std_logic;
  signal inst_decoder_fu_MUL_DIV_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_CU_in_load_wire : std_logic;
  signal inst_decoder_fu_CU_in2_load_wire : std_logic;
  signal inst_decoder_rf_RF_t1_load_wire : std_logic;
  signal inst_decoder_rf_RF_t1_opc_wire : std_logic_vector(4 downto 0);
  signal inst_decoder_rf_RF_r1_load_wire : std_logic;
  signal inst_decoder_rf_RF_r1_opc_wire : std_logic_vector(4 downto 0);
  signal inst_decoder_rf_RF_r2_load_wire : std_logic;
  signal inst_decoder_rf_RF_r2_opc_wire : std_logic_vector(4 downto 0);
  signal inst_decoder_lock_req_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_glock_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_simm_in_wire : std_logic_vector(32-1 downto 0);
  signal inst_fetch_ra_out_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_ra_in_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_pc_in_wire : std_logic_vector(32-1 downto 0);
  signal inst_fetch_pc_load_wire : std_logic;
  signal inst_fetch_ra_load_wire : std_logic;
  signal inst_fetch_pc_opcode_wire : std_logic_vector(3 downto 0);
  signal inst_fetch_fetch_en_wire : std_logic;
  signal inst_fetch_glock_wire : std_logic;
  signal inst_fetch_fetchblock_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal inst_fetch_in_data_wire : std_logic_vector(32-1 downto 0);
  signal inst_fetch_in_load_wire : std_logic;
  signal inst_fetch_in2_data_wire : std_logic_vector(32-1 downto 0);
  signal inst_fetch_in2_load_wire : std_logic;
  signal inst_fetch_out_data_wire : std_logic_vector(32-1 downto 0);
  signal inst_fetch_ifetch_stall_wire : std_logic;
  signal inst_fetch_rv_offset_wire : std_logic_vector(32-1 downto 0);
  signal inst_fetch_rv_jump_wire : std_logic;
  signal inst_fetch_rv_auipc_wire : std_logic;
  signal rf_RF_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_r1load_wire : std_logic;
  signal rf_RF_r1opcode_wire : std_logic_vector(4 downto 0);
  signal rf_RF_r2data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_r2load_wire : std_logic;
  signal rf_RF_r2opcode_wire : std_logic_vector(4 downto 0);
  signal rf_RF_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF_t1load_wire : std_logic;
  signal rf_RF_t1opcode_wire : std_logic_vector(4 downto 0);
  signal rf_RF_glock_wire : std_logic;
  signal rv32_microcode_wrapper_i_glock_in_wire : std_logic;
  signal rv32_microcode_wrapper_i_instruction_out_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal rv32_microcode_wrapper_i_simm_out_wire : std_logic_vector(32-1 downto 0);
  signal rv32_microcode_wrapper_i_instruction_in_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal rv32_microcode_wrapper_i_ifetch_stall_wire : std_logic;
  signal rv32_microcode_wrapper_i_rv_jump_wire : std_logic;
  signal rv32_microcode_wrapper_i_rv_auipc_wire : std_logic;
  signal rv32_microcode_wrapper_i_rv_offset_wire : std_logic_vector(32-1 downto 0);

  component tta0_ifetch is
    generic (
      bypass_fetchblock_register : boolean);
    port (
      clk : in std_logic;
      rstx : in std_logic;
      ra_out : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      ra_in : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      busy : in std_logic;
      imem_en_x : out std_logic;
      imem_addr : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      imem_data : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      pc_in : in std_logic_vector(32-1 downto 0);
      pc_load : in std_logic;
      ra_load : in std_logic;
      pc_opcode : in std_logic_vector(4-1 downto 0);
      fetch_en : in std_logic;
      glock : out std_logic;
      fetchblock : out std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      in_data : in std_logic_vector(32-1 downto 0);
      in_load : in std_logic;
      in2_data : in std_logic_vector(32-1 downto 0);
      in2_load : in std_logic;
      out_data : out std_logic_vector(32-1 downto 0);
      ifetch_stall : in std_logic;
      rv_offset : in std_logic_vector(32-1 downto 0);
      rv_jump : in std_logic;
      rv_auipc : in std_logic);
  end component;

  component tta0_decompressor is
    port (
      fetch_en : out std_logic;
      lock : in std_logic;
      fetchblock : in std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      instructionword : out std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
      glock : out std_logic;
      lock_r : in std_logic);
  end component;

  component tta0_decoder is
    port (
      instructionword : in std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
      pc_load : out std_logic;
      ra_load : out std_logic;
      pc_opcode : out std_logic_vector(4-1 downto 0);
      lock : in std_logic;
      lock_r : out std_logic;
      clk : in std_logic;
      rstx : in std_logic;
      locked : out std_logic;
      simm_B3 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B3 : out std_logic_vector(1-1 downto 0);
      socket_RF_o1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_GCU_ra_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_RF_o2_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_GCU_apc_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_ALU_i2_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_ALU_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_LSU_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_STDOUT_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_MUL_DIV_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      fu_ALU_P1_load : out std_logic;
      fu_ALU_P2_load : out std_logic;
      fu_ALU_opc : out std_logic_vector(4-1 downto 0);
      fu_LSU_in1t_load : out std_logic;
      fu_LSU_in2_load : out std_logic;
      fu_LSU_in3_load : out std_logic;
      fu_LSU_opc : out std_logic_vector(3-1 downto 0);
      fu_STDOUT_P1_load : out std_logic;
      fu_STDOUT_P2_load : out std_logic;
      fu_MUL_DIV_in1t_load : out std_logic;
      fu_MUL_DIV_in2_load : out std_logic;
      fu_MUL_DIV_opc : out std_logic_vector(3-1 downto 0);
      fu_CU_in_load : out std_logic;
      fu_CU_in2_load : out std_logic;
      rf_RF_t1_load : out std_logic;
      rf_RF_t1_opc : out std_logic_vector(5-1 downto 0);
      rf_RF_r1_load : out std_logic;
      rf_RF_r1_opc : out std_logic_vector(5-1 downto 0);
      rf_RF_r2_load : out std_logic;
      rf_RF_r2_opc : out std_logic_vector(5-1 downto 0);
      lock_req : in std_logic_vector(3-1 downto 0);
      glock : out std_logic_vector(6-1 downto 0);
      simm_in : in std_logic_vector(32-1 downto 0));
  end component;

  component fu_alu is
    port (
      clk : in std_logic;
      rstx : in std_logic;
      glock_in : in std_logic;
      operation_in : in std_logic_vector(4-1 downto 0);
      glockreq_out : out std_logic;
      data_P1_in : in std_logic_vector(32-1 downto 0);
      load_P1_in : in std_logic;
      data_P2_in : in std_logic_vector(32-1 downto 0);
      load_P2_in : in std_logic;
      data_P3_out : out std_logic_vector(32-1 downto 0));
  end component;

  component fu_lsu is
    port (
      clk : in std_logic;
      rstx : in std_logic;
      glock_in : in std_logic;
      operation_in : in std_logic_vector(3-1 downto 0);
      glockreq_out : out std_logic;
      data_in1t_in : in std_logic_vector(32-1 downto 0);
      load_in1t_in : in std_logic;
      data_in2_in : in std_logic_vector(32-1 downto 0);
      load_in2_in : in std_logic;
      data_out1_out : out std_logic_vector(32-1 downto 0);
      data_in3_in : in std_logic_vector(32-1 downto 0);
      load_in3_in : in std_logic;
      avalid_out : out std_logic_vector(1-1 downto 0);
      aready_in : in std_logic_vector(1-1 downto 0);
      aaddr_out : out std_logic_vector(17-2-1 downto 0);
      awren_out : out std_logic_vector(1-1 downto 0);
      astrb_out : out std_logic_vector(4-1 downto 0);
      rvalid_in : in std_logic_vector(1-1 downto 0);
      rready_out : out std_logic_vector(1-1 downto 0);
      rdata_in : in std_logic_vector(32-1 downto 0);
      adata_out : out std_logic_vector(32-1 downto 0));
  end component;

  component printchar_always_1 is
    generic (
      dataw : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t2data : in std_logic_vector(1-1 downto 0);
      t2load : in std_logic;
      o1data : out std_logic_vector(1-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component div_divu_mul_mulhi_mulhisu_mulhiu_rem_remu is
    generic (
      dataw : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t2data : in std_logic_vector(dataw-1 downto 0);
      t2load : in std_logic;
      r1data : out std_logic_vector(dataw-1 downto 0);
      t1opcode : in std_logic_vector(3-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic;
      glock_req : out std_logic);
  end component;

  component rf_1wr_2rd_always_1_zero_reg is
    generic (
      rf_size : integer;
      dataw : integer);
    port (
      r1data : out std_logic_vector(dataw-1 downto 0);
      r1load : in std_logic;
      r1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      r2data : out std_logic_vector(dataw-1 downto 0);
      r2load : in std_logic;
      r2opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component tta0_interconn is
    port (
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic;
      socket_RF_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_o1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_GCU_i1_data : out std_logic_vector(32-1 downto 0);
      socket_GCU_ra_o1_data0 : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_GCU_ra_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_RF_o2_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_o2_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_GCU_i2_data : out std_logic_vector(32-1 downto 0);
      socket_GCU_i3_data : out std_logic_vector(32-1 downto 0);
      socket_GCU_apc_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_GCU_apc_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_GCU_ra_i1_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_ALU_i2_data : out std_logic_vector(32-1 downto 0);
      socket_ALU_i2_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_ALU_i1_data : out std_logic_vector(32-1 downto 0);
      socket_ALU_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_ALU_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_LSU_i2_data : out std_logic_vector(32-1 downto 0);
      socket_LSU_i3_data : out std_logic_vector(32-1 downto 0);
      socket_LSU_i1_data : out std_logic_vector(32-1 downto 0);
      socket_LSU_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_LSU_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_STDOUT_i1_data : out std_logic_vector(8-1 downto 0);
      socket_STDOUT_i2_data : out std_logic_vector(1-1 downto 0);
      socket_STDOUT_o1_data0 : in std_logic_vector(1-1 downto 0);
      socket_STDOUT_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_MUL_DIV_i1_data : out std_logic_vector(32-1 downto 0);
      socket_MUL_DIV_i2_data : out std_logic_vector(32-1 downto 0);
      socket_MUL_DIV_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_MUL_DIV_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      simm_B3 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B3 : in std_logic_vector(1-1 downto 0));
  end component;

  component rv32_microcode_wrapper is
    port (
      clk : in std_logic;
      rstx : in std_logic;
      glock_in : in std_logic;
      instruction_out : out std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
      simm_out : out std_logic_vector(32-1 downto 0);
      instruction_in : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      ifetch_stall : out std_logic;
      rv_jump : out std_logic;
      rv_auipc : out std_logic;
      rv_offset : out std_logic_vector(32-1 downto 0));
  end component;


begin

  ic_socket_GCU_ra_o1_data0_wire <= inst_fetch_ra_out_wire;
  inst_fetch_ra_in_wire <= ic_socket_GCU_ra_i1_data_wire;
  inst_fetch_pc_in_wire <= ic_socket_GCU_i1_data_wire;
  inst_fetch_pc_load_wire <= inst_decoder_pc_load_wire;
  inst_fetch_ra_load_wire <= inst_decoder_ra_load_wire;
  inst_fetch_pc_opcode_wire <= inst_decoder_pc_opcode_wire;
  inst_fetch_fetch_en_wire <= decomp_fetch_en_wire;
  decomp_lock_wire <= inst_fetch_glock_wire;
  rv32_microcode_wrapper_i_glock_in_wire <= inst_fetch_glock_wire;
  rv32_microcode_wrapper_i_instruction_in_wire <= inst_fetch_fetchblock_wire;
  inst_fetch_in_data_wire <= ic_socket_GCU_i2_data_wire;
  inst_fetch_in_load_wire <= inst_decoder_fu_CU_in_load_wire;
  inst_fetch_in2_data_wire <= ic_socket_GCU_i3_data_wire;
  inst_fetch_in2_load_wire <= inst_decoder_fu_CU_in2_load_wire;
  ic_socket_GCU_apc_o1_data0_wire <= inst_fetch_out_data_wire;
  inst_fetch_ifetch_stall_wire <= rv32_microcode_wrapper_i_ifetch_stall_wire;
  inst_fetch_rv_offset_wire <= rv32_microcode_wrapper_i_rv_offset_wire;
  inst_fetch_rv_jump_wire <= rv32_microcode_wrapper_i_rv_jump_wire;
  inst_fetch_rv_auipc_wire <= rv32_microcode_wrapper_i_rv_auipc_wire;
  decomp_fetchblock_wire <= rv32_microcode_wrapper_i_instruction_out_wire;
  inst_decoder_instructionword_wire <= decomp_instructionword_wire;
  inst_decoder_lock_wire <= decomp_glock_wire;
  decomp_lock_r_wire <= inst_decoder_lock_r_wire;
  ic_simm_B3_wire <= inst_decoder_simm_B3_wire;
  ic_simm_cntrl_B3_wire <= inst_decoder_simm_cntrl_B3_wire;
  ic_socket_RF_o1_bus_cntrl_wire <= inst_decoder_socket_RF_o1_bus_cntrl_wire;
  ic_socket_GCU_ra_o1_bus_cntrl_wire <= inst_decoder_socket_GCU_ra_o1_bus_cntrl_wire;
  ic_socket_RF_o2_bus_cntrl_wire <= inst_decoder_socket_RF_o2_bus_cntrl_wire;
  ic_socket_GCU_apc_o1_bus_cntrl_wire <= inst_decoder_socket_GCU_apc_o1_bus_cntrl_wire;
  ic_socket_ALU_i2_bus_cntrl_wire <= inst_decoder_socket_ALU_i2_bus_cntrl_wire;
  ic_socket_ALU_o1_bus_cntrl_wire <= inst_decoder_socket_ALU_o1_bus_cntrl_wire;
  ic_socket_LSU_o1_bus_cntrl_wire <= inst_decoder_socket_LSU_o1_bus_cntrl_wire;
  ic_socket_STDOUT_o1_bus_cntrl_wire <= inst_decoder_socket_STDOUT_o1_bus_cntrl_wire;
  ic_socket_MUL_DIV_o1_bus_cntrl_wire <= inst_decoder_socket_MUL_DIV_o1_bus_cntrl_wire;
  fu_alu_generated_load_P1_in_wire <= inst_decoder_fu_ALU_P1_load_wire;
  fu_alu_generated_load_P2_in_wire <= inst_decoder_fu_ALU_P2_load_wire;
  fu_alu_generated_operation_in_wire <= inst_decoder_fu_ALU_opc_wire;
  fu_lsu_generated_load_in1t_in_wire <= inst_decoder_fu_LSU_in1t_load_wire;
  fu_lsu_generated_load_in2_in_wire <= inst_decoder_fu_LSU_in2_load_wire;
  fu_lsu_generated_load_in3_in_wire <= inst_decoder_fu_LSU_in3_load_wire;
  fu_lsu_generated_operation_in_wire <= inst_decoder_fu_LSU_opc_wire;
  fu_STDOUT_t1load_wire <= inst_decoder_fu_STDOUT_P1_load_wire;
  fu_STDOUT_t2load_wire <= inst_decoder_fu_STDOUT_P2_load_wire;
  fu_MUL_DIV_t1load_wire <= inst_decoder_fu_MUL_DIV_in1t_load_wire;
  fu_MUL_DIV_t2load_wire <= inst_decoder_fu_MUL_DIV_in2_load_wire;
  fu_MUL_DIV_t1opcode_wire <= inst_decoder_fu_MUL_DIV_opc_wire;
  rf_RF_t1load_wire <= inst_decoder_rf_RF_t1_load_wire;
  rf_RF_t1opcode_wire <= inst_decoder_rf_RF_t1_opc_wire;
  rf_RF_r1load_wire <= inst_decoder_rf_RF_r1_load_wire;
  rf_RF_r1opcode_wire <= inst_decoder_rf_RF_r1_opc_wire;
  rf_RF_r2load_wire <= inst_decoder_rf_RF_r2_load_wire;
  rf_RF_r2opcode_wire <= inst_decoder_rf_RF_r2_opc_wire;
  inst_decoder_lock_req_wire(0) <= fu_alu_generated_glockreq_out_wire;
  inst_decoder_lock_req_wire(1) <= fu_lsu_generated_glockreq_out_wire;
  inst_decoder_lock_req_wire(2) <= fu_MUL_DIV_glock_req_wire;
  fu_alu_generated_glock_in_wire <= inst_decoder_glock_wire(0);
  fu_lsu_generated_glock_in_wire <= inst_decoder_glock_wire(1);
  fu_STDOUT_glock_wire <= inst_decoder_glock_wire(2);
  fu_MUL_DIV_glock_wire <= inst_decoder_glock_wire(3);
  rf_RF_glock_wire <= inst_decoder_glock_wire(4);
  ic_glock_wire <= inst_decoder_glock_wire(5);
  inst_decoder_simm_in_wire <= rv32_microcode_wrapper_i_simm_out_wire;
  fu_alu_generated_data_P1_in_wire <= ic_socket_ALU_i1_data_wire;
  fu_alu_generated_data_P2_in_wire <= ic_socket_ALU_i2_data_wire;
  ic_socket_ALU_o1_data0_wire <= fu_alu_generated_data_P3_out_wire;
  fu_lsu_generated_data_in1t_in_wire <= ic_socket_LSU_i1_data_wire;
  fu_lsu_generated_data_in2_in_wire <= ic_socket_LSU_i2_data_wire;
  ic_socket_LSU_o1_data0_wire <= fu_lsu_generated_data_out1_out_wire;
  fu_lsu_generated_data_in3_in_wire <= ic_socket_LSU_i3_data_wire;
  fu_STDOUT_t1data_wire <= ic_socket_STDOUT_i1_data_wire;
  fu_STDOUT_t2data_wire <= ic_socket_STDOUT_i2_data_wire;
  ic_socket_STDOUT_o1_data0_wire <= fu_STDOUT_o1data_wire;
  fu_MUL_DIV_t1data_wire <= ic_socket_MUL_DIV_i1_data_wire;
  fu_MUL_DIV_t2data_wire <= ic_socket_MUL_DIV_i2_data_wire;
  ic_socket_MUL_DIV_o1_data0_wire <= fu_MUL_DIV_r1data_wire;
  ic_socket_RF_o1_data0_wire <= rf_RF_r1data_wire;
  ic_socket_RF_o2_data0_wire <= rf_RF_r2data_wire;
  rf_RF_t1data_wire <= ic_socket_RF_i1_data_wire;

  inst_fetch : tta0_ifetch
    generic map (
      bypass_fetchblock_register => true)
    port map (
      clk => clk,
      rstx => rstx,
      ra_out => inst_fetch_ra_out_wire,
      ra_in => inst_fetch_ra_in_wire,
      busy => busy,
      imem_en_x => imem_en_x,
      imem_addr => imem_addr,
      imem_data => imem_data,
      pc_in => inst_fetch_pc_in_wire,
      pc_load => inst_fetch_pc_load_wire,
      ra_load => inst_fetch_ra_load_wire,
      pc_opcode => inst_fetch_pc_opcode_wire,
      fetch_en => inst_fetch_fetch_en_wire,
      glock => inst_fetch_glock_wire,
      fetchblock => inst_fetch_fetchblock_wire,
      in_data => inst_fetch_in_data_wire,
      in_load => inst_fetch_in_load_wire,
      in2_data => inst_fetch_in2_data_wire,
      in2_load => inst_fetch_in2_load_wire,
      out_data => inst_fetch_out_data_wire,
      ifetch_stall => inst_fetch_ifetch_stall_wire,
      rv_offset => inst_fetch_rv_offset_wire,
      rv_jump => inst_fetch_rv_jump_wire,
      rv_auipc => inst_fetch_rv_auipc_wire);

  decomp : tta0_decompressor
    port map (
      fetch_en => decomp_fetch_en_wire,
      lock => decomp_lock_wire,
      fetchblock => decomp_fetchblock_wire,
      clk => clk,
      rstx => rstx,
      instructionword => decomp_instructionword_wire,
      glock => decomp_glock_wire,
      lock_r => decomp_lock_r_wire);

  inst_decoder : tta0_decoder
    port map (
      instructionword => inst_decoder_instructionword_wire,
      pc_load => inst_decoder_pc_load_wire,
      ra_load => inst_decoder_ra_load_wire,
      pc_opcode => inst_decoder_pc_opcode_wire,
      lock => inst_decoder_lock_wire,
      lock_r => inst_decoder_lock_r_wire,
      clk => clk,
      rstx => rstx,
      locked => locked,
      simm_B3 => inst_decoder_simm_B3_wire,
      simm_cntrl_B3 => inst_decoder_simm_cntrl_B3_wire,
      socket_RF_o1_bus_cntrl => inst_decoder_socket_RF_o1_bus_cntrl_wire,
      socket_GCU_ra_o1_bus_cntrl => inst_decoder_socket_GCU_ra_o1_bus_cntrl_wire,
      socket_RF_o2_bus_cntrl => inst_decoder_socket_RF_o2_bus_cntrl_wire,
      socket_GCU_apc_o1_bus_cntrl => inst_decoder_socket_GCU_apc_o1_bus_cntrl_wire,
      socket_ALU_i2_bus_cntrl => inst_decoder_socket_ALU_i2_bus_cntrl_wire,
      socket_ALU_o1_bus_cntrl => inst_decoder_socket_ALU_o1_bus_cntrl_wire,
      socket_LSU_o1_bus_cntrl => inst_decoder_socket_LSU_o1_bus_cntrl_wire,
      socket_STDOUT_o1_bus_cntrl => inst_decoder_socket_STDOUT_o1_bus_cntrl_wire,
      socket_MUL_DIV_o1_bus_cntrl => inst_decoder_socket_MUL_DIV_o1_bus_cntrl_wire,
      fu_ALU_P1_load => inst_decoder_fu_ALU_P1_load_wire,
      fu_ALU_P2_load => inst_decoder_fu_ALU_P2_load_wire,
      fu_ALU_opc => inst_decoder_fu_ALU_opc_wire,
      fu_LSU_in1t_load => inst_decoder_fu_LSU_in1t_load_wire,
      fu_LSU_in2_load => inst_decoder_fu_LSU_in2_load_wire,
      fu_LSU_in3_load => inst_decoder_fu_LSU_in3_load_wire,
      fu_LSU_opc => inst_decoder_fu_LSU_opc_wire,
      fu_STDOUT_P1_load => inst_decoder_fu_STDOUT_P1_load_wire,
      fu_STDOUT_P2_load => inst_decoder_fu_STDOUT_P2_load_wire,
      fu_MUL_DIV_in1t_load => inst_decoder_fu_MUL_DIV_in1t_load_wire,
      fu_MUL_DIV_in2_load => inst_decoder_fu_MUL_DIV_in2_load_wire,
      fu_MUL_DIV_opc => inst_decoder_fu_MUL_DIV_opc_wire,
      fu_CU_in_load => inst_decoder_fu_CU_in_load_wire,
      fu_CU_in2_load => inst_decoder_fu_CU_in2_load_wire,
      rf_RF_t1_load => inst_decoder_rf_RF_t1_load_wire,
      rf_RF_t1_opc => inst_decoder_rf_RF_t1_opc_wire,
      rf_RF_r1_load => inst_decoder_rf_RF_r1_load_wire,
      rf_RF_r1_opc => inst_decoder_rf_RF_r1_opc_wire,
      rf_RF_r2_load => inst_decoder_rf_RF_r2_load_wire,
      rf_RF_r2_opc => inst_decoder_rf_RF_r2_opc_wire,
      lock_req => inst_decoder_lock_req_wire,
      glock => inst_decoder_glock_wire,
      simm_in => inst_decoder_simm_in_wire);

  fu_alu_generated : fu_alu
    port map (
      clk => clk,
      rstx => rstx,
      glock_in => fu_alu_generated_glock_in_wire,
      operation_in => fu_alu_generated_operation_in_wire,
      glockreq_out => fu_alu_generated_glockreq_out_wire,
      data_P1_in => fu_alu_generated_data_P1_in_wire,
      load_P1_in => fu_alu_generated_load_P1_in_wire,
      data_P2_in => fu_alu_generated_data_P2_in_wire,
      load_P2_in => fu_alu_generated_load_P2_in_wire,
      data_P3_out => fu_alu_generated_data_P3_out_wire);

  fu_lsu_generated : fu_lsu
    port map (
      clk => clk,
      rstx => rstx,
      glock_in => fu_lsu_generated_glock_in_wire,
      operation_in => fu_lsu_generated_operation_in_wire,
      glockreq_out => fu_lsu_generated_glockreq_out_wire,
      data_in1t_in => fu_lsu_generated_data_in1t_in_wire,
      load_in1t_in => fu_lsu_generated_load_in1t_in_wire,
      data_in2_in => fu_lsu_generated_data_in2_in_wire,
      load_in2_in => fu_lsu_generated_load_in2_in_wire,
      data_out1_out => fu_lsu_generated_data_out1_out_wire,
      data_in3_in => fu_lsu_generated_data_in3_in_wire,
      load_in3_in => fu_lsu_generated_load_in3_in_wire,
      avalid_out => fu_LSU_avalid_out,
      aready_in => fu_LSU_aready_in,
      aaddr_out => fu_LSU_aaddr_out,
      awren_out => fu_LSU_awren_out,
      astrb_out => fu_LSU_astrb_out,
      rvalid_in => fu_LSU_rvalid_in,
      rready_out => fu_LSU_rready_out,
      rdata_in => fu_LSU_rdata_in,
      adata_out => fu_LSU_adata_out);

  fu_STDOUT : printchar_always_1
    generic map (
      dataw => 8)
    port map (
      t1data => fu_STDOUT_t1data_wire,
      t1load => fu_STDOUT_t1load_wire,
      t2data => fu_STDOUT_t2data_wire,
      t2load => fu_STDOUT_t2load_wire,
      o1data => fu_STDOUT_o1data_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_STDOUT_glock_wire);

  fu_MUL_DIV : div_divu_mul_mulhi_mulhisu_mulhiu_rem_remu
    generic map (
      dataw => 32)
    port map (
      t1data => fu_MUL_DIV_t1data_wire,
      t1load => fu_MUL_DIV_t1load_wire,
      t2data => fu_MUL_DIV_t2data_wire,
      t2load => fu_MUL_DIV_t2load_wire,
      r1data => fu_MUL_DIV_r1data_wire,
      t1opcode => fu_MUL_DIV_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_MUL_DIV_glock_wire,
      glock_req => fu_MUL_DIV_glock_req_wire);

  rf_RF : rf_1wr_2rd_always_1_zero_reg
    generic map (
      rf_size => 32,
      dataw => 32)
    port map (
      r1data => rf_RF_r1data_wire,
      r1load => rf_RF_r1load_wire,
      r1opcode => rf_RF_r1opcode_wire,
      r2data => rf_RF_r2data_wire,
      r2load => rf_RF_r2load_wire,
      r2opcode => rf_RF_r2opcode_wire,
      t1data => rf_RF_t1data_wire,
      t1load => rf_RF_t1load_wire,
      t1opcode => rf_RF_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF_glock_wire);

  ic : tta0_interconn
    port map (
      clk => clk,
      rstx => rstx,
      glock => ic_glock_wire,
      socket_RF_i1_data => ic_socket_RF_i1_data_wire,
      socket_RF_o1_data0 => ic_socket_RF_o1_data0_wire,
      socket_RF_o1_bus_cntrl => ic_socket_RF_o1_bus_cntrl_wire,
      socket_GCU_i1_data => ic_socket_GCU_i1_data_wire,
      socket_GCU_ra_o1_data0 => ic_socket_GCU_ra_o1_data0_wire,
      socket_GCU_ra_o1_bus_cntrl => ic_socket_GCU_ra_o1_bus_cntrl_wire,
      socket_RF_o2_data0 => ic_socket_RF_o2_data0_wire,
      socket_RF_o2_bus_cntrl => ic_socket_RF_o2_bus_cntrl_wire,
      socket_GCU_i2_data => ic_socket_GCU_i2_data_wire,
      socket_GCU_i3_data => ic_socket_GCU_i3_data_wire,
      socket_GCU_apc_o1_data0 => ic_socket_GCU_apc_o1_data0_wire,
      socket_GCU_apc_o1_bus_cntrl => ic_socket_GCU_apc_o1_bus_cntrl_wire,
      socket_GCU_ra_i1_data => ic_socket_GCU_ra_i1_data_wire,
      socket_ALU_i2_data => ic_socket_ALU_i2_data_wire,
      socket_ALU_i2_bus_cntrl => ic_socket_ALU_i2_bus_cntrl_wire,
      socket_ALU_i1_data => ic_socket_ALU_i1_data_wire,
      socket_ALU_o1_data0 => ic_socket_ALU_o1_data0_wire,
      socket_ALU_o1_bus_cntrl => ic_socket_ALU_o1_bus_cntrl_wire,
      socket_LSU_i2_data => ic_socket_LSU_i2_data_wire,
      socket_LSU_i3_data => ic_socket_LSU_i3_data_wire,
      socket_LSU_i1_data => ic_socket_LSU_i1_data_wire,
      socket_LSU_o1_data0 => ic_socket_LSU_o1_data0_wire,
      socket_LSU_o1_bus_cntrl => ic_socket_LSU_o1_bus_cntrl_wire,
      socket_STDOUT_i1_data => ic_socket_STDOUT_i1_data_wire,
      socket_STDOUT_i2_data => ic_socket_STDOUT_i2_data_wire,
      socket_STDOUT_o1_data0 => ic_socket_STDOUT_o1_data0_wire,
      socket_STDOUT_o1_bus_cntrl => ic_socket_STDOUT_o1_bus_cntrl_wire,
      socket_MUL_DIV_i1_data => ic_socket_MUL_DIV_i1_data_wire,
      socket_MUL_DIV_i2_data => ic_socket_MUL_DIV_i2_data_wire,
      socket_MUL_DIV_o1_data0 => ic_socket_MUL_DIV_o1_data0_wire,
      socket_MUL_DIV_o1_bus_cntrl => ic_socket_MUL_DIV_o1_bus_cntrl_wire,
      simm_B3 => ic_simm_B3_wire,
      simm_cntrl_B3 => ic_simm_cntrl_B3_wire);

  rv32_microcode_wrapper_i : rv32_microcode_wrapper
    port map (
      clk => clk,
      rstx => rstx,
      glock_in => rv32_microcode_wrapper_i_glock_in_wire,
      instruction_out => rv32_microcode_wrapper_i_instruction_out_wire,
      simm_out => rv32_microcode_wrapper_i_simm_out_wire,
      instruction_in => rv32_microcode_wrapper_i_instruction_in_wire,
      ifetch_stall => rv32_microcode_wrapper_i_ifetch_stall_wire,
      rv_jump => rv32_microcode_wrapper_i_rv_jump_wire,
      rv_auipc => rv32_microcode_wrapper_i_rv_auipc_wire,
      rv_offset => rv32_microcode_wrapper_i_rv_offset_wire);

end structural;
