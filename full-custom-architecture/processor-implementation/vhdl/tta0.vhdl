library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tce_util.all;
use work.tta0_globals.all;
use work.tta0_imem_mau.all;
use work.tta0_params.all;

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
    fu_lsu_mem_en_x : out std_logic_vector(0 downto 0);
    fu_lsu_wr_en_x : out std_logic_vector(0 downto 0);
    fu_lsu_wr_mask_x : out std_logic_vector(fu_lsu_dataw-1 downto 0);
    fu_lsu_addr : out std_logic_vector(fu_lsu_addrw-2-1 downto 0);
    fu_lsu_data_in : in std_logic_vector(fu_lsu_dataw-1 downto 0);
    fu_lsu_data_out : out std_logic_vector(fu_lsu_dataw-1 downto 0));

end tta0;

architecture structural of tta0 is

  signal decomp_fetch_en_wire : std_logic;
  signal decomp_lock_wire : std_logic;
  signal decomp_fetchblock_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal decomp_instructionword_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal decomp_glock_wire : std_logic;
  signal decomp_lock_r_wire : std_logic;
  signal fu_FU_ALGO_1_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_1_t1load_wire : std_logic;
  signal fu_FU_ALGO_1_t2data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_1_t2load_wire : std_logic;
  signal fu_FU_ALGO_1_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_1_t1opcode_wire : std_logic_vector(2 downto 0);
  signal fu_FU_ALGO_1_glock_wire : std_logic;
  signal fu_FU_ALGO_2_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_2_t1load_wire : std_logic;
  signal fu_FU_ALGO_2_t2data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_2_t2load_wire : std_logic;
  signal fu_FU_ALGO_2_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_2_t1opcode_wire : std_logic_vector(2 downto 0);
  signal fu_FU_ALGO_2_glock_wire : std_logic;
  signal fu_FU_ALGO_3_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_3_t1load_wire : std_logic;
  signal fu_FU_ALGO_3_t2data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_3_t2load_wire : std_logic;
  signal fu_FU_ALGO_3_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_3_t1opcode_wire : std_logic_vector(2 downto 0);
  signal fu_FU_ALGO_3_glock_wire : std_logic;
  signal fu_FU_ALGO_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_t1load_wire : std_logic;
  signal fu_FU_ALGO_t2data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_t2load_wire : std_logic;
  signal fu_FU_ALGO_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_ALGO_t1opcode_wire : std_logic_vector(3 downto 0);
  signal fu_FU_ALGO_glock_wire : std_logic;
  signal fu_FU_CORDIC_t1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_CORDIC_t1load_wire : std_logic;
  signal fu_FU_CORDIC_t2data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_CORDIC_t2load_wire : std_logic;
  signal fu_FU_CORDIC_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_FU_CORDIC_glock_wire : std_logic;
  signal fu_alu_data_in1t_in_wire : std_logic_vector(31 downto 0);
  signal fu_alu_load_in1t_in_wire : std_logic;
  signal fu_alu_data_in2_in_wire : std_logic_vector(31 downto 0);
  signal fu_alu_load_in2_in_wire : std_logic;
  signal fu_alu_data_out1_out_wire : std_logic_vector(31 downto 0);
  signal fu_alu_operation_in_wire : std_logic_vector(3 downto 0);
  signal fu_alu_glock_in_wire : std_logic;
  signal fu_lsu_t1data_wire : std_logic_vector(7 downto 0);
  signal fu_lsu_t1load_wire : std_logic;
  signal fu_lsu_r1data_wire : std_logic_vector(31 downto 0);
  signal fu_lsu_o1data_wire : std_logic_vector(31 downto 0);
  signal fu_lsu_o1load_wire : std_logic;
  signal fu_lsu_t1opcode_wire : std_logic_vector(2 downto 0);
  signal fu_lsu_glock_wire : std_logic;
  signal ic_glock_wire : std_logic;
  signal ic_socket_lsu_i1_data_wire : std_logic_vector(7 downto 0);
  signal ic_socket_lsu_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_lsu_o1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_lsu_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_lsu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_alu_comp_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_alu_comp_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_alu_comp_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_alu_comp_o1_bus_cntrl_wire : std_logic_vector(4 downto 0);
  signal ic_socket_gcu_i1_data_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_gcu_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_gcu_i2_data_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_gcu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_gcu_o1_data0_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal ic_socket_gcu_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_FU_ALGORITHM_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_FU_ALGORITHM_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_FU_ALGORITHM_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_FU_ALGORITHM_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_RF_8x32_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_o1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_i1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_i1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_FU_CORDIC_i1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_FU_CORDIC_i2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_FU_CORDIC_o1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_FU_CORDIC_o1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_3_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_3_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_2_1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_3_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_3_1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_3_1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_3_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_3_1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_1_1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_2_1_1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_3_1_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_3_1_1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_3_1_1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_3_2_data_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_1_2_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_1_1_1_data0_wire : std_logic_vector(31 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal ic_socket_RF_8x32_1_o1_1_1_3_1_1_data_wire : std_logic_vector(31 downto 0);
  signal ic_simm_B1_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B2_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B2_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B3_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B3_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_1_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_1_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_2_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_2_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_3_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_3_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_4_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_4_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_5_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_5_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_6_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_6_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_7_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_7_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_8_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_8_wire : std_logic_vector(0 downto 0);
  signal ic_simm_B1_9_wire : std_logic_vector(31 downto 0);
  signal ic_simm_cntrl_B1_9_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_instructionword_wire : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
  signal inst_decoder_pc_load_wire : std_logic;
  signal inst_decoder_ra_load_wire : std_logic;
  signal inst_decoder_pc_opcode_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_lock_wire : std_logic;
  signal inst_decoder_lock_r_wire : std_logic;
  signal inst_decoder_simm_B1_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B2_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B2_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B3_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B3_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_1_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_1_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_2_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_2_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_3_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_3_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_4_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_4_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_5_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_5_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_6_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_6_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_7_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_7_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_8_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_8_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_simm_B1_9_wire : std_logic_vector(31 downto 0);
  signal inst_decoder_simm_cntrl_B1_9_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_lsu_o1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_lsu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_alu_comp_o1_bus_cntrl_wire : std_logic_vector(4 downto 0);
  signal inst_decoder_socket_gcu_i1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_gcu_i2_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_gcu_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_FU_ALGORITHM_o1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_RF_8x32_o1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_i1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_1_i1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_FU_CORDIC_o1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_3_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_1_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_1_1_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_3_1_bus_cntrl_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_1_2_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_3_1_1_bus_cntrl_wire : std_logic_vector(1 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_wire : std_logic_vector(0 downto 0);
  signal inst_decoder_fu_lsu_in1t_load_wire : std_logic;
  signal inst_decoder_fu_lsu_in2_load_wire : std_logic;
  signal inst_decoder_fu_lsu_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_alu_in1t_load_wire : std_logic;
  signal inst_decoder_fu_alu_in2_load_wire : std_logic;
  signal inst_decoder_fu_alu_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_fu_FU_ALGO_P1_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_P2_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_fu_FU_CORDIC_P1_load_wire : std_logic;
  signal inst_decoder_fu_FU_CORDIC_P2_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_1_P1_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_1_P2_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_1_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_FU_ALGO_2_P1_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_2_P2_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_2_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_fu_FU_ALGO_3_P1_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_3_P2_load_wire : std_logic;
  signal inst_decoder_fu_FU_ALGO_3_opc_wire : std_logic_vector(2 downto 0);
  signal inst_decoder_rf_RF1_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_r0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF1_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_w0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF2_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_r0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_rf_RF2_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_w0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_rf_RF1_1_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_1_r0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF1_1_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_1_w0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF2_1_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_1_r0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_rf_RF2_1_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_1_w0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_rf_RF1_2_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_2_r0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF1_2_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_2_w0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF2_2_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_2_r0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_rf_RF2_2_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_2_w0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_rf_RF1_3_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_3_r0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF1_3_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF1_3_w0_opc_wire : std_logic_vector(3 downto 0);
  signal inst_decoder_rf_RF2_3_r0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_3_r0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_rf_RF2_3_w0_load_wire : std_logic;
  signal inst_decoder_rf_RF2_3_w0_opc_wire : std_logic_vector(5 downto 0);
  signal inst_decoder_glock_wire : std_logic_vector(15 downto 0);
  signal inst_fetch_ra_out_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_ra_in_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_pc_in_wire : std_logic_vector(IMEMADDRWIDTH-1 downto 0);
  signal inst_fetch_pc_load_wire : std_logic;
  signal inst_fetch_ra_load_wire : std_logic;
  signal inst_fetch_pc_opcode_wire : std_logic_vector(0 downto 0);
  signal inst_fetch_fetch_en_wire : std_logic;
  signal inst_fetch_glock_wire : std_logic;
  signal inst_fetch_fetchblock_wire : std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
  signal rf_RF1_1_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_1_r1load_wire : std_logic;
  signal rf_RF1_1_r1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_1_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_1_t1load_wire : std_logic;
  signal rf_RF1_1_t1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_1_guard_wire : std_logic_vector(9 downto 0);
  signal rf_RF1_1_glock_wire : std_logic;
  signal rf_RF1_2_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_2_r1load_wire : std_logic;
  signal rf_RF1_2_r1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_2_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_2_t1load_wire : std_logic;
  signal rf_RF1_2_t1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_2_guard_wire : std_logic_vector(9 downto 0);
  signal rf_RF1_2_glock_wire : std_logic;
  signal rf_RF1_3_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_3_r1load_wire : std_logic;
  signal rf_RF1_3_r1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_3_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_3_t1load_wire : std_logic;
  signal rf_RF1_3_t1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_3_guard_wire : std_logic_vector(9 downto 0);
  signal rf_RF1_3_glock_wire : std_logic;
  signal rf_RF1_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_r1load_wire : std_logic;
  signal rf_RF1_r1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF1_t1load_wire : std_logic;
  signal rf_RF1_t1opcode_wire : std_logic_vector(3 downto 0);
  signal rf_RF1_guard_wire : std_logic_vector(9 downto 0);
  signal rf_RF1_glock_wire : std_logic;
  signal rf_RF2_1_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_1_r1load_wire : std_logic;
  signal rf_RF2_1_r1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_1_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_1_t1load_wire : std_logic;
  signal rf_RF2_1_t1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_1_guard_wire : std_logic_vector(32 downto 0);
  signal rf_RF2_1_glock_wire : std_logic;
  signal rf_RF2_2_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_2_r1load_wire : std_logic;
  signal rf_RF2_2_r1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_2_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_2_t1load_wire : std_logic;
  signal rf_RF2_2_t1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_2_guard_wire : std_logic_vector(32 downto 0);
  signal rf_RF2_2_glock_wire : std_logic;
  signal rf_RF2_3_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_3_r1load_wire : std_logic;
  signal rf_RF2_3_r1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_3_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_3_t1load_wire : std_logic;
  signal rf_RF2_3_t1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_3_guard_wire : std_logic_vector(32 downto 0);
  signal rf_RF2_3_glock_wire : std_logic;
  signal rf_RF2_r1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_r1load_wire : std_logic;
  signal rf_RF2_r1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_t1data_wire : std_logic_vector(31 downto 0);
  signal rf_RF2_t1load_wire : std_logic;
  signal rf_RF2_t1opcode_wire : std_logic_vector(5 downto 0);
  signal rf_RF2_guard_wire : std_logic_vector(32 downto 0);
  signal rf_RF2_glock_wire : std_logic;
  signal ground_signal : std_logic_vector(32 downto 0);

  component tta0_ifetch is
    port (
      clk : in std_logic;
      rstx : in std_logic;
      ra_out : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      ra_in : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      busy : in std_logic;
      imem_en_x : out std_logic;
      imem_addr : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      imem_data : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
      pc_in : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      pc_load : in std_logic;
      ra_load : in std_logic;
      pc_opcode : in std_logic_vector(1-1 downto 0);
      fetch_en : in std_logic;
      glock : out std_logic;
      fetchblock : out std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0));
  end component;

  component tta0_decompressor is
    port (
      fetch_en : out std_logic;
      lock : in std_logic;
      fetchblock : in std_logic_vector(IMEMWIDTHINMAUS*IMEMMAUWIDTH-1 downto 0);
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
      pc_opcode : out std_logic_vector(1-1 downto 0);
      lock : in std_logic;
      lock_r : out std_logic;
      clk : in std_logic;
      rstx : in std_logic;
      locked : out std_logic;
      simm_B1 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1 : out std_logic_vector(1-1 downto 0);
      simm_B2 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B2 : out std_logic_vector(1-1 downto 0);
      simm_B3 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B3 : out std_logic_vector(1-1 downto 0);
      simm_B1_1 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_1 : out std_logic_vector(1-1 downto 0);
      simm_B1_2 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_2 : out std_logic_vector(1-1 downto 0);
      simm_B1_3 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_3 : out std_logic_vector(1-1 downto 0);
      simm_B1_4 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_4 : out std_logic_vector(1-1 downto 0);
      simm_B1_5 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_5 : out std_logic_vector(1-1 downto 0);
      simm_B1_6 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_6 : out std_logic_vector(1-1 downto 0);
      simm_B1_7 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_7 : out std_logic_vector(1-1 downto 0);
      simm_B1_8 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_8 : out std_logic_vector(1-1 downto 0);
      simm_B1_9 : out std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_9 : out std_logic_vector(1-1 downto 0);
      socket_lsu_o1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_lsu_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_alu_comp_o1_bus_cntrl : out std_logic_vector(5-1 downto 0);
      socket_gcu_i1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_gcu_i2_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_gcu_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_FU_ALGORITHM_o1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_RF_8x32_o1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_i1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_i1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_FU_CORDIC_o1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_RF_8x32_1_o1_3_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_RF_8x32_1_o1_1_1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_1_1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_3_1_bus_cntrl : out std_logic_vector(3-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_3_1_1_bus_cntrl : out std_logic_vector(2-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl : out std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl : out std_logic_vector(1-1 downto 0);
      fu_lsu_in1t_load : out std_logic;
      fu_lsu_in2_load : out std_logic;
      fu_lsu_opc : out std_logic_vector(3-1 downto 0);
      fu_alu_in1t_load : out std_logic;
      fu_alu_in2_load : out std_logic;
      fu_alu_opc : out std_logic_vector(4-1 downto 0);
      fu_FU_ALGO_P1_load : out std_logic;
      fu_FU_ALGO_P2_load : out std_logic;
      fu_FU_ALGO_opc : out std_logic_vector(4-1 downto 0);
      fu_FU_CORDIC_P1_load : out std_logic;
      fu_FU_CORDIC_P2_load : out std_logic;
      fu_FU_ALGO_1_P1_load : out std_logic;
      fu_FU_ALGO_1_P2_load : out std_logic;
      fu_FU_ALGO_1_opc : out std_logic_vector(3-1 downto 0);
      fu_FU_ALGO_2_P1_load : out std_logic;
      fu_FU_ALGO_2_P2_load : out std_logic;
      fu_FU_ALGO_2_opc : out std_logic_vector(3-1 downto 0);
      fu_FU_ALGO_3_P1_load : out std_logic;
      fu_FU_ALGO_3_P2_load : out std_logic;
      fu_FU_ALGO_3_opc : out std_logic_vector(3-1 downto 0);
      rf_RF1_r0_load : out std_logic;
      rf_RF1_r0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF1_w0_load : out std_logic;
      rf_RF1_w0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF2_r0_load : out std_logic;
      rf_RF2_r0_opc : out std_logic_vector(6-1 downto 0);
      rf_RF2_w0_load : out std_logic;
      rf_RF2_w0_opc : out std_logic_vector(6-1 downto 0);
      rf_RF1_1_r0_load : out std_logic;
      rf_RF1_1_r0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF1_1_w0_load : out std_logic;
      rf_RF1_1_w0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF2_1_r0_load : out std_logic;
      rf_RF2_1_r0_opc : out std_logic_vector(6-1 downto 0);
      rf_RF2_1_w0_load : out std_logic;
      rf_RF2_1_w0_opc : out std_logic_vector(6-1 downto 0);
      rf_RF1_2_r0_load : out std_logic;
      rf_RF1_2_r0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF1_2_w0_load : out std_logic;
      rf_RF1_2_w0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF2_2_r0_load : out std_logic;
      rf_RF2_2_r0_opc : out std_logic_vector(6-1 downto 0);
      rf_RF2_2_w0_load : out std_logic;
      rf_RF2_2_w0_opc : out std_logic_vector(6-1 downto 0);
      rf_RF1_3_r0_load : out std_logic;
      rf_RF1_3_r0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF1_3_w0_load : out std_logic;
      rf_RF1_3_w0_opc : out std_logic_vector(4-1 downto 0);
      rf_RF2_3_r0_load : out std_logic;
      rf_RF2_3_r0_opc : out std_logic_vector(6-1 downto 0);
      rf_RF2_3_w0_load : out std_logic;
      rf_RF2_3_w0_opc : out std_logic_vector(6-1 downto 0);
      glock : out std_logic_vector(16-1 downto 0));
  end component;

  component fu_lsu_le_always_3 is
    generic (
      dataw : integer;
      addrw : integer);
    port (
      t1data : in std_logic_vector(addrw-1 downto 0);
      t1load : in std_logic;
      r1data : out std_logic_vector(dataw-1 downto 0);
      o1data : in std_logic_vector(dataw-1 downto 0);
      o1load : in std_logic;
      t1opcode : in std_logic_vector(3-1 downto 0);
      mem_en_x : out std_logic_vector(1-1 downto 0);
      wr_en_x : out std_logic_vector(1-1 downto 0);
      wr_mask_x : out std_logic_vector(dataw-1 downto 0);
      addr : out std_logic_vector(addrw-2-1 downto 0);
      data_in : in std_logic_vector(dataw-1 downto 0);
      data_out : out std_logic_vector(dataw-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component extended_alu is
    generic (
      dataw : integer);
    port (
      data_in1t_in : in std_logic_vector(dataw-1 downto 0);
      load_in1t_in : in std_logic;
      data_in2_in : in std_logic_vector(dataw-1 downto 0);
      load_in2_in : in std_logic;
      data_out1_out : out std_logic_vector(dataw-1 downto 0);
      operation_in : in std_logic_vector(4-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock_in : in std_logic);
  end component;

  component fu_algo is
    generic (
      dataw : integer;
      DW_A : integer;
      DW_FRACTION : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t2data : in std_logic_vector(dataw-1 downto 0);
      t2load : in std_logic;
      r1data : out std_logic_vector(dataw-1 downto 0);
      t1opcode : in std_logic_vector(4-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component fu_cordic is
    generic (
      dataw : integer;
      NUM_ITERATIONS : integer;
      DW_ANGLE : integer;
      DW_FRACTION : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t2data : in std_logic_vector(dataw-1 downto 0);
      t2load : in std_logic;
      r1data : out std_logic_vector(dataw-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component fu_algo_frac is
    generic (
      dataw : integer;
      DW_A : integer;
      DW_FRACTION : integer);
    port (
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t2data : in std_logic_vector(dataw-1 downto 0);
      t2load : in std_logic;
      r1data : out std_logic_vector(dataw-1 downto 0);
      t1opcode : in std_logic_vector(3-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component rf_1wr_1rd_always_1_guarded_1 is
    generic (
      dataw : integer;
      rf_size : integer);
    port (
      r1data : out std_logic_vector(dataw-1 downto 0);
      r1load : in std_logic;
      r1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      t1data : in std_logic_vector(dataw-1 downto 0);
      t1load : in std_logic;
      t1opcode : in std_logic_vector(bit_width(rf_size)-1 downto 0);
      guard : out std_logic_vector(rf_size-1 downto 0);
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic);
  end component;

  component tta0_interconn is
    port (
      clk : in std_logic;
      rstx : in std_logic;
      glock : in std_logic;
      socket_lsu_i1_data : out std_logic_vector(8-1 downto 0);
      socket_lsu_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_lsu_o1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_lsu_i2_data : out std_logic_vector(32-1 downto 0);
      socket_lsu_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_alu_comp_i1_data : out std_logic_vector(32-1 downto 0);
      socket_alu_comp_i2_data : out std_logic_vector(32-1 downto 0);
      socket_alu_comp_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_alu_comp_o1_bus_cntrl : in std_logic_vector(5-1 downto 0);
      socket_gcu_i1_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_gcu_i1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_gcu_i2_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_gcu_i2_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_gcu_o1_data0 : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
      socket_gcu_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_FU_ALGORITHM_i1_data : out std_logic_vector(32-1 downto 0);
      socket_FU_ALGORITHM_i2_data : out std_logic_vector(32-1 downto 0);
      socket_FU_ALGORITHM_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_FU_ALGORITHM_o1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_RF_8x32_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_o1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_i1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_i1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_i1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_FU_CORDIC_i1_data : out std_logic_vector(32-1 downto 0);
      socket_FU_CORDIC_i2_data : out std_logic_vector(32-1 downto 0);
      socket_FU_CORDIC_o1_data0 : in std_logic_vector(32-1 downto 0);
      socket_FU_CORDIC_o1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_RF_8x32_1_o1_1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_2_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_3_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_3_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_RF_8x32_1_o1_1_1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_2_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_1_1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_1_1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_1_2_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_2_1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_3_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_3_1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_3_1_bus_cntrl : in std_logic_vector(3-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_1_3_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_1_3_1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_2_1_1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_3_1_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_3_1_1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_3_1_1_bus_cntrl : in std_logic_vector(2-1 downto 0);
      socket_RF_8x32_1_o1_1_1_3_2_data : out std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_2_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_1_1_data0 : in std_logic_vector(32-1 downto 0);
      socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl : in std_logic_vector(1-1 downto 0);
      socket_RF_8x32_1_o1_1_1_3_1_1_data : out std_logic_vector(32-1 downto 0);
      simm_B1 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1 : in std_logic_vector(1-1 downto 0);
      simm_B2 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B2 : in std_logic_vector(1-1 downto 0);
      simm_B3 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B3 : in std_logic_vector(1-1 downto 0);
      simm_B1_1 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_1 : in std_logic_vector(1-1 downto 0);
      simm_B1_2 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_2 : in std_logic_vector(1-1 downto 0);
      simm_B1_3 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_3 : in std_logic_vector(1-1 downto 0);
      simm_B1_4 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_4 : in std_logic_vector(1-1 downto 0);
      simm_B1_5 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_5 : in std_logic_vector(1-1 downto 0);
      simm_B1_6 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_6 : in std_logic_vector(1-1 downto 0);
      simm_B1_7 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_7 : in std_logic_vector(1-1 downto 0);
      simm_B1_8 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_8 : in std_logic_vector(1-1 downto 0);
      simm_B1_9 : in std_logic_vector(32-1 downto 0);
      simm_cntrl_B1_9 : in std_logic_vector(1-1 downto 0));
  end component;


begin

  ic_socket_gcu_o1_data0_wire <= inst_fetch_ra_out_wire;
  inst_fetch_ra_in_wire <= ic_socket_gcu_i2_data_wire;
  inst_fetch_pc_in_wire <= ic_socket_gcu_i1_data_wire;
  inst_fetch_pc_load_wire <= inst_decoder_pc_load_wire;
  inst_fetch_ra_load_wire <= inst_decoder_ra_load_wire;
  inst_fetch_pc_opcode_wire <= inst_decoder_pc_opcode_wire;
  inst_fetch_fetch_en_wire <= decomp_fetch_en_wire;
  decomp_lock_wire <= inst_fetch_glock_wire;
  decomp_fetchblock_wire <= inst_fetch_fetchblock_wire;
  inst_decoder_instructionword_wire <= decomp_instructionword_wire;
  inst_decoder_lock_wire <= decomp_glock_wire;
  decomp_lock_r_wire <= inst_decoder_lock_r_wire;
  ic_simm_B1_wire <= inst_decoder_simm_B1_wire;
  ic_simm_cntrl_B1_wire <= inst_decoder_simm_cntrl_B1_wire;
  ic_simm_B2_wire <= inst_decoder_simm_B2_wire;
  ic_simm_cntrl_B2_wire <= inst_decoder_simm_cntrl_B2_wire;
  ic_simm_B3_wire <= inst_decoder_simm_B3_wire;
  ic_simm_cntrl_B3_wire <= inst_decoder_simm_cntrl_B3_wire;
  ic_simm_B1_1_wire <= inst_decoder_simm_B1_1_wire;
  ic_simm_cntrl_B1_1_wire <= inst_decoder_simm_cntrl_B1_1_wire;
  ic_simm_B1_2_wire <= inst_decoder_simm_B1_2_wire;
  ic_simm_cntrl_B1_2_wire <= inst_decoder_simm_cntrl_B1_2_wire;
  ic_simm_B1_3_wire <= inst_decoder_simm_B1_3_wire;
  ic_simm_cntrl_B1_3_wire <= inst_decoder_simm_cntrl_B1_3_wire;
  ic_simm_B1_4_wire <= inst_decoder_simm_B1_4_wire;
  ic_simm_cntrl_B1_4_wire <= inst_decoder_simm_cntrl_B1_4_wire;
  ic_simm_B1_5_wire <= inst_decoder_simm_B1_5_wire;
  ic_simm_cntrl_B1_5_wire <= inst_decoder_simm_cntrl_B1_5_wire;
  ic_simm_B1_6_wire <= inst_decoder_simm_B1_6_wire;
  ic_simm_cntrl_B1_6_wire <= inst_decoder_simm_cntrl_B1_6_wire;
  ic_simm_B1_7_wire <= inst_decoder_simm_B1_7_wire;
  ic_simm_cntrl_B1_7_wire <= inst_decoder_simm_cntrl_B1_7_wire;
  ic_simm_B1_8_wire <= inst_decoder_simm_B1_8_wire;
  ic_simm_cntrl_B1_8_wire <= inst_decoder_simm_cntrl_B1_8_wire;
  ic_simm_B1_9_wire <= inst_decoder_simm_B1_9_wire;
  ic_simm_cntrl_B1_9_wire <= inst_decoder_simm_cntrl_B1_9_wire;
  ic_socket_lsu_o1_bus_cntrl_wire <= inst_decoder_socket_lsu_o1_bus_cntrl_wire;
  ic_socket_lsu_i2_bus_cntrl_wire <= inst_decoder_socket_lsu_i2_bus_cntrl_wire;
  ic_socket_alu_comp_o1_bus_cntrl_wire <= inst_decoder_socket_alu_comp_o1_bus_cntrl_wire;
  ic_socket_gcu_i1_bus_cntrl_wire <= inst_decoder_socket_gcu_i1_bus_cntrl_wire;
  ic_socket_gcu_i2_bus_cntrl_wire <= inst_decoder_socket_gcu_i2_bus_cntrl_wire;
  ic_socket_gcu_o1_bus_cntrl_wire <= inst_decoder_socket_gcu_o1_bus_cntrl_wire;
  ic_socket_FU_ALGORITHM_o1_bus_cntrl_wire <= inst_decoder_socket_FU_ALGORITHM_o1_bus_cntrl_wire;
  ic_socket_RF_8x32_o1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_o1_bus_cntrl_wire;
  ic_socket_RF_8x32_i1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_i1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_i1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_i1_bus_cntrl_wire;
  ic_socket_FU_CORDIC_o1_bus_cntrl_wire <= inst_decoder_socket_FU_CORDIC_o1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_3_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_3_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_1_1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_1_1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_1_1_1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_1_1_1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_3_1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_3_1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_1_2_1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_1_2_1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_3_1_1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_3_1_1_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_wire;
  ic_socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_wire <= inst_decoder_socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_wire;
  fu_lsu_t1load_wire <= inst_decoder_fu_lsu_in1t_load_wire;
  fu_lsu_o1load_wire <= inst_decoder_fu_lsu_in2_load_wire;
  fu_lsu_t1opcode_wire <= inst_decoder_fu_lsu_opc_wire;
  fu_alu_load_in1t_in_wire <= inst_decoder_fu_alu_in1t_load_wire;
  fu_alu_load_in2_in_wire <= inst_decoder_fu_alu_in2_load_wire;
  fu_alu_operation_in_wire <= inst_decoder_fu_alu_opc_wire;
  fu_FU_ALGO_t1load_wire <= inst_decoder_fu_FU_ALGO_P1_load_wire;
  fu_FU_ALGO_t2load_wire <= inst_decoder_fu_FU_ALGO_P2_load_wire;
  fu_FU_ALGO_t1opcode_wire <= inst_decoder_fu_FU_ALGO_opc_wire;
  fu_FU_CORDIC_t1load_wire <= inst_decoder_fu_FU_CORDIC_P1_load_wire;
  fu_FU_CORDIC_t2load_wire <= inst_decoder_fu_FU_CORDIC_P2_load_wire;
  fu_FU_ALGO_1_t1load_wire <= inst_decoder_fu_FU_ALGO_1_P1_load_wire;
  fu_FU_ALGO_1_t2load_wire <= inst_decoder_fu_FU_ALGO_1_P2_load_wire;
  fu_FU_ALGO_1_t1opcode_wire <= inst_decoder_fu_FU_ALGO_1_opc_wire;
  fu_FU_ALGO_2_t1load_wire <= inst_decoder_fu_FU_ALGO_2_P1_load_wire;
  fu_FU_ALGO_2_t2load_wire <= inst_decoder_fu_FU_ALGO_2_P2_load_wire;
  fu_FU_ALGO_2_t1opcode_wire <= inst_decoder_fu_FU_ALGO_2_opc_wire;
  fu_FU_ALGO_3_t1load_wire <= inst_decoder_fu_FU_ALGO_3_P1_load_wire;
  fu_FU_ALGO_3_t2load_wire <= inst_decoder_fu_FU_ALGO_3_P2_load_wire;
  fu_FU_ALGO_3_t1opcode_wire <= inst_decoder_fu_FU_ALGO_3_opc_wire;
  rf_RF1_r1load_wire <= inst_decoder_rf_RF1_r0_load_wire;
  rf_RF1_r1opcode_wire <= inst_decoder_rf_RF1_r0_opc_wire;
  rf_RF1_t1load_wire <= inst_decoder_rf_RF1_w0_load_wire;
  rf_RF1_t1opcode_wire <= inst_decoder_rf_RF1_w0_opc_wire;
  rf_RF2_r1load_wire <= inst_decoder_rf_RF2_r0_load_wire;
  rf_RF2_r1opcode_wire <= inst_decoder_rf_RF2_r0_opc_wire;
  rf_RF2_t1load_wire <= inst_decoder_rf_RF2_w0_load_wire;
  rf_RF2_t1opcode_wire <= inst_decoder_rf_RF2_w0_opc_wire;
  rf_RF1_1_r1load_wire <= inst_decoder_rf_RF1_1_r0_load_wire;
  rf_RF1_1_r1opcode_wire <= inst_decoder_rf_RF1_1_r0_opc_wire;
  rf_RF1_1_t1load_wire <= inst_decoder_rf_RF1_1_w0_load_wire;
  rf_RF1_1_t1opcode_wire <= inst_decoder_rf_RF1_1_w0_opc_wire;
  rf_RF2_1_r1load_wire <= inst_decoder_rf_RF2_1_r0_load_wire;
  rf_RF2_1_r1opcode_wire <= inst_decoder_rf_RF2_1_r0_opc_wire;
  rf_RF2_1_t1load_wire <= inst_decoder_rf_RF2_1_w0_load_wire;
  rf_RF2_1_t1opcode_wire <= inst_decoder_rf_RF2_1_w0_opc_wire;
  rf_RF1_2_r1load_wire <= inst_decoder_rf_RF1_2_r0_load_wire;
  rf_RF1_2_r1opcode_wire <= inst_decoder_rf_RF1_2_r0_opc_wire;
  rf_RF1_2_t1load_wire <= inst_decoder_rf_RF1_2_w0_load_wire;
  rf_RF1_2_t1opcode_wire <= inst_decoder_rf_RF1_2_w0_opc_wire;
  rf_RF2_2_r1load_wire <= inst_decoder_rf_RF2_2_r0_load_wire;
  rf_RF2_2_r1opcode_wire <= inst_decoder_rf_RF2_2_r0_opc_wire;
  rf_RF2_2_t1load_wire <= inst_decoder_rf_RF2_2_w0_load_wire;
  rf_RF2_2_t1opcode_wire <= inst_decoder_rf_RF2_2_w0_opc_wire;
  rf_RF1_3_t1load_wire <= inst_decoder_rf_RF1_3_r0_load_wire;
  rf_RF1_3_t1opcode_wire <= inst_decoder_rf_RF1_3_r0_opc_wire;
  rf_RF1_3_r1load_wire <= inst_decoder_rf_RF1_3_w0_load_wire;
  rf_RF1_3_r1opcode_wire <= inst_decoder_rf_RF1_3_w0_opc_wire;
  rf_RF2_3_r1load_wire <= inst_decoder_rf_RF2_3_r0_load_wire;
  rf_RF2_3_r1opcode_wire <= inst_decoder_rf_RF2_3_r0_opc_wire;
  rf_RF2_3_t1load_wire <= inst_decoder_rf_RF2_3_w0_load_wire;
  rf_RF2_3_t1opcode_wire <= inst_decoder_rf_RF2_3_w0_opc_wire;
  fu_lsu_glock_wire <= inst_decoder_glock_wire(0);
  fu_alu_glock_in_wire <= inst_decoder_glock_wire(1);
  fu_FU_ALGO_glock_wire <= inst_decoder_glock_wire(2);
  fu_FU_CORDIC_glock_wire <= inst_decoder_glock_wire(3);
  fu_FU_ALGO_1_glock_wire <= inst_decoder_glock_wire(4);
  fu_FU_ALGO_2_glock_wire <= inst_decoder_glock_wire(5);
  fu_FU_ALGO_3_glock_wire <= inst_decoder_glock_wire(6);
  rf_RF1_glock_wire <= inst_decoder_glock_wire(7);
  rf_RF2_glock_wire <= inst_decoder_glock_wire(8);
  rf_RF1_1_glock_wire <= inst_decoder_glock_wire(9);
  rf_RF2_1_glock_wire <= inst_decoder_glock_wire(10);
  rf_RF1_2_glock_wire <= inst_decoder_glock_wire(11);
  rf_RF2_2_glock_wire <= inst_decoder_glock_wire(12);
  rf_RF1_3_glock_wire <= inst_decoder_glock_wire(13);
  rf_RF2_3_glock_wire <= inst_decoder_glock_wire(14);
  ic_glock_wire <= inst_decoder_glock_wire(15);
  fu_lsu_t1data_wire <= ic_socket_lsu_i1_data_wire;
  ic_socket_lsu_o1_data0_wire <= fu_lsu_r1data_wire;
  fu_lsu_o1data_wire <= ic_socket_lsu_i2_data_wire;
  fu_alu_data_in1t_in_wire <= ic_socket_alu_comp_i1_data_wire;
  fu_alu_data_in2_in_wire <= ic_socket_alu_comp_i2_data_wire;
  ic_socket_alu_comp_o1_data0_wire <= fu_alu_data_out1_out_wire;
  fu_FU_ALGO_t1data_wire <= ic_socket_FU_ALGORITHM_i1_data_wire;
  fu_FU_ALGO_t2data_wire <= ic_socket_FU_ALGORITHM_i2_data_wire;
  ic_socket_FU_ALGORITHM_o1_data0_wire <= fu_FU_ALGO_r1data_wire;
  fu_FU_CORDIC_t1data_wire <= ic_socket_FU_CORDIC_i1_data_wire;
  fu_FU_CORDIC_t2data_wire <= ic_socket_FU_CORDIC_i2_data_wire;
  ic_socket_FU_CORDIC_o1_data0_wire <= fu_FU_CORDIC_r1data_wire;
  fu_FU_ALGO_1_t1data_wire <= ic_socket_RF_8x32_1_o1_1_data_wire;
  fu_FU_ALGO_1_t2data_wire <= ic_socket_RF_8x32_1_o1_2_data_wire;
  ic_socket_RF_8x32_1_o1_3_data0_wire <= fu_FU_ALGO_1_r1data_wire;
  fu_FU_ALGO_2_t1data_wire <= ic_socket_RF_8x32_1_o1_1_3_data_wire;
  fu_FU_ALGO_2_t2data_wire <= ic_socket_RF_8x32_1_o1_2_1_data_wire;
  ic_socket_RF_8x32_1_o1_3_1_data0_wire <= fu_FU_ALGO_2_r1data_wire;
  fu_FU_ALGO_3_t1data_wire <= ic_socket_RF_8x32_1_o1_1_3_1_data_wire;
  fu_FU_ALGO_3_t2data_wire <= ic_socket_RF_8x32_1_o1_2_1_1_data_wire;
  ic_socket_RF_8x32_1_o1_3_1_1_data0_wire <= fu_FU_ALGO_3_r1data_wire;
  ic_socket_RF_8x32_o1_data0_wire <= rf_RF1_r1data_wire;
  rf_RF1_t1data_wire <= ic_socket_RF_8x32_i1_data_wire;
  ic_socket_RF_8x32_1_o1_data0_wire <= rf_RF2_r1data_wire;
  rf_RF2_t1data_wire <= ic_socket_RF_8x32_1_i1_data_wire;
  ic_socket_RF_8x32_1_o1_1_1_data0_wire <= rf_RF1_1_r1data_wire;
  rf_RF1_1_t1data_wire <= ic_socket_RF_8x32_1_o1_1_2_data_wire;
  ic_socket_RF_8x32_1_o1_1_1_1_data0_wire <= rf_RF2_1_r1data_wire;
  rf_RF2_1_t1data_wire <= ic_socket_RF_8x32_1_o1_1_1_2_data_wire;
  ic_socket_RF_8x32_1_o1_1_2_1_data0_wire <= rf_RF1_2_r1data_wire;
  rf_RF1_2_t1data_wire <= ic_socket_RF_8x32_1_o1_1_1_3_data_wire;
  ic_socket_RF_8x32_1_o1_1_1_3_1_data0_wire <= rf_RF2_2_r1data_wire;
  rf_RF2_2_t1data_wire <= ic_socket_RF_8x32_1_o1_1_2_1_1_data_wire;
  ic_socket_RF_8x32_1_o1_1_2_1_2_data0_wire <= rf_RF1_3_r1data_wire;
  rf_RF1_3_t1data_wire <= ic_socket_RF_8x32_1_o1_1_1_3_2_data_wire;
  ic_socket_RF_8x32_1_o1_1_2_1_1_1_data0_wire <= rf_RF2_3_r1data_wire;
  rf_RF2_3_t1data_wire <= ic_socket_RF_8x32_1_o1_1_1_3_1_1_data_wire;
  ground_signal <= (others => '0');

  inst_fetch : tta0_ifetch
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
      fetchblock => inst_fetch_fetchblock_wire);

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
      simm_B1 => inst_decoder_simm_B1_wire,
      simm_cntrl_B1 => inst_decoder_simm_cntrl_B1_wire,
      simm_B2 => inst_decoder_simm_B2_wire,
      simm_cntrl_B2 => inst_decoder_simm_cntrl_B2_wire,
      simm_B3 => inst_decoder_simm_B3_wire,
      simm_cntrl_B3 => inst_decoder_simm_cntrl_B3_wire,
      simm_B1_1 => inst_decoder_simm_B1_1_wire,
      simm_cntrl_B1_1 => inst_decoder_simm_cntrl_B1_1_wire,
      simm_B1_2 => inst_decoder_simm_B1_2_wire,
      simm_cntrl_B1_2 => inst_decoder_simm_cntrl_B1_2_wire,
      simm_B1_3 => inst_decoder_simm_B1_3_wire,
      simm_cntrl_B1_3 => inst_decoder_simm_cntrl_B1_3_wire,
      simm_B1_4 => inst_decoder_simm_B1_4_wire,
      simm_cntrl_B1_4 => inst_decoder_simm_cntrl_B1_4_wire,
      simm_B1_5 => inst_decoder_simm_B1_5_wire,
      simm_cntrl_B1_5 => inst_decoder_simm_cntrl_B1_5_wire,
      simm_B1_6 => inst_decoder_simm_B1_6_wire,
      simm_cntrl_B1_6 => inst_decoder_simm_cntrl_B1_6_wire,
      simm_B1_7 => inst_decoder_simm_B1_7_wire,
      simm_cntrl_B1_7 => inst_decoder_simm_cntrl_B1_7_wire,
      simm_B1_8 => inst_decoder_simm_B1_8_wire,
      simm_cntrl_B1_8 => inst_decoder_simm_cntrl_B1_8_wire,
      simm_B1_9 => inst_decoder_simm_B1_9_wire,
      simm_cntrl_B1_9 => inst_decoder_simm_cntrl_B1_9_wire,
      socket_lsu_o1_bus_cntrl => inst_decoder_socket_lsu_o1_bus_cntrl_wire,
      socket_lsu_i2_bus_cntrl => inst_decoder_socket_lsu_i2_bus_cntrl_wire,
      socket_alu_comp_o1_bus_cntrl => inst_decoder_socket_alu_comp_o1_bus_cntrl_wire,
      socket_gcu_i1_bus_cntrl => inst_decoder_socket_gcu_i1_bus_cntrl_wire,
      socket_gcu_i2_bus_cntrl => inst_decoder_socket_gcu_i2_bus_cntrl_wire,
      socket_gcu_o1_bus_cntrl => inst_decoder_socket_gcu_o1_bus_cntrl_wire,
      socket_FU_ALGORITHM_o1_bus_cntrl => inst_decoder_socket_FU_ALGORITHM_o1_bus_cntrl_wire,
      socket_RF_8x32_o1_bus_cntrl => inst_decoder_socket_RF_8x32_o1_bus_cntrl_wire,
      socket_RF_8x32_i1_bus_cntrl => inst_decoder_socket_RF_8x32_i1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_bus_cntrl_wire,
      socket_RF_8x32_1_i1_bus_cntrl => inst_decoder_socket_RF_8x32_1_i1_bus_cntrl_wire,
      socket_FU_CORDIC_o1_bus_cntrl => inst_decoder_socket_FU_CORDIC_o1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_3_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_3_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_1_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_1_1_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_3_1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_3_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_2_1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_1_2_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_3_1_1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_3_1_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl => inst_decoder_socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_wire,
      fu_lsu_in1t_load => inst_decoder_fu_lsu_in1t_load_wire,
      fu_lsu_in2_load => inst_decoder_fu_lsu_in2_load_wire,
      fu_lsu_opc => inst_decoder_fu_lsu_opc_wire,
      fu_alu_in1t_load => inst_decoder_fu_alu_in1t_load_wire,
      fu_alu_in2_load => inst_decoder_fu_alu_in2_load_wire,
      fu_alu_opc => inst_decoder_fu_alu_opc_wire,
      fu_FU_ALGO_P1_load => inst_decoder_fu_FU_ALGO_P1_load_wire,
      fu_FU_ALGO_P2_load => inst_decoder_fu_FU_ALGO_P2_load_wire,
      fu_FU_ALGO_opc => inst_decoder_fu_FU_ALGO_opc_wire,
      fu_FU_CORDIC_P1_load => inst_decoder_fu_FU_CORDIC_P1_load_wire,
      fu_FU_CORDIC_P2_load => inst_decoder_fu_FU_CORDIC_P2_load_wire,
      fu_FU_ALGO_1_P1_load => inst_decoder_fu_FU_ALGO_1_P1_load_wire,
      fu_FU_ALGO_1_P2_load => inst_decoder_fu_FU_ALGO_1_P2_load_wire,
      fu_FU_ALGO_1_opc => inst_decoder_fu_FU_ALGO_1_opc_wire,
      fu_FU_ALGO_2_P1_load => inst_decoder_fu_FU_ALGO_2_P1_load_wire,
      fu_FU_ALGO_2_P2_load => inst_decoder_fu_FU_ALGO_2_P2_load_wire,
      fu_FU_ALGO_2_opc => inst_decoder_fu_FU_ALGO_2_opc_wire,
      fu_FU_ALGO_3_P1_load => inst_decoder_fu_FU_ALGO_3_P1_load_wire,
      fu_FU_ALGO_3_P2_load => inst_decoder_fu_FU_ALGO_3_P2_load_wire,
      fu_FU_ALGO_3_opc => inst_decoder_fu_FU_ALGO_3_opc_wire,
      rf_RF1_r0_load => inst_decoder_rf_RF1_r0_load_wire,
      rf_RF1_r0_opc => inst_decoder_rf_RF1_r0_opc_wire,
      rf_RF1_w0_load => inst_decoder_rf_RF1_w0_load_wire,
      rf_RF1_w0_opc => inst_decoder_rf_RF1_w0_opc_wire,
      rf_RF2_r0_load => inst_decoder_rf_RF2_r0_load_wire,
      rf_RF2_r0_opc => inst_decoder_rf_RF2_r0_opc_wire,
      rf_RF2_w0_load => inst_decoder_rf_RF2_w0_load_wire,
      rf_RF2_w0_opc => inst_decoder_rf_RF2_w0_opc_wire,
      rf_RF1_1_r0_load => inst_decoder_rf_RF1_1_r0_load_wire,
      rf_RF1_1_r0_opc => inst_decoder_rf_RF1_1_r0_opc_wire,
      rf_RF1_1_w0_load => inst_decoder_rf_RF1_1_w0_load_wire,
      rf_RF1_1_w0_opc => inst_decoder_rf_RF1_1_w0_opc_wire,
      rf_RF2_1_r0_load => inst_decoder_rf_RF2_1_r0_load_wire,
      rf_RF2_1_r0_opc => inst_decoder_rf_RF2_1_r0_opc_wire,
      rf_RF2_1_w0_load => inst_decoder_rf_RF2_1_w0_load_wire,
      rf_RF2_1_w0_opc => inst_decoder_rf_RF2_1_w0_opc_wire,
      rf_RF1_2_r0_load => inst_decoder_rf_RF1_2_r0_load_wire,
      rf_RF1_2_r0_opc => inst_decoder_rf_RF1_2_r0_opc_wire,
      rf_RF1_2_w0_load => inst_decoder_rf_RF1_2_w0_load_wire,
      rf_RF1_2_w0_opc => inst_decoder_rf_RF1_2_w0_opc_wire,
      rf_RF2_2_r0_load => inst_decoder_rf_RF2_2_r0_load_wire,
      rf_RF2_2_r0_opc => inst_decoder_rf_RF2_2_r0_opc_wire,
      rf_RF2_2_w0_load => inst_decoder_rf_RF2_2_w0_load_wire,
      rf_RF2_2_w0_opc => inst_decoder_rf_RF2_2_w0_opc_wire,
      rf_RF1_3_r0_load => inst_decoder_rf_RF1_3_r0_load_wire,
      rf_RF1_3_r0_opc => inst_decoder_rf_RF1_3_r0_opc_wire,
      rf_RF1_3_w0_load => inst_decoder_rf_RF1_3_w0_load_wire,
      rf_RF1_3_w0_opc => inst_decoder_rf_RF1_3_w0_opc_wire,
      rf_RF2_3_r0_load => inst_decoder_rf_RF2_3_r0_load_wire,
      rf_RF2_3_r0_opc => inst_decoder_rf_RF2_3_r0_opc_wire,
      rf_RF2_3_w0_load => inst_decoder_rf_RF2_3_w0_load_wire,
      rf_RF2_3_w0_opc => inst_decoder_rf_RF2_3_w0_opc_wire,
      glock => inst_decoder_glock_wire);

  fu_lsu : fu_lsu_le_always_3
    generic map (
      dataw => fu_lsu_dataw,
      addrw => fu_lsu_addrw)
    port map (
      t1data => fu_lsu_t1data_wire,
      t1load => fu_lsu_t1load_wire,
      r1data => fu_lsu_r1data_wire,
      o1data => fu_lsu_o1data_wire,
      o1load => fu_lsu_o1load_wire,
      t1opcode => fu_lsu_t1opcode_wire,
      mem_en_x => fu_lsu_mem_en_x,
      wr_en_x => fu_lsu_wr_en_x,
      wr_mask_x => fu_lsu_wr_mask_x,
      addr => fu_lsu_addr,
      data_in => fu_lsu_data_in,
      data_out => fu_lsu_data_out,
      clk => clk,
      rstx => rstx,
      glock => fu_lsu_glock_wire);

  fu_alu : extended_alu
    generic map (
      dataw => 32)
    port map (
      data_in1t_in => fu_alu_data_in1t_in_wire,
      load_in1t_in => fu_alu_load_in1t_in_wire,
      data_in2_in => fu_alu_data_in2_in_wire,
      load_in2_in => fu_alu_load_in2_in_wire,
      data_out1_out => fu_alu_data_out1_out_wire,
      operation_in => fu_alu_operation_in_wire,
      clk => clk,
      rstx => rstx,
      glock_in => fu_alu_glock_in_wire);

  fu_FU_ALGO : fu_algo
    generic map (
      dataw => 32,
      DW_A => 8,
      DW_FRACTION => 4)
    port map (
      t1data => fu_FU_ALGO_t1data_wire,
      t1load => fu_FU_ALGO_t1load_wire,
      t2data => fu_FU_ALGO_t2data_wire,
      t2load => fu_FU_ALGO_t2load_wire,
      r1data => fu_FU_ALGO_r1data_wire,
      t1opcode => fu_FU_ALGO_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_FU_ALGO_glock_wire);

  fu_FU_CORDIC : fu_cordic
    generic map (
      dataw => 32,
      NUM_ITERATIONS => 11,
      DW_ANGLE => 8,
      DW_FRACTION => 6)
    port map (
      t1data => fu_FU_CORDIC_t1data_wire,
      t1load => fu_FU_CORDIC_t1load_wire,
      t2data => fu_FU_CORDIC_t2data_wire,
      t2load => fu_FU_CORDIC_t2load_wire,
      r1data => fu_FU_CORDIC_r1data_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_FU_CORDIC_glock_wire);

  fu_FU_ALGO_1 : fu_algo_frac
    generic map (
      dataw => 32,
      DW_A => 8,
      DW_FRACTION => 4)
    port map (
      t1data => fu_FU_ALGO_1_t1data_wire,
      t1load => fu_FU_ALGO_1_t1load_wire,
      t2data => fu_FU_ALGO_1_t2data_wire,
      t2load => fu_FU_ALGO_1_t2load_wire,
      r1data => fu_FU_ALGO_1_r1data_wire,
      t1opcode => fu_FU_ALGO_1_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_FU_ALGO_1_glock_wire);

  fu_FU_ALGO_2 : fu_algo_frac
    generic map (
      dataw => 32,
      DW_A => 8,
      DW_FRACTION => 4)
    port map (
      t1data => fu_FU_ALGO_2_t1data_wire,
      t1load => fu_FU_ALGO_2_t1load_wire,
      t2data => fu_FU_ALGO_2_t2data_wire,
      t2load => fu_FU_ALGO_2_t2load_wire,
      r1data => fu_FU_ALGO_2_r1data_wire,
      t1opcode => fu_FU_ALGO_2_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_FU_ALGO_2_glock_wire);

  fu_FU_ALGO_3 : fu_algo_frac
    generic map (
      dataw => 32,
      DW_A => 8,
      DW_FRACTION => 4)
    port map (
      t1data => fu_FU_ALGO_3_t1data_wire,
      t1load => fu_FU_ALGO_3_t1load_wire,
      t2data => fu_FU_ALGO_3_t2data_wire,
      t2load => fu_FU_ALGO_3_t2load_wire,
      r1data => fu_FU_ALGO_3_r1data_wire,
      t1opcode => fu_FU_ALGO_3_t1opcode_wire,
      clk => clk,
      rstx => rstx,
      glock => fu_FU_ALGO_3_glock_wire);

  rf_RF1 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 10)
    port map (
      r1data => rf_RF1_r1data_wire,
      r1load => rf_RF1_r1load_wire,
      r1opcode => rf_RF1_r1opcode_wire,
      t1data => rf_RF1_t1data_wire,
      t1load => rf_RF1_t1load_wire,
      t1opcode => rf_RF1_t1opcode_wire,
      guard => rf_RF1_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF1_glock_wire);

  rf_RF2 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 33)
    port map (
      r1data => rf_RF2_r1data_wire,
      r1load => rf_RF2_r1load_wire,
      r1opcode => rf_RF2_r1opcode_wire,
      t1data => rf_RF2_t1data_wire,
      t1load => rf_RF2_t1load_wire,
      t1opcode => rf_RF2_t1opcode_wire,
      guard => rf_RF2_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF2_glock_wire);

  rf_RF1_1 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 10)
    port map (
      r1data => rf_RF1_1_r1data_wire,
      r1load => rf_RF1_1_r1load_wire,
      r1opcode => rf_RF1_1_r1opcode_wire,
      t1data => rf_RF1_1_t1data_wire,
      t1load => rf_RF1_1_t1load_wire,
      t1opcode => rf_RF1_1_t1opcode_wire,
      guard => rf_RF1_1_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF1_1_glock_wire);

  rf_RF2_1 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 33)
    port map (
      r1data => rf_RF2_1_r1data_wire,
      r1load => rf_RF2_1_r1load_wire,
      r1opcode => rf_RF2_1_r1opcode_wire,
      t1data => rf_RF2_1_t1data_wire,
      t1load => rf_RF2_1_t1load_wire,
      t1opcode => rf_RF2_1_t1opcode_wire,
      guard => rf_RF2_1_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF2_1_glock_wire);

  rf_RF1_2 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 10)
    port map (
      r1data => rf_RF1_2_r1data_wire,
      r1load => rf_RF1_2_r1load_wire,
      r1opcode => rf_RF1_2_r1opcode_wire,
      t1data => rf_RF1_2_t1data_wire,
      t1load => rf_RF1_2_t1load_wire,
      t1opcode => rf_RF1_2_t1opcode_wire,
      guard => rf_RF1_2_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF1_2_glock_wire);

  rf_RF2_2 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 33)
    port map (
      r1data => rf_RF2_2_r1data_wire,
      r1load => rf_RF2_2_r1load_wire,
      r1opcode => rf_RF2_2_r1opcode_wire,
      t1data => rf_RF2_2_t1data_wire,
      t1load => rf_RF2_2_t1load_wire,
      t1opcode => rf_RF2_2_t1opcode_wire,
      guard => rf_RF2_2_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF2_2_glock_wire);

  rf_RF1_3 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 10)
    port map (
      r1data => rf_RF1_3_r1data_wire,
      r1load => rf_RF1_3_r1load_wire,
      r1opcode => rf_RF1_3_r1opcode_wire,
      t1data => rf_RF1_3_t1data_wire,
      t1load => rf_RF1_3_t1load_wire,
      t1opcode => rf_RF1_3_t1opcode_wire,
      guard => rf_RF1_3_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF1_3_glock_wire);

  rf_RF2_3 : rf_1wr_1rd_always_1_guarded_1
    generic map (
      dataw => 32,
      rf_size => 33)
    port map (
      r1data => rf_RF2_3_r1data_wire,
      r1load => rf_RF2_3_r1load_wire,
      r1opcode => rf_RF2_3_r1opcode_wire,
      t1data => rf_RF2_3_t1data_wire,
      t1load => rf_RF2_3_t1load_wire,
      t1opcode => rf_RF2_3_t1opcode_wire,
      guard => rf_RF2_3_guard_wire,
      clk => clk,
      rstx => rstx,
      glock => rf_RF2_3_glock_wire);

  ic : tta0_interconn
    port map (
      clk => clk,
      rstx => rstx,
      glock => ic_glock_wire,
      socket_lsu_i1_data => ic_socket_lsu_i1_data_wire,
      socket_lsu_o1_data0 => ic_socket_lsu_o1_data0_wire,
      socket_lsu_o1_bus_cntrl => ic_socket_lsu_o1_bus_cntrl_wire,
      socket_lsu_i2_data => ic_socket_lsu_i2_data_wire,
      socket_lsu_i2_bus_cntrl => ic_socket_lsu_i2_bus_cntrl_wire,
      socket_alu_comp_i1_data => ic_socket_alu_comp_i1_data_wire,
      socket_alu_comp_i2_data => ic_socket_alu_comp_i2_data_wire,
      socket_alu_comp_o1_data0 => ic_socket_alu_comp_o1_data0_wire,
      socket_alu_comp_o1_bus_cntrl => ic_socket_alu_comp_o1_bus_cntrl_wire,
      socket_gcu_i1_data => ic_socket_gcu_i1_data_wire,
      socket_gcu_i1_bus_cntrl => ic_socket_gcu_i1_bus_cntrl_wire,
      socket_gcu_i2_data => ic_socket_gcu_i2_data_wire,
      socket_gcu_i2_bus_cntrl => ic_socket_gcu_i2_bus_cntrl_wire,
      socket_gcu_o1_data0 => ic_socket_gcu_o1_data0_wire,
      socket_gcu_o1_bus_cntrl => ic_socket_gcu_o1_bus_cntrl_wire,
      socket_FU_ALGORITHM_i1_data => ic_socket_FU_ALGORITHM_i1_data_wire,
      socket_FU_ALGORITHM_i2_data => ic_socket_FU_ALGORITHM_i2_data_wire,
      socket_FU_ALGORITHM_o1_data0 => ic_socket_FU_ALGORITHM_o1_data0_wire,
      socket_FU_ALGORITHM_o1_bus_cntrl => ic_socket_FU_ALGORITHM_o1_bus_cntrl_wire,
      socket_RF_8x32_o1_data0 => ic_socket_RF_8x32_o1_data0_wire,
      socket_RF_8x32_o1_bus_cntrl => ic_socket_RF_8x32_o1_bus_cntrl_wire,
      socket_RF_8x32_i1_data => ic_socket_RF_8x32_i1_data_wire,
      socket_RF_8x32_i1_bus_cntrl => ic_socket_RF_8x32_i1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_data0 => ic_socket_RF_8x32_1_o1_data0_wire,
      socket_RF_8x32_1_o1_bus_cntrl => ic_socket_RF_8x32_1_o1_bus_cntrl_wire,
      socket_RF_8x32_1_i1_data => ic_socket_RF_8x32_1_i1_data_wire,
      socket_RF_8x32_1_i1_bus_cntrl => ic_socket_RF_8x32_1_i1_bus_cntrl_wire,
      socket_FU_CORDIC_i1_data => ic_socket_FU_CORDIC_i1_data_wire,
      socket_FU_CORDIC_i2_data => ic_socket_FU_CORDIC_i2_data_wire,
      socket_FU_CORDIC_o1_data0 => ic_socket_FU_CORDIC_o1_data0_wire,
      socket_FU_CORDIC_o1_bus_cntrl => ic_socket_FU_CORDIC_o1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_data => ic_socket_RF_8x32_1_o1_1_data_wire,
      socket_RF_8x32_1_o1_2_data => ic_socket_RF_8x32_1_o1_2_data_wire,
      socket_RF_8x32_1_o1_3_data0 => ic_socket_RF_8x32_1_o1_3_data0_wire,
      socket_RF_8x32_1_o1_3_bus_cntrl => ic_socket_RF_8x32_1_o1_3_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_data0 => ic_socket_RF_8x32_1_o1_1_1_data0_wire,
      socket_RF_8x32_1_o1_1_1_bus_cntrl => ic_socket_RF_8x32_1_o1_1_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_2_data => ic_socket_RF_8x32_1_o1_1_2_data_wire,
      socket_RF_8x32_1_o1_1_1_1_data0 => ic_socket_RF_8x32_1_o1_1_1_1_data0_wire,
      socket_RF_8x32_1_o1_1_1_1_bus_cntrl => ic_socket_RF_8x32_1_o1_1_1_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_2_data => ic_socket_RF_8x32_1_o1_1_1_2_data_wire,
      socket_RF_8x32_1_o1_2_1_data => ic_socket_RF_8x32_1_o1_2_1_data_wire,
      socket_RF_8x32_1_o1_1_3_data => ic_socket_RF_8x32_1_o1_1_3_data_wire,
      socket_RF_8x32_1_o1_3_1_data0 => ic_socket_RF_8x32_1_o1_3_1_data0_wire,
      socket_RF_8x32_1_o1_3_1_bus_cntrl => ic_socket_RF_8x32_1_o1_3_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_2_1_data0 => ic_socket_RF_8x32_1_o1_1_2_1_data0_wire,
      socket_RF_8x32_1_o1_1_2_1_bus_cntrl => ic_socket_RF_8x32_1_o1_1_2_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_3_data => ic_socket_RF_8x32_1_o1_1_1_3_data_wire,
      socket_RF_8x32_1_o1_1_1_3_1_data0 => ic_socket_RF_8x32_1_o1_1_1_3_1_data0_wire,
      socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl => ic_socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_2_1_1_data => ic_socket_RF_8x32_1_o1_1_2_1_1_data_wire,
      socket_RF_8x32_1_o1_2_1_1_data => ic_socket_RF_8x32_1_o1_2_1_1_data_wire,
      socket_RF_8x32_1_o1_1_3_1_data => ic_socket_RF_8x32_1_o1_1_3_1_data_wire,
      socket_RF_8x32_1_o1_3_1_1_data0 => ic_socket_RF_8x32_1_o1_3_1_1_data0_wire,
      socket_RF_8x32_1_o1_3_1_1_bus_cntrl => ic_socket_RF_8x32_1_o1_3_1_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_3_2_data => ic_socket_RF_8x32_1_o1_1_1_3_2_data_wire,
      socket_RF_8x32_1_o1_1_2_1_2_data0 => ic_socket_RF_8x32_1_o1_1_2_1_2_data0_wire,
      socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl => ic_socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_2_1_1_1_data0 => ic_socket_RF_8x32_1_o1_1_2_1_1_1_data0_wire,
      socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl => ic_socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_wire,
      socket_RF_8x32_1_o1_1_1_3_1_1_data => ic_socket_RF_8x32_1_o1_1_1_3_1_1_data_wire,
      simm_B1 => ic_simm_B1_wire,
      simm_cntrl_B1 => ic_simm_cntrl_B1_wire,
      simm_B2 => ic_simm_B2_wire,
      simm_cntrl_B2 => ic_simm_cntrl_B2_wire,
      simm_B3 => ic_simm_B3_wire,
      simm_cntrl_B3 => ic_simm_cntrl_B3_wire,
      simm_B1_1 => ic_simm_B1_1_wire,
      simm_cntrl_B1_1 => ic_simm_cntrl_B1_1_wire,
      simm_B1_2 => ic_simm_B1_2_wire,
      simm_cntrl_B1_2 => ic_simm_cntrl_B1_2_wire,
      simm_B1_3 => ic_simm_B1_3_wire,
      simm_cntrl_B1_3 => ic_simm_cntrl_B1_3_wire,
      simm_B1_4 => ic_simm_B1_4_wire,
      simm_cntrl_B1_4 => ic_simm_cntrl_B1_4_wire,
      simm_B1_5 => ic_simm_B1_5_wire,
      simm_cntrl_B1_5 => ic_simm_cntrl_B1_5_wire,
      simm_B1_6 => ic_simm_B1_6_wire,
      simm_cntrl_B1_6 => ic_simm_cntrl_B1_6_wire,
      simm_B1_7 => ic_simm_B1_7_wire,
      simm_cntrl_B1_7 => ic_simm_cntrl_B1_7_wire,
      simm_B1_8 => ic_simm_B1_8_wire,
      simm_cntrl_B1_8 => ic_simm_cntrl_B1_8_wire,
      simm_B1_9 => ic_simm_B1_9_wire,
      simm_cntrl_B1_9 => ic_simm_cntrl_B1_9_wire);

end structural;
