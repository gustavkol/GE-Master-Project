library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use work.tta0_globals.all;
use work.tta0_gcu_opcodes.all;
use work.tce_util.all;

entity tta0_decoder is

  port (
    instructionword : in std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);
    pc_load : out std_logic;
    ra_load : out std_logic;
    pc_opcode : out std_logic_vector(0 downto 0);
    lock : in std_logic;
    lock_r : out std_logic;
    clk : in std_logic;
    rstx : in std_logic;
    locked : out std_logic;
    simm_B1 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1 : out std_logic_vector(0 downto 0);
    simm_B2 : out std_logic_vector(31 downto 0);
    simm_cntrl_B2 : out std_logic_vector(0 downto 0);
    simm_B3 : out std_logic_vector(31 downto 0);
    simm_cntrl_B3 : out std_logic_vector(0 downto 0);
    simm_B1_1 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_1 : out std_logic_vector(0 downto 0);
    simm_B1_2 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_2 : out std_logic_vector(0 downto 0);
    simm_B1_3 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_3 : out std_logic_vector(0 downto 0);
    simm_B1_4 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_4 : out std_logic_vector(0 downto 0);
    simm_B1_5 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_5 : out std_logic_vector(0 downto 0);
    simm_B1_6 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_6 : out std_logic_vector(0 downto 0);
    simm_B1_7 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_7 : out std_logic_vector(0 downto 0);
    simm_B1_8 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_8 : out std_logic_vector(0 downto 0);
    simm_B1_9 : out std_logic_vector(31 downto 0);
    simm_cntrl_B1_9 : out std_logic_vector(0 downto 0);
    socket_lsu_o1_bus_cntrl : out std_logic_vector(1 downto 0);
    socket_lsu_i2_bus_cntrl : out std_logic_vector(1 downto 0);
    socket_alu_comp_o1_bus_cntrl : out std_logic_vector(4 downto 0);
    socket_gcu_i1_bus_cntrl : out std_logic_vector(1 downto 0);
    socket_gcu_i2_bus_cntrl : out std_logic_vector(1 downto 0);
    socket_gcu_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_FU_ALGORITHM_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_8x32_o1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_i1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_1_i1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_FU_CORDIC_o1_bus_cntrl : out std_logic_vector(1 downto 0);
    socket_RF_8x32_1_o1_3_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_8x32_1_o1_1_1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_1_1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_3_1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_8x32_1_o1_1_2_1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_3_1_1_bus_cntrl : out std_logic_vector(1 downto 0);
    socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl : out std_logic_vector(0 downto 0);
    fu_lsu_in1t_load : out std_logic;
    fu_lsu_in2_load : out std_logic;
    fu_lsu_opc : out std_logic_vector(2 downto 0);
    fu_alu_in1t_load : out std_logic;
    fu_alu_in2_load : out std_logic;
    fu_alu_opc : out std_logic_vector(3 downto 0);
    fu_FU_ALGO_P1_load : out std_logic;
    fu_FU_ALGO_P2_load : out std_logic;
    fu_FU_ALGO_opc : out std_logic_vector(3 downto 0);
    fu_FU_CORDIC_P1_load : out std_logic;
    fu_FU_CORDIC_P2_load : out std_logic;
    fu_FU_ALGO_1_P1_load : out std_logic;
    fu_FU_ALGO_1_P2_load : out std_logic;
    fu_FU_ALGO_1_opc : out std_logic_vector(2 downto 0);
    fu_FU_ALGO_2_P1_load : out std_logic;
    fu_FU_ALGO_2_P2_load : out std_logic;
    fu_FU_ALGO_2_opc : out std_logic_vector(2 downto 0);
    fu_FU_ALGO_3_P1_load : out std_logic;
    fu_FU_ALGO_3_P2_load : out std_logic;
    fu_FU_ALGO_3_opc : out std_logic_vector(2 downto 0);
    rf_RF1_r0_load : out std_logic;
    rf_RF1_r0_opc : out std_logic_vector(3 downto 0);
    rf_RF1_w0_load : out std_logic;
    rf_RF1_w0_opc : out std_logic_vector(3 downto 0);
    rf_RF2_r0_load : out std_logic;
    rf_RF2_r0_opc : out std_logic_vector(5 downto 0);
    rf_RF2_w0_load : out std_logic;
    rf_RF2_w0_opc : out std_logic_vector(5 downto 0);
    rf_RF1_1_r0_load : out std_logic;
    rf_RF1_1_r0_opc : out std_logic_vector(3 downto 0);
    rf_RF1_1_w0_load : out std_logic;
    rf_RF1_1_w0_opc : out std_logic_vector(3 downto 0);
    rf_RF2_1_r0_load : out std_logic;
    rf_RF2_1_r0_opc : out std_logic_vector(5 downto 0);
    rf_RF2_1_w0_load : out std_logic;
    rf_RF2_1_w0_opc : out std_logic_vector(5 downto 0);
    rf_RF1_2_r0_load : out std_logic;
    rf_RF1_2_r0_opc : out std_logic_vector(3 downto 0);
    rf_RF1_2_w0_load : out std_logic;
    rf_RF1_2_w0_opc : out std_logic_vector(3 downto 0);
    rf_RF2_2_r0_load : out std_logic;
    rf_RF2_2_r0_opc : out std_logic_vector(5 downto 0);
    rf_RF2_2_w0_load : out std_logic;
    rf_RF2_2_w0_opc : out std_logic_vector(5 downto 0);
    rf_RF1_3_r0_load : out std_logic;
    rf_RF1_3_r0_opc : out std_logic_vector(3 downto 0);
    rf_RF1_3_w0_load : out std_logic;
    rf_RF1_3_w0_opc : out std_logic_vector(3 downto 0);
    rf_RF2_3_r0_load : out std_logic;
    rf_RF2_3_r0_opc : out std_logic_vector(5 downto 0);
    rf_RF2_3_w0_load : out std_logic;
    rf_RF2_3_w0_opc : out std_logic_vector(5 downto 0);
    glock : out std_logic_vector(15 downto 0));

end tta0_decoder;

architecture rtl_andor of tta0_decoder is

  -- signals for source, destination and guard fields
  signal move_B1 : std_logic_vector(38 downto 0);
  signal src_B1 : std_logic_vector(32 downto 0);
  signal dst_B1 : std_logic_vector(5 downto 0);
  signal move_B2 : std_logic_vector(39 downto 0);
  signal src_B2 : std_logic_vector(32 downto 0);
  signal dst_B2 : std_logic_vector(6 downto 0);
  signal move_B3 : std_logic_vector(39 downto 0);
  signal src_B3 : std_logic_vector(32 downto 0);
  signal dst_B3 : std_logic_vector(6 downto 0);
  signal move_B1_1 : std_logic_vector(36 downto 0);
  signal src_B1_1 : std_logic_vector(32 downto 0);
  signal dst_B1_1 : std_logic_vector(3 downto 0);
  signal move_B1_2 : std_logic_vector(34 downto 0);
  signal src_B1_2 : std_logic_vector(32 downto 0);
  signal dst_B1_2 : std_logic_vector(1 downto 0);
  signal move_B1_3 : std_logic_vector(39 downto 0);
  signal src_B1_3 : std_logic_vector(32 downto 0);
  signal dst_B1_3 : std_logic_vector(6 downto 0);
  signal move_B1_4 : std_logic_vector(36 downto 0);
  signal src_B1_4 : std_logic_vector(32 downto 0);
  signal dst_B1_4 : std_logic_vector(3 downto 0);
  signal move_B1_5 : std_logic_vector(34 downto 0);
  signal src_B1_5 : std_logic_vector(32 downto 0);
  signal dst_B1_5 : std_logic_vector(1 downto 0);
  signal move_B1_6 : std_logic_vector(39 downto 0);
  signal src_B1_6 : std_logic_vector(32 downto 0);
  signal dst_B1_6 : std_logic_vector(6 downto 0);
  signal move_B1_7 : std_logic_vector(36 downto 0);
  signal src_B1_7 : std_logic_vector(32 downto 0);
  signal dst_B1_7 : std_logic_vector(3 downto 0);
  signal move_B1_8 : std_logic_vector(34 downto 0);
  signal src_B1_8 : std_logic_vector(32 downto 0);
  signal dst_B1_8 : std_logic_vector(1 downto 0);
  signal move_B1_9 : std_logic_vector(39 downto 0);
  signal src_B1_9 : std_logic_vector(32 downto 0);
  signal dst_B1_9 : std_logic_vector(6 downto 0);

  -- signals for dedicated immediate slots


  -- squash signals
  signal squash_B1 : std_logic;
  signal squash_B2 : std_logic;
  signal squash_B3 : std_logic;
  signal squash_B1_1 : std_logic;
  signal squash_B1_2 : std_logic;
  signal squash_B1_3 : std_logic;
  signal squash_B1_4 : std_logic;
  signal squash_B1_5 : std_logic;
  signal squash_B1_6 : std_logic;
  signal squash_B1_7 : std_logic;
  signal squash_B1_8 : std_logic;
  signal squash_B1_9 : std_logic;

  -- socket control signals
  signal socket_lsu_o1_bus_cntrl_reg : std_logic_vector(1 downto 0);
  signal socket_lsu_i2_bus_cntrl_reg : std_logic_vector(1 downto 0);
  signal socket_alu_comp_o1_bus_cntrl_reg : std_logic_vector(4 downto 0);
  signal socket_gcu_i1_bus_cntrl_reg : std_logic_vector(1 downto 0);
  signal socket_gcu_i2_bus_cntrl_reg : std_logic_vector(1 downto 0);
  signal socket_gcu_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_FU_ALGORITHM_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_8x32_o1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_i1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_1_o1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_1_i1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_FU_CORDIC_o1_bus_cntrl_reg : std_logic_vector(1 downto 0);
  signal socket_RF_8x32_1_o1_3_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_8x32_1_o1_1_1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_1_o1_1_1_1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_1_o1_3_1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_8x32_1_o1_1_2_1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_1_o1_3_1_1_bus_cntrl_reg : std_logic_vector(1 downto 0);
  signal socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal simm_B1_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_reg : std_logic_vector(0 downto 0);
  signal simm_B2_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B2_reg : std_logic_vector(0 downto 0);
  signal simm_B3_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B3_reg : std_logic_vector(0 downto 0);
  signal simm_B1_1_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_1_reg : std_logic_vector(0 downto 0);
  signal simm_B1_2_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_2_reg : std_logic_vector(0 downto 0);
  signal simm_B1_3_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_3_reg : std_logic_vector(0 downto 0);
  signal simm_B1_4_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_4_reg : std_logic_vector(0 downto 0);
  signal simm_B1_5_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_5_reg : std_logic_vector(0 downto 0);
  signal simm_B1_6_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_6_reg : std_logic_vector(0 downto 0);
  signal simm_B1_7_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_7_reg : std_logic_vector(0 downto 0);
  signal simm_B1_8_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_8_reg : std_logic_vector(0 downto 0);
  signal simm_B1_9_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B1_9_reg : std_logic_vector(0 downto 0);

  -- FU control signals
  signal fu_lsu_in1t_load_reg : std_logic;
  signal fu_lsu_in2_load_reg : std_logic;
  signal fu_lsu_opc_reg : std_logic_vector(2 downto 0);
  signal fu_alu_in1t_load_reg : std_logic;
  signal fu_alu_in2_load_reg : std_logic;
  signal fu_alu_opc_reg : std_logic_vector(3 downto 0);
  signal fu_FU_ALGO_P1_load_reg : std_logic;
  signal fu_FU_ALGO_P2_load_reg : std_logic;
  signal fu_FU_ALGO_opc_reg : std_logic_vector(3 downto 0);
  signal fu_FU_CORDIC_P1_load_reg : std_logic;
  signal fu_FU_CORDIC_P2_load_reg : std_logic;
  signal fu_FU_ALGO_1_P1_load_reg : std_logic;
  signal fu_FU_ALGO_1_P2_load_reg : std_logic;
  signal fu_FU_ALGO_1_opc_reg : std_logic_vector(2 downto 0);
  signal fu_FU_ALGO_2_P1_load_reg : std_logic;
  signal fu_FU_ALGO_2_P2_load_reg : std_logic;
  signal fu_FU_ALGO_2_opc_reg : std_logic_vector(2 downto 0);
  signal fu_FU_ALGO_3_P1_load_reg : std_logic;
  signal fu_FU_ALGO_3_P2_load_reg : std_logic;
  signal fu_FU_ALGO_3_opc_reg : std_logic_vector(2 downto 0);
  signal fu_gcu_pc_load_reg : std_logic;
  signal fu_gcu_ra_load_reg : std_logic;
  signal fu_gcu_opc_reg : std_logic_vector(0 downto 0);

  -- RF control signals
  signal rf_RF1_r0_load_reg : std_logic;
  signal rf_RF1_r0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF1_w0_load_reg : std_logic;
  signal rf_RF1_w0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF2_r0_load_reg : std_logic;
  signal rf_RF2_r0_opc_reg : std_logic_vector(5 downto 0);
  signal rf_RF2_w0_load_reg : std_logic;
  signal rf_RF2_w0_opc_reg : std_logic_vector(5 downto 0);
  signal rf_RF1_1_r0_load_reg : std_logic;
  signal rf_RF1_1_r0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF1_1_w0_load_reg : std_logic;
  signal rf_RF1_1_w0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF2_1_r0_load_reg : std_logic;
  signal rf_RF2_1_r0_opc_reg : std_logic_vector(5 downto 0);
  signal rf_RF2_1_w0_load_reg : std_logic;
  signal rf_RF2_1_w0_opc_reg : std_logic_vector(5 downto 0);
  signal rf_RF1_2_r0_load_reg : std_logic;
  signal rf_RF1_2_r0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF1_2_w0_load_reg : std_logic;
  signal rf_RF1_2_w0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF2_2_r0_load_reg : std_logic;
  signal rf_RF2_2_r0_opc_reg : std_logic_vector(5 downto 0);
  signal rf_RF2_2_w0_load_reg : std_logic;
  signal rf_RF2_2_w0_opc_reg : std_logic_vector(5 downto 0);
  signal rf_RF1_3_r0_load_reg : std_logic;
  signal rf_RF1_3_r0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF1_3_w0_load_reg : std_logic;
  signal rf_RF1_3_w0_opc_reg : std_logic_vector(3 downto 0);
  signal rf_RF2_3_r0_load_reg : std_logic;
  signal rf_RF2_3_r0_opc_reg : std_logic_vector(5 downto 0);
  signal rf_RF2_3_w0_load_reg : std_logic;
  signal rf_RF2_3_w0_opc_reg : std_logic_vector(5 downto 0);

  signal merged_glock_req : std_logic;
  signal pre_decode_merged_glock : std_logic;
  signal post_decode_merged_glock : std_logic;
  signal post_decode_merged_glock_r : std_logic;

  signal decode_fill_lock_reg : std_logic;
begin

  -- dismembering of instruction
  process (instructionword)
  begin --process
    move_B1 <= instructionword(39-1 downto 0);
    src_B1 <= instructionword(38 downto 6);
    dst_B1 <= instructionword(5 downto 0);
    move_B2 <= instructionword(79-1 downto 39);
    src_B2 <= instructionword(78 downto 46);
    dst_B2 <= instructionword(45 downto 39);
    move_B3 <= instructionword(119-1 downto 79);
    src_B3 <= instructionword(118 downto 86);
    dst_B3 <= instructionword(85 downto 79);
    move_B1_1 <= instructionword(156-1 downto 119);
    src_B1_1 <= instructionword(155 downto 123);
    dst_B1_1 <= instructionword(122 downto 119);
    move_B1_2 <= instructionword(191-1 downto 156);
    src_B1_2 <= instructionword(190 downto 158);
    dst_B1_2 <= instructionword(157 downto 156);
    move_B1_3 <= instructionword(231-1 downto 191);
    src_B1_3 <= instructionword(230 downto 198);
    dst_B1_3 <= instructionword(197 downto 191);
    move_B1_4 <= instructionword(268-1 downto 231);
    src_B1_4 <= instructionword(267 downto 235);
    dst_B1_4 <= instructionword(234 downto 231);
    move_B1_5 <= instructionword(303-1 downto 268);
    src_B1_5 <= instructionword(302 downto 270);
    dst_B1_5 <= instructionword(269 downto 268);
    move_B1_6 <= instructionword(343-1 downto 303);
    src_B1_6 <= instructionword(342 downto 310);
    dst_B1_6 <= instructionword(309 downto 303);
    move_B1_7 <= instructionword(380-1 downto 343);
    src_B1_7 <= instructionword(379 downto 347);
    dst_B1_7 <= instructionword(346 downto 343);
    move_B1_8 <= instructionword(415-1 downto 380);
    src_B1_8 <= instructionword(414 downto 382);
    dst_B1_8 <= instructionword(381 downto 380);
    move_B1_9 <= instructionword(455-1 downto 415);
    src_B1_9 <= instructionword(454 downto 422);
    dst_B1_9 <= instructionword(421 downto 415);

  end process;

  -- map control registers to outputs
  fu_lsu_in1t_load <= fu_lsu_in1t_load_reg;
  fu_lsu_in2_load <= fu_lsu_in2_load_reg;
  fu_lsu_opc <= fu_lsu_opc_reg;

  fu_alu_in1t_load <= fu_alu_in1t_load_reg;
  fu_alu_in2_load <= fu_alu_in2_load_reg;
  fu_alu_opc <= fu_alu_opc_reg;

  fu_FU_ALGO_P1_load <= fu_FU_ALGO_P1_load_reg;
  fu_FU_ALGO_P2_load <= fu_FU_ALGO_P2_load_reg;
  fu_FU_ALGO_opc <= fu_FU_ALGO_opc_reg;

  fu_FU_CORDIC_P1_load <= fu_FU_CORDIC_P1_load_reg;
  fu_FU_CORDIC_P2_load <= fu_FU_CORDIC_P2_load_reg;

  fu_FU_ALGO_1_P1_load <= fu_FU_ALGO_1_P1_load_reg;
  fu_FU_ALGO_1_P2_load <= fu_FU_ALGO_1_P2_load_reg;
  fu_FU_ALGO_1_opc <= fu_FU_ALGO_1_opc_reg;

  fu_FU_ALGO_2_P1_load <= fu_FU_ALGO_2_P1_load_reg;
  fu_FU_ALGO_2_P2_load <= fu_FU_ALGO_2_P2_load_reg;
  fu_FU_ALGO_2_opc <= fu_FU_ALGO_2_opc_reg;

  fu_FU_ALGO_3_P1_load <= fu_FU_ALGO_3_P1_load_reg;
  fu_FU_ALGO_3_P2_load <= fu_FU_ALGO_3_P2_load_reg;
  fu_FU_ALGO_3_opc <= fu_FU_ALGO_3_opc_reg;

  ra_load <= fu_gcu_ra_load_reg;
  pc_load <= fu_gcu_pc_load_reg;
  pc_opcode <= fu_gcu_opc_reg;
  rf_RF1_r0_load <= rf_RF1_r0_load_reg;
  rf_RF1_r0_opc <= rf_RF1_r0_opc_reg;
  rf_RF1_w0_load <= rf_RF1_w0_load_reg;
  rf_RF1_w0_opc <= rf_RF1_w0_opc_reg;
  rf_RF2_r0_load <= rf_RF2_r0_load_reg;
  rf_RF2_r0_opc <= rf_RF2_r0_opc_reg;
  rf_RF2_w0_load <= rf_RF2_w0_load_reg;
  rf_RF2_w0_opc <= rf_RF2_w0_opc_reg;
  rf_RF1_1_r0_load <= rf_RF1_1_r0_load_reg;
  rf_RF1_1_r0_opc <= rf_RF1_1_r0_opc_reg;
  rf_RF1_1_w0_load <= rf_RF1_1_w0_load_reg;
  rf_RF1_1_w0_opc <= rf_RF1_1_w0_opc_reg;
  rf_RF2_1_r0_load <= rf_RF2_1_r0_load_reg;
  rf_RF2_1_r0_opc <= rf_RF2_1_r0_opc_reg;
  rf_RF2_1_w0_load <= rf_RF2_1_w0_load_reg;
  rf_RF2_1_w0_opc <= rf_RF2_1_w0_opc_reg;
  rf_RF1_2_r0_load <= rf_RF1_2_r0_load_reg;
  rf_RF1_2_r0_opc <= rf_RF1_2_r0_opc_reg;
  rf_RF1_2_w0_load <= rf_RF1_2_w0_load_reg;
  rf_RF1_2_w0_opc <= rf_RF1_2_w0_opc_reg;
  rf_RF2_2_r0_load <= rf_RF2_2_r0_load_reg;
  rf_RF2_2_r0_opc <= rf_RF2_2_r0_opc_reg;
  rf_RF2_2_w0_load <= rf_RF2_2_w0_load_reg;
  rf_RF2_2_w0_opc <= rf_RF2_2_w0_opc_reg;
  rf_RF1_3_r0_load <= rf_RF1_3_r0_load_reg;
  rf_RF1_3_r0_opc <= rf_RF1_3_r0_opc_reg;
  rf_RF1_3_w0_load <= rf_RF1_3_w0_load_reg;
  rf_RF1_3_w0_opc <= rf_RF1_3_w0_opc_reg;
  rf_RF2_3_r0_load <= rf_RF2_3_r0_load_reg;
  rf_RF2_3_r0_opc <= rf_RF2_3_r0_opc_reg;
  rf_RF2_3_w0_load <= rf_RF2_3_w0_load_reg;
  rf_RF2_3_w0_opc <= rf_RF2_3_w0_opc_reg;
  socket_lsu_o1_bus_cntrl <= socket_lsu_o1_bus_cntrl_reg;
  socket_lsu_i2_bus_cntrl <= socket_lsu_i2_bus_cntrl_reg;
  socket_alu_comp_o1_bus_cntrl <= socket_alu_comp_o1_bus_cntrl_reg;
  socket_gcu_i1_bus_cntrl <= socket_gcu_i1_bus_cntrl_reg;
  socket_gcu_i2_bus_cntrl <= socket_gcu_i2_bus_cntrl_reg;
  socket_gcu_o1_bus_cntrl <= socket_gcu_o1_bus_cntrl_reg;
  socket_FU_ALGORITHM_o1_bus_cntrl <= socket_FU_ALGORITHM_o1_bus_cntrl_reg;
  socket_RF_8x32_o1_bus_cntrl <= socket_RF_8x32_o1_bus_cntrl_reg;
  socket_RF_8x32_i1_bus_cntrl <= socket_RF_8x32_i1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_bus_cntrl <= socket_RF_8x32_1_o1_bus_cntrl_reg;
  socket_RF_8x32_1_i1_bus_cntrl <= socket_RF_8x32_1_i1_bus_cntrl_reg;
  socket_FU_CORDIC_o1_bus_cntrl <= socket_FU_CORDIC_o1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_3_bus_cntrl <= socket_RF_8x32_1_o1_3_bus_cntrl_reg;
  socket_RF_8x32_1_o1_1_1_bus_cntrl <= socket_RF_8x32_1_o1_1_1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_1_1_1_bus_cntrl <= socket_RF_8x32_1_o1_1_1_1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_3_1_bus_cntrl <= socket_RF_8x32_1_o1_3_1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_1_2_1_bus_cntrl <= socket_RF_8x32_1_o1_1_2_1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl <= socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_3_1_1_bus_cntrl <= socket_RF_8x32_1_o1_3_1_1_bus_cntrl_reg;
  socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl <= socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_reg;
  socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl <= socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_reg;
  simm_cntrl_B1 <= simm_cntrl_B1_reg;
  simm_B1 <= simm_B1_reg;
  simm_cntrl_B2 <= simm_cntrl_B2_reg;
  simm_B2 <= simm_B2_reg;
  simm_cntrl_B3 <= simm_cntrl_B3_reg;
  simm_B3 <= simm_B3_reg;
  simm_cntrl_B1_1 <= simm_cntrl_B1_1_reg;
  simm_B1_1 <= simm_B1_1_reg;
  simm_cntrl_B1_2 <= simm_cntrl_B1_2_reg;
  simm_B1_2 <= simm_B1_2_reg;
  simm_cntrl_B1_3 <= simm_cntrl_B1_3_reg;
  simm_B1_3 <= simm_B1_3_reg;
  simm_cntrl_B1_4 <= simm_cntrl_B1_4_reg;
  simm_B1_4 <= simm_B1_4_reg;
  simm_cntrl_B1_5 <= simm_cntrl_B1_5_reg;
  simm_B1_5 <= simm_B1_5_reg;
  simm_cntrl_B1_6 <= simm_cntrl_B1_6_reg;
  simm_B1_6 <= simm_B1_6_reg;
  simm_cntrl_B1_7 <= simm_cntrl_B1_7_reg;
  simm_B1_7 <= simm_B1_7_reg;
  simm_cntrl_B1_8 <= simm_cntrl_B1_8_reg;
  simm_B1_8 <= simm_B1_8_reg;
  simm_cntrl_B1_9 <= simm_cntrl_B1_9_reg;
  simm_B1_9 <= simm_B1_9_reg;

  -- generate signal squash_B1
  squash_B1 <= '0';
  -- generate signal squash_B2
  squash_B2 <= '0';
  -- generate signal squash_B3
  squash_B3 <= '0';
  -- generate signal squash_B1_1
  squash_B1_1 <= '0';
  -- generate signal squash_B1_2
  squash_B1_2 <= '0';
  -- generate signal squash_B1_3
  squash_B1_3 <= '0';
  -- generate signal squash_B1_4
  squash_B1_4 <= '0';
  -- generate signal squash_B1_5
  squash_B1_5 <= '0';
  -- generate signal squash_B1_6
  squash_B1_6 <= '0';
  -- generate signal squash_B1_7
  squash_B1_7 <= '0';
  -- generate signal squash_B1_8
  squash_B1_8 <= '0';
  -- generate signal squash_B1_9
  squash_B1_9 <= '0';



  -- main decoding process
  process (clk, rstx)
  begin
    if (rstx = '0') then
      socket_lsu_o1_bus_cntrl_reg <= (others => '0');
      socket_lsu_i2_bus_cntrl_reg <= (others => '0');
      socket_alu_comp_o1_bus_cntrl_reg <= (others => '0');
      socket_gcu_i1_bus_cntrl_reg <= (others => '0');
      socket_gcu_i2_bus_cntrl_reg <= (others => '0');
      socket_gcu_o1_bus_cntrl_reg <= (others => '0');
      socket_FU_ALGORITHM_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_i1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_i1_bus_cntrl_reg <= (others => '0');
      socket_FU_CORDIC_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_3_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_1_1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_1_1_1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_3_1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_1_2_1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_3_1_1_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_reg <= (others => '0');
      socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_reg <= (others => '0');
      simm_B1_reg <= (others => '0');
      simm_cntrl_B1_reg <= (others => '0');
      simm_B2_reg <= (others => '0');
      simm_cntrl_B2_reg <= (others => '0');
      simm_B3_reg <= (others => '0');
      simm_cntrl_B3_reg <= (others => '0');
      simm_B1_1_reg <= (others => '0');
      simm_cntrl_B1_1_reg <= (others => '0');
      simm_B1_2_reg <= (others => '0');
      simm_cntrl_B1_2_reg <= (others => '0');
      simm_B1_3_reg <= (others => '0');
      simm_cntrl_B1_3_reg <= (others => '0');
      simm_B1_4_reg <= (others => '0');
      simm_cntrl_B1_4_reg <= (others => '0');
      simm_B1_5_reg <= (others => '0');
      simm_cntrl_B1_5_reg <= (others => '0');
      simm_B1_6_reg <= (others => '0');
      simm_cntrl_B1_6_reg <= (others => '0');
      simm_B1_7_reg <= (others => '0');
      simm_cntrl_B1_7_reg <= (others => '0');
      simm_B1_8_reg <= (others => '0');
      simm_cntrl_B1_8_reg <= (others => '0');
      simm_B1_9_reg <= (others => '0');
      simm_cntrl_B1_9_reg <= (others => '0');
      fu_lsu_opc_reg <= (others => '0');
      fu_alu_opc_reg <= (others => '0');
      fu_FU_ALGO_opc_reg <= (others => '0');
      fu_FU_ALGO_1_opc_reg <= (others => '0');
      fu_FU_ALGO_2_opc_reg <= (others => '0');
      fu_FU_ALGO_3_opc_reg <= (others => '0');
      fu_gcu_opc_reg <= (others => '0');
      rf_RF1_r0_opc_reg <= (others => '0');
      rf_RF1_w0_opc_reg <= (others => '0');
      rf_RF2_r0_opc_reg <= (others => '0');
      rf_RF2_w0_opc_reg <= (others => '0');
      rf_RF1_1_r0_opc_reg <= (others => '0');
      rf_RF1_1_w0_opc_reg <= (others => '0');
      rf_RF2_1_r0_opc_reg <= (others => '0');
      rf_RF2_1_w0_opc_reg <= (others => '0');
      rf_RF1_2_r0_opc_reg <= (others => '0');
      rf_RF1_2_w0_opc_reg <= (others => '0');
      rf_RF2_2_r0_opc_reg <= (others => '0');
      rf_RF2_2_w0_opc_reg <= (others => '0');
      rf_RF1_3_r0_opc_reg <= (others => '0');
      rf_RF1_3_w0_opc_reg <= (others => '0');
      rf_RF2_3_r0_opc_reg <= (others => '0');
      rf_RF2_3_w0_opc_reg <= (others => '0');

      fu_lsu_in1t_load_reg <= '0';
      fu_lsu_in2_load_reg <= '0';
      fu_alu_in1t_load_reg <= '0';
      fu_alu_in2_load_reg <= '0';
      fu_FU_ALGO_P1_load_reg <= '0';
      fu_FU_ALGO_P2_load_reg <= '0';
      fu_FU_CORDIC_P1_load_reg <= '0';
      fu_FU_CORDIC_P2_load_reg <= '0';
      fu_FU_ALGO_1_P1_load_reg <= '0';
      fu_FU_ALGO_1_P2_load_reg <= '0';
      fu_FU_ALGO_2_P1_load_reg <= '0';
      fu_FU_ALGO_2_P2_load_reg <= '0';
      fu_FU_ALGO_3_P1_load_reg <= '0';
      fu_FU_ALGO_3_P2_load_reg <= '0';
      fu_gcu_pc_load_reg <= '0';
      fu_gcu_ra_load_reg <= '0';
      rf_RF1_r0_load_reg <= '0';
      rf_RF1_w0_load_reg <= '0';
      rf_RF2_r0_load_reg <= '0';
      rf_RF2_w0_load_reg <= '0';
      rf_RF1_1_r0_load_reg <= '0';
      rf_RF1_1_w0_load_reg <= '0';
      rf_RF2_1_r0_load_reg <= '0';
      rf_RF2_1_w0_load_reg <= '0';
      rf_RF1_2_r0_load_reg <= '0';
      rf_RF1_2_w0_load_reg <= '0';
      rf_RF2_2_r0_load_reg <= '0';
      rf_RF2_2_w0_load_reg <= '0';
      rf_RF1_3_r0_load_reg <= '0';
      rf_RF1_3_w0_load_reg <= '0';
      rf_RF2_3_r0_load_reg <= '0';
      rf_RF2_3_w0_load_reg <= '0';


    elsif (clk'event and clk = '1') then -- rising clock edge
    if (pre_decode_merged_glock = '0') then

        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 29))) = 10) then
          socket_lsu_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 29))) = 9) then
          socket_lsu_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_lsu_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 30))) = 5) then
          socket_alu_comp_o1_bus_cntrl_reg(3) <= '1';
        else
          socket_alu_comp_o1_bus_cntrl_reg(3) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 30))) = 5) then
          socket_alu_comp_o1_bus_cntrl_reg(4) <= '1';
        else
          socket_alu_comp_o1_bus_cntrl_reg(4) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 29))) = 10) then
          socket_alu_comp_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_alu_comp_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 30))) = 5) then
          socket_alu_comp_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_alu_comp_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 29))) = 10) then
          socket_alu_comp_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_alu_comp_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 29))) = 11) then
          socket_gcu_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 29))) = 11) then
          socket_gcu_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 29))) = 11) then
          socket_gcu_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_gcu_o1_bus_cntrl_reg(2) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 29))) = 12) then
          socket_FU_ALGORITHM_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_FU_ALGORITHM_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 30))) = 6) then
          socket_FU_ALGORITHM_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_FU_ALGORITHM_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 29))) = 12) then
          socket_FU_ALGORITHM_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_FU_ALGORITHM_o1_bus_cntrl_reg(1) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 29))) = 8) then
          socket_RF_8x32_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 29))) = 8) then
          socket_RF_8x32_1_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 29))) = 12) then
          socket_FU_CORDIC_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_FU_CORDIC_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 29))) = 13) then
          socket_FU_CORDIC_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_FU_CORDIC_o1_bus_cntrl_reg(1) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 30))) = 6) then
          socket_RF_8x32_1_o1_3_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_8x32_1_o1_3_bus_cntrl_reg(2) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 30))) = 6) then
          socket_RF_8x32_1_o1_3_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_8x32_1_o1_3_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 30))) = 7) then
          socket_RF_8x32_1_o1_3_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_3_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 30))) = 4) then
          socket_RF_8x32_1_o1_1_1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_1_1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 31))) = 2) then
          socket_RF_8x32_1_o1_1_1_1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_1_1_1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 30))) = 7) then
          socket_RF_8x32_1_o1_3_1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_8x32_1_o1_3_1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 30))) = 6) then
          socket_RF_8x32_1_o1_3_1_bus_cntrl_reg(2) <= '1';
        else
          socket_RF_8x32_1_o1_3_1_bus_cntrl_reg(2) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 30))) = 6) then
          socket_RF_8x32_1_o1_3_1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_3_1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 30))) = 4) then
          socket_RF_8x32_1_o1_1_2_1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_1_2_1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 31))) = 2) then
          socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 30))) = 6) then
          socket_RF_8x32_1_o1_3_1_1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_3_1_1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 30))) = 7) then
          socket_RF_8x32_1_o1_3_1_1_bus_cntrl_reg(1) <= '1';
        else
          socket_RF_8x32_1_o1_3_1_1_bus_cntrl_reg(1) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 30))) = 4) then
          socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 31))) = 2) then
          socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 32))) = 0) then
          simm_cntrl_B1_reg(0) <= '1';
        simm_B1_reg <= tce_ext(src_B1(31 downto 0), simm_B1_reg'length);
        else
          simm_cntrl_B1_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 32))) = 0) then
          simm_cntrl_B2_reg(0) <= '1';
        simm_B2_reg <= tce_ext(src_B2(31 downto 0), simm_B2_reg'length);
        else
          simm_cntrl_B2_reg(0) <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(32 downto 32))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_ext(src_B3(31 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 32))) = 0) then
          simm_cntrl_B1_1_reg(0) <= '1';
        simm_B1_1_reg <= tce_ext(src_B1_1(31 downto 0), simm_B1_1_reg'length);
        else
          simm_cntrl_B1_1_reg(0) <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 32))) = 0) then
          simm_cntrl_B1_2_reg(0) <= '1';
        simm_B1_2_reg <= tce_ext(src_B1_2(31 downto 0), simm_B1_2_reg'length);
        else
          simm_cntrl_B1_2_reg(0) <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(src_B1_3(32 downto 32))) = 0) then
          simm_cntrl_B1_3_reg(0) <= '1';
        simm_B1_3_reg <= tce_ext(src_B1_3(31 downto 0), simm_B1_3_reg'length);
        else
          simm_cntrl_B1_3_reg(0) <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 32))) = 0) then
          simm_cntrl_B1_4_reg(0) <= '1';
        simm_B1_4_reg <= tce_ext(src_B1_4(31 downto 0), simm_B1_4_reg'length);
        else
          simm_cntrl_B1_4_reg(0) <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 32))) = 0) then
          simm_cntrl_B1_5_reg(0) <= '1';
        simm_B1_5_reg <= tce_ext(src_B1_5(31 downto 0), simm_B1_5_reg'length);
        else
          simm_cntrl_B1_5_reg(0) <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(src_B1_6(32 downto 32))) = 0) then
          simm_cntrl_B1_6_reg(0) <= '1';
        simm_B1_6_reg <= tce_ext(src_B1_6(31 downto 0), simm_B1_6_reg'length);
        else
          simm_cntrl_B1_6_reg(0) <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 32))) = 0) then
          simm_cntrl_B1_7_reg(0) <= '1';
        simm_B1_7_reg <= tce_ext(src_B1_7(31 downto 0), simm_B1_7_reg'length);
        else
          simm_cntrl_B1_7_reg(0) <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 32))) = 0) then
          simm_cntrl_B1_8_reg(0) <= '1';
        simm_B1_8_reg <= tce_ext(src_B1_8(31 downto 0), simm_B1_8_reg'length);
        else
          simm_cntrl_B1_8_reg(0) <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(src_B1_9(32 downto 32))) = 0) then
          simm_cntrl_B1_9_reg(0) <= '1';
        simm_B1_9_reg <= tce_ext(src_B1_9(31 downto 0), simm_B1_9_reg'length);
        else
          simm_cntrl_B1_9_reg(0) <= '0';
        end if;
        -- data control signals for output sockets connected to FUs
        -- control signals for RF read ports
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(32 downto 29))) = 8 and true) then
          rf_RF1_r0_load_reg <= '1';
          rf_RF1_r0_opc_reg <= tce_ext(src_B1(3 downto 0), rf_RF1_r0_opc_reg'length);
        else
          rf_RF1_r0_load_reg <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(32 downto 29))) = 8 and true) then
          rf_RF2_r0_load_reg <= '1';
          rf_RF2_r0_opc_reg <= tce_ext(src_B2(5 downto 0), rf_RF2_r0_opc_reg'length);
        else
          rf_RF2_r0_load_reg <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(src_B1_1(32 downto 30))) = 4 and true) then
          rf_RF1_1_r0_load_reg <= '1';
          rf_RF1_1_r0_opc_reg <= tce_ext(src_B1_1(3 downto 0), rf_RF1_1_r0_opc_reg'length);
        else
          rf_RF1_1_r0_load_reg <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(src_B1_2(32 downto 31))) = 2 and true) then
          rf_RF2_1_r0_load_reg <= '1';
          rf_RF2_1_r0_opc_reg <= tce_ext(src_B1_2(5 downto 0), rf_RF2_1_r0_opc_reg'length);
        else
          rf_RF2_1_r0_load_reg <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(src_B1_4(32 downto 30))) = 4 and true) then
          rf_RF1_2_r0_load_reg <= '1';
          rf_RF1_2_r0_opc_reg <= tce_ext(src_B1_4(3 downto 0), rf_RF1_2_r0_opc_reg'length);
        else
          rf_RF1_2_r0_load_reg <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(src_B1_5(32 downto 31))) = 2 and true) then
          rf_RF2_2_r0_load_reg <= '1';
          rf_RF2_2_r0_opc_reg <= tce_ext(src_B1_5(5 downto 0), rf_RF2_2_r0_opc_reg'length);
        else
          rf_RF2_2_r0_load_reg <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(src_B1_7(32 downto 30))) = 4 and true) then
          rf_RF1_3_w0_load_reg <= '1';
          rf_RF1_3_w0_opc_reg <= tce_ext(src_B1_7(3 downto 0), rf_RF1_3_w0_opc_reg'length);
        else
          rf_RF1_3_w0_load_reg <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(src_B1_8(32 downto 31))) = 2 and true) then
          rf_RF2_3_r0_load_reg <= '1';
          rf_RF2_3_r0_opc_reg <= tce_ext(src_B1_8(5 downto 0), rf_RF2_3_r0_opc_reg'length);
        else
          rf_RF2_3_r0_load_reg <= '0';
        end if;

        --control signals for IU read ports
        -- control signals for IU read ports

        -- control signals for FU inputs
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 3))) = 4) then
          fu_lsu_in1t_load_reg <= '1';
          fu_lsu_opc_reg <= dst_B1(2 downto 0);
        else
          fu_lsu_in1t_load_reg <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(dst_B1_5(1 downto 0))) = 1) then
          fu_lsu_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (squash_B1_8 = '0' and conv_integer(unsigned(dst_B1_8(1 downto 0))) = 1) then
          fu_lsu_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(3, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (squash_B1_2 = '0' and conv_integer(unsigned(dst_B1_2(1 downto 0))) = 1) then
          fu_lsu_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_lsu_i2_bus_cntrl_reg'length);
        elsif (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 2))) = 22) then
          fu_lsu_in2_load_reg <= '1';
          socket_lsu_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_lsu_i2_bus_cntrl_reg'length);
        else
          fu_lsu_in2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 4))) = 0) then
          fu_alu_in1t_load_reg <= '1';
          fu_alu_opc_reg <= dst_B1(3 downto 0);
        else
          fu_alu_in1t_load_reg <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 2))) = 23) then
          fu_alu_in2_load_reg <= '1';
        else
          fu_alu_in2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 4))) = 1) then
          fu_FU_ALGO_P1_load_reg <= '1';
          fu_FU_ALGO_opc_reg <= dst_B1(3 downto 0);
        else
          fu_FU_ALGO_P1_load_reg <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 2))) = 25) then
          fu_FU_ALGO_P2_load_reg <= '1';
        else
          fu_FU_ALGO_P2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 2))) = 13) then
          fu_FU_CORDIC_P1_load_reg <= '1';
        else
          fu_FU_CORDIC_P1_load_reg <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 2))) = 26) then
          fu_FU_CORDIC_P2_load_reg <= '1';
        else
          fu_FU_CORDIC_P2_load_reg <= '0';
        end if;
        if (squash_B1_1 = '0' and conv_integer(unsigned(dst_B1_1(3 downto 3))) = 0) then
          fu_FU_ALGO_1_P1_load_reg <= '1';
          fu_FU_ALGO_1_opc_reg <= dst_B1_1(2 downto 0);
        else
          fu_FU_ALGO_1_P1_load_reg <= '0';
        end if;
        if (squash_B1_2 = '0' and conv_integer(unsigned(dst_B1_2(1 downto 0))) = 2) then
          fu_FU_ALGO_1_P2_load_reg <= '1';
        else
          fu_FU_ALGO_1_P2_load_reg <= '0';
        end if;
        if (squash_B1_4 = '0' and conv_integer(unsigned(dst_B1_4(3 downto 3))) = 0) then
          fu_FU_ALGO_2_P1_load_reg <= '1';
          fu_FU_ALGO_2_opc_reg <= dst_B1_4(2 downto 0);
        else
          fu_FU_ALGO_2_P1_load_reg <= '0';
        end if;
        if (squash_B1_5 = '0' and conv_integer(unsigned(dst_B1_5(1 downto 0))) = 2) then
          fu_FU_ALGO_2_P2_load_reg <= '1';
        else
          fu_FU_ALGO_2_P2_load_reg <= '0';
        end if;
        if (squash_B1_7 = '0' and conv_integer(unsigned(dst_B1_7(3 downto 3))) = 0) then
          fu_FU_ALGO_3_P1_load_reg <= '1';
          fu_FU_ALGO_3_opc_reg <= dst_B1_7(2 downto 0);
        else
          fu_FU_ALGO_3_P1_load_reg <= '0';
        end if;
        if (squash_B1_8 = '0' and conv_integer(unsigned(dst_B1_8(1 downto 0))) = 2) then
          fu_FU_ALGO_3_P2_load_reg <= '1';
        else
          fu_FU_ALGO_3_P2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 2))) = 10) then
          fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= dst_B1(0 downto 0);
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 2))) = 20) then
          fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= dst_B2(0 downto 0);
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_gcu_i1_bus_cntrl_reg'length);
        elsif (squash_B3 = '0' and conv_integer(unsigned(dst_B3(6 downto 4))) = 5) then
          fu_gcu_pc_load_reg <= '1';
          fu_gcu_opc_reg <= dst_B3(0 downto 0);
          socket_gcu_i1_bus_cntrl_reg <= conv_std_logic_vector(2, socket_gcu_i1_bus_cntrl_reg'length);
        else
          fu_gcu_pc_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 2))) = 12) then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 2))) = 24) then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_gcu_i2_bus_cntrl_reg'length);
        elsif (squash_B3 = '0' and conv_integer(unsigned(dst_B3(6 downto 4))) = 7) then
          fu_gcu_ra_load_reg <= '1';
          socket_gcu_i2_bus_cntrl_reg <= conv_std_logic_vector(2, socket_gcu_i2_bus_cntrl_reg'length);
        else
          fu_gcu_ra_load_reg <= '0';
        end if;
        -- control signals for RF inputs
        if (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 4))) = 4 and true) then
          rf_RF1_w0_load_reg <= '1';
          rf_RF1_w0_opc_reg <= dst_B2(3 downto 0);
          socket_RF_8x32_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_8x32_i1_bus_cntrl_reg'length);
        elsif (squash_B3 = '0' and conv_integer(unsigned(dst_B3(6 downto 4))) = 4 and true) then
          rf_RF1_w0_load_reg <= '1';
          rf_RF1_w0_opc_reg <= dst_B3(3 downto 0);
          socket_RF_8x32_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_8x32_i1_bus_cntrl_reg'length);
        else
          rf_RF1_w0_load_reg <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(dst_B2(6 downto 6))) = 0 and true) then
          rf_RF2_w0_load_reg <= '1';
          rf_RF2_w0_opc_reg <= dst_B2(5 downto 0);
          socket_RF_8x32_1_i1_bus_cntrl_reg <= conv_std_logic_vector(1, socket_RF_8x32_1_i1_bus_cntrl_reg'length);
        elsif (squash_B3 = '0' and conv_integer(unsigned(dst_B3(6 downto 6))) = 0 and true) then
          rf_RF2_w0_load_reg <= '1';
          rf_RF2_w0_opc_reg <= dst_B3(5 downto 0);
          socket_RF_8x32_1_i1_bus_cntrl_reg <= conv_std_logic_vector(0, socket_RF_8x32_1_i1_bus_cntrl_reg'length);
        else
          rf_RF2_w0_load_reg <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(dst_B1_3(6 downto 5))) = 2 and true) then
          rf_RF1_1_w0_load_reg <= '1';
          rf_RF1_1_w0_opc_reg <= dst_B1_3(3 downto 0);
        else
          rf_RF1_1_w0_load_reg <= '0';
        end if;
        if (squash_B1_3 = '0' and conv_integer(unsigned(dst_B1_3(6 downto 6))) = 0 and true) then
          rf_RF2_1_w0_load_reg <= '1';
          rf_RF2_1_w0_opc_reg <= dst_B1_3(5 downto 0);
        else
          rf_RF2_1_w0_load_reg <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(dst_B1_6(6 downto 5))) = 2 and true) then
          rf_RF1_2_w0_load_reg <= '1';
          rf_RF1_2_w0_opc_reg <= dst_B1_6(3 downto 0);
        else
          rf_RF1_2_w0_load_reg <= '0';
        end if;
        if (squash_B1_6 = '0' and conv_integer(unsigned(dst_B1_6(6 downto 6))) = 0 and true) then
          rf_RF2_2_w0_load_reg <= '1';
          rf_RF2_2_w0_opc_reg <= dst_B1_6(5 downto 0);
        else
          rf_RF2_2_w0_load_reg <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(dst_B1_9(6 downto 5))) = 2 and true) then
          rf_RF1_3_r0_load_reg <= '1';
          rf_RF1_3_r0_opc_reg <= dst_B1_9(3 downto 0);
        else
          rf_RF1_3_r0_load_reg <= '0';
        end if;
        if (squash_B1_9 = '0' and conv_integer(unsigned(dst_B1_9(6 downto 6))) = 0 and true) then
          rf_RF2_3_w0_load_reg <= '1';
          rf_RF2_3_w0_opc_reg <= dst_B1_9(5 downto 0);
        else
          rf_RF2_3_w0_load_reg <= '0';
        end if;
      end if;
    end if;
  end process;

  lock_reg_proc : process (clk, rstx)
  begin
    if (rstx = '0') then
      -- Locked during active reset
      post_decode_merged_glock_r <= '1';
    elsif (clk'event and clk = '1') then
      post_decode_merged_glock_r <= post_decode_merged_glock;
    end if;
  end process lock_reg_proc;

  lock_r <= merged_glock_req;
  merged_glock_req <= '0';
  pre_decode_merged_glock <= lock;
  post_decode_merged_glock <= pre_decode_merged_glock or decode_fill_lock_reg;
  locked <= post_decode_merged_glock_r;
  glock(0) <= post_decode_merged_glock; -- to lsu
  glock(1) <= post_decode_merged_glock; -- to alu
  glock(2) <= post_decode_merged_glock; -- to FU_ALGO
  glock(3) <= post_decode_merged_glock; -- to FU_CORDIC
  glock(4) <= post_decode_merged_glock; -- to FU_ALGO_1
  glock(5) <= post_decode_merged_glock; -- to FU_ALGO_2
  glock(6) <= post_decode_merged_glock; -- to FU_ALGO_3
  glock(7) <= post_decode_merged_glock; -- to RF1
  glock(8) <= post_decode_merged_glock; -- to RF2
  glock(9) <= post_decode_merged_glock; -- to RF1_1
  glock(10) <= post_decode_merged_glock; -- to RF2_1
  glock(11) <= post_decode_merged_glock; -- to RF1_2
  glock(12) <= post_decode_merged_glock; -- to RF2_2
  glock(13) <= post_decode_merged_glock; -- to RF1_3
  glock(14) <= post_decode_merged_glock; -- to RF2_3
  glock(15) <= post_decode_merged_glock;

  decode_pipeline_fill_lock: process (clk, rstx)
  begin
    if rstx = '0' then
      decode_fill_lock_reg <= '1';
    elsif clk'event and clk = '1' then
      if lock = '0' then
        decode_fill_lock_reg <= '0';
      end if;
    end if;
  end process decode_pipeline_fill_lock;

end rtl_andor;
