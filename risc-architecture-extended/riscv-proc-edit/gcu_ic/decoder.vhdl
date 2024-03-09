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
    pc_opcode : out std_logic_vector(3 downto 0);
    lock : in std_logic;
    lock_r : out std_logic;
    clk : in std_logic;
    rstx : in std_logic;
    locked : out std_logic;
    simm_B3 : out std_logic_vector(31 downto 0);
    simm_cntrl_B3 : out std_logic_vector(0 downto 0);
    socket_RF_o1_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_GCU_ra_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_RF_o2_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_GCU_apc_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_ALU_i2_bus_cntrl : out std_logic_vector(0 downto 0);
    socket_ALU_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_LSU_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_STDOUT_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_MUL_DIV_o1_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_S1_2_bus_cntrl : out std_logic_vector(2 downto 0);
    socket_S3_1_bus_cntrl : out std_logic_vector(2 downto 0);
    fu_ALU_P1_load : out std_logic;
    fu_ALU_P2_load : out std_logic;
    fu_ALU_opc : out std_logic_vector(4 downto 0);
    fu_LSU_in1t_load : out std_logic;
    fu_LSU_in2_load : out std_logic;
    fu_LSU_in3_load : out std_logic;
    fu_LSU_opc : out std_logic_vector(2 downto 0);
    fu_STDOUT_P1_load : out std_logic;
    fu_STDOUT_P2_load : out std_logic;
    fu_MUL_DIV_in1t_load : out std_logic;
    fu_MUL_DIV_in2_load : out std_logic;
    fu_MUL_DIV_opc : out std_logic_vector(2 downto 0);
    fu_CORDIC_P1_load : out std_logic;
    fu_CORDIC_P2_load : out std_logic;
    fu_COMPARE_AND_ITER_P1_load : out std_logic;
    fu_COMPARE_AND_ITER_P2_load : out std_logic;
    fu_COMPARE_AND_ITER_opc : out std_logic_vector(0 downto 0);
    fu_CU_in_load : out std_logic;
    fu_CU_in2_load : out std_logic;
    rf_RF_t1_load : out std_logic;
    rf_RF_t1_opc : out std_logic_vector(4 downto 0);
    rf_RF_r1_load : out std_logic;
    rf_RF_r1_opc : out std_logic_vector(4 downto 0);
    rf_RF_r2_load : out std_logic;
    rf_RF_r2_opc : out std_logic_vector(4 downto 0);
    lock_req : in std_logic_vector(2 downto 0);
    glock : out std_logic_vector(7 downto 0);
    simm_in : in std_logic_vector(31 downto 0));

end tta0_decoder;

architecture rtl_andor of tta0_decoder is

  -- signals for source, destination and guard fields
  signal move_B0 : std_logic_vector(8 downto 0);
  signal src_B0 : std_logic_vector(5 downto 0);
  signal dst_B0 : std_logic_vector(2 downto 0);
  signal move_B1 : std_logic_vector(11 downto 0);
  signal src_B1 : std_logic_vector(5 downto 0);
  signal dst_B1 : std_logic_vector(5 downto 0);
  signal move_B2 : std_logic_vector(9 downto 0);
  signal src_B2 : std_logic_vector(3 downto 0);
  signal dst_B2 : std_logic_vector(5 downto 0);
  signal move_B3 : std_logic_vector(6 downto 0);
  signal src_B3 : std_logic_vector(1 downto 0);
  signal dst_B3 : std_logic_vector(4 downto 0);

  -- signals for dedicated immediate slots


  -- squash signals
  signal squash_B0 : std_logic;
  signal squash_B1 : std_logic;
  signal squash_B2 : std_logic;
  signal squash_B3 : std_logic;

  -- socket control signals
  signal socket_RF_o1_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_GCU_ra_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_RF_o2_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_GCU_apc_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_ALU_i2_bus_cntrl_reg : std_logic_vector(0 downto 0);
  signal socket_ALU_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_LSU_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_STDOUT_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_MUL_DIV_o1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_S1_2_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal socket_S3_1_bus_cntrl_reg : std_logic_vector(2 downto 0);
  signal simm_B3_reg : std_logic_vector(31 downto 0);
  signal simm_cntrl_B3_reg : std_logic_vector(0 downto 0);

  -- FU control signals
  signal fu_ALU_P1_load_reg : std_logic;
  signal fu_ALU_P2_load_reg : std_logic;
  signal fu_ALU_opc_reg : std_logic_vector(4 downto 0);
  signal fu_LSU_in1t_load_reg : std_logic;
  signal fu_LSU_in2_load_reg : std_logic;
  signal fu_LSU_in3_load_reg : std_logic;
  signal fu_LSU_opc_reg : std_logic_vector(2 downto 0);
  signal fu_STDOUT_P1_load_reg : std_logic;
  signal fu_STDOUT_P2_load_reg : std_logic;
  signal fu_MUL_DIV_in1t_load_reg : std_logic;
  signal fu_MUL_DIV_in2_load_reg : std_logic;
  signal fu_MUL_DIV_opc_reg : std_logic_vector(2 downto 0);
  signal fu_CORDIC_P1_load_reg : std_logic;
  signal fu_CORDIC_P2_load_reg : std_logic;
  signal fu_COMPARE_AND_ITER_P1_load_reg : std_logic;
  signal fu_COMPARE_AND_ITER_P2_load_reg : std_logic;
  signal fu_COMPARE_AND_ITER_opc_reg : std_logic_vector(0 downto 0);
  signal fu_CU_pc_load_reg : std_logic;
  signal fu_CU_in_load_reg : std_logic;
  signal fu_CU_in2_load_reg : std_logic;
  signal fu_CU_ra_load_reg : std_logic;
  signal fu_CU_opc_reg : std_logic_vector(3 downto 0);

  -- RF control signals
  signal rf_RF_t1_load_reg : std_logic;
  signal rf_RF_t1_opc_reg : std_logic_vector(4 downto 0);
  signal rf_RF_r1_load_reg : std_logic;
  signal rf_RF_r1_opc_reg : std_logic_vector(4 downto 0);
  signal rf_RF_r2_load_reg : std_logic;
  signal rf_RF_r2_opc_reg : std_logic_vector(4 downto 0);

  signal merged_glock_req : std_logic;
  signal pre_decode_merged_glock : std_logic;
  signal post_decode_merged_glock : std_logic;
  signal post_decode_merged_glock_r : std_logic;

  signal decode_fill_lock_reg : std_logic;
begin

  -- dismembering of instruction
  process (instructionword)
  begin --process
    move_B0 <= instructionword(9-1 downto 0);
    src_B0 <= instructionword(8 downto 3);
    dst_B0 <= instructionword(2 downto 0);
    move_B1 <= instructionword(21-1 downto 9);
    src_B1 <= instructionword(20 downto 15);
    dst_B1 <= instructionword(14 downto 9);
    move_B2 <= instructionword(31-1 downto 21);
    src_B2 <= instructionword(30 downto 27);
    dst_B2 <= instructionword(26 downto 21);
    move_B3 <= instructionword(38-1 downto 31);
    src_B3 <= instructionword(37 downto 36);
    dst_B3 <= instructionword(35 downto 31);

  end process;

  -- map control registers to outputs
  fu_ALU_P1_load <= fu_ALU_P1_load_reg;
  fu_ALU_P2_load <= fu_ALU_P2_load_reg;
  fu_ALU_opc <= fu_ALU_opc_reg;

  fu_LSU_in1t_load <= fu_LSU_in1t_load_reg;
  fu_LSU_in2_load <= fu_LSU_in2_load_reg;
  fu_LSU_in3_load <= fu_LSU_in3_load_reg;
  fu_LSU_opc <= fu_LSU_opc_reg;

  fu_STDOUT_P1_load <= fu_STDOUT_P1_load_reg;
  fu_STDOUT_P2_load <= fu_STDOUT_P2_load_reg;

  fu_MUL_DIV_in1t_load <= fu_MUL_DIV_in1t_load_reg;
  fu_MUL_DIV_in2_load <= fu_MUL_DIV_in2_load_reg;
  fu_MUL_DIV_opc <= fu_MUL_DIV_opc_reg;

  fu_CORDIC_P1_load <= fu_CORDIC_P1_load_reg;
  fu_CORDIC_P2_load <= fu_CORDIC_P2_load_reg;

  fu_COMPARE_AND_ITER_P1_load <= fu_COMPARE_AND_ITER_P1_load_reg;
  fu_COMPARE_AND_ITER_P2_load <= fu_COMPARE_AND_ITER_P2_load_reg;
  fu_COMPARE_AND_ITER_opc <= fu_COMPARE_AND_ITER_opc_reg;

  ra_load <= fu_CU_ra_load_reg;
  pc_load <= fu_CU_pc_load_reg;
  pc_opcode <= fu_CU_opc_reg;
  fu_CU_in_load <= fu_CU_in_load_reg;
  fu_CU_in2_load <= fu_CU_in2_load_reg;
  fu_CU_in_load <= fu_CU_in_load_reg;
  fu_CU_in2_load <= fu_CU_in2_load_reg;
  rf_RF_t1_load <= rf_RF_t1_load_reg;
  rf_RF_t1_opc <= rf_RF_t1_opc_reg;
  rf_RF_r1_load <= rf_RF_r1_load_reg;
  rf_RF_r1_opc <= rf_RF_r1_opc_reg;
  rf_RF_r2_load <= rf_RF_r2_load_reg;
  rf_RF_r2_opc <= rf_RF_r2_opc_reg;
  socket_RF_o1_bus_cntrl <= socket_RF_o1_bus_cntrl_reg;
  socket_GCU_ra_o1_bus_cntrl <= socket_GCU_ra_o1_bus_cntrl_reg;
  socket_RF_o2_bus_cntrl <= socket_RF_o2_bus_cntrl_reg;
  socket_GCU_apc_o1_bus_cntrl <= socket_GCU_apc_o1_bus_cntrl_reg;
  socket_ALU_i2_bus_cntrl <= socket_ALU_i2_bus_cntrl_reg;
  socket_ALU_o1_bus_cntrl <= socket_ALU_o1_bus_cntrl_reg;
  socket_LSU_o1_bus_cntrl <= socket_LSU_o1_bus_cntrl_reg;
  socket_STDOUT_o1_bus_cntrl <= socket_STDOUT_o1_bus_cntrl_reg;
  socket_MUL_DIV_o1_bus_cntrl <= socket_MUL_DIV_o1_bus_cntrl_reg;
  socket_S1_2_bus_cntrl <= socket_S1_2_bus_cntrl_reg;
  socket_S3_1_bus_cntrl <= socket_S3_1_bus_cntrl_reg;
  simm_cntrl_B3 <= simm_cntrl_B3_reg;
  simm_B3 <= simm_in;

  -- generate signal squash_B0
  squash_B0 <= '0';
  -- generate signal squash_B1
  squash_B1 <= '0';
  -- generate signal squash_B2
  squash_B2 <= '0';
  -- generate signal squash_B3
  squash_B3 <= '0';



  -- main decoding process
  process (clk, rstx)
  begin
    if (rstx = '0') then
      socket_RF_o1_bus_cntrl_reg <= (others => '0');
      socket_GCU_ra_o1_bus_cntrl_reg <= (others => '0');
      socket_RF_o2_bus_cntrl_reg <= (others => '0');
      socket_GCU_apc_o1_bus_cntrl_reg <= (others => '0');
      socket_ALU_i2_bus_cntrl_reg <= (others => '0');
      socket_ALU_o1_bus_cntrl_reg <= (others => '0');
      socket_LSU_o1_bus_cntrl_reg <= (others => '0');
      socket_STDOUT_o1_bus_cntrl_reg <= (others => '0');
      socket_MUL_DIV_o1_bus_cntrl_reg <= (others => '0');
      socket_S1_2_bus_cntrl_reg <= (others => '0');
      socket_S3_1_bus_cntrl_reg <= (others => '0');
      simm_B3_reg <= (others => '0');
      simm_cntrl_B3_reg <= (others => '0');
      fu_ALU_opc_reg <= (others => '0');
      fu_LSU_opc_reg <= (others => '0');
      fu_MUL_DIV_opc_reg <= (others => '0');
      fu_COMPARE_AND_ITER_opc_reg <= (others => '0');
      fu_CU_opc_reg <= (others => '0');
      rf_RF_t1_opc_reg <= (others => '0');
      rf_RF_r1_opc_reg <= (others => '0');
      rf_RF_r2_opc_reg <= (others => '0');

      fu_ALU_P1_load_reg <= '0';
      fu_ALU_P2_load_reg <= '0';
      fu_LSU_in1t_load_reg <= '0';
      fu_LSU_in2_load_reg <= '0';
      fu_LSU_in3_load_reg <= '0';
      fu_STDOUT_P1_load_reg <= '0';
      fu_STDOUT_P2_load_reg <= '0';
      fu_MUL_DIV_in1t_load_reg <= '0';
      fu_MUL_DIV_in2_load_reg <= '0';
      fu_CORDIC_P1_load_reg <= '0';
      fu_CORDIC_P2_load_reg <= '0';
      fu_COMPARE_AND_ITER_P1_load_reg <= '0';
      fu_COMPARE_AND_ITER_P2_load_reg <= '0';
      fu_CU_pc_load_reg <= '0';
      fu_CU_in_load_reg <= '0';
      fu_CU_in2_load_reg <= '0';
      fu_CU_ra_load_reg <= '0';
      rf_RF_t1_load_reg <= '0';
      rf_RF_r1_load_reg <= '0';
      rf_RF_r2_load_reg <= '0';


    elsif (clk'event and clk = '1') then -- rising clock edge
    if (pre_decode_merged_glock = '0') then

        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 5))) = 0) then
          socket_RF_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 17) then
          socket_GCU_ra_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_GCU_ra_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 17) then
          socket_GCU_ra_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_GCU_ra_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 1) then
          socket_GCU_ra_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_GCU_ra_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 5))) = 0) then
          socket_RF_o2_bus_cntrl_reg(0) <= '1';
        else
          socket_RF_o2_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 18) then
          socket_GCU_apc_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_GCU_apc_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 18) then
          socket_GCU_apc_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_GCU_apc_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 2) then
          socket_GCU_apc_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_GCU_apc_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 19) then
          socket_ALU_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 19) then
          socket_ALU_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 3) then
          socket_ALU_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_ALU_o1_bus_cntrl_reg(2) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 20) then
          socket_LSU_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_LSU_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 20) then
          socket_LSU_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_LSU_o1_bus_cntrl_reg(2) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 4) then
          socket_LSU_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_LSU_o1_bus_cntrl_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 21) then
          socket_STDOUT_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_STDOUT_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 21) then
          socket_STDOUT_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_STDOUT_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 5) then
          socket_STDOUT_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_STDOUT_o1_bus_cntrl_reg(2) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 22) then
          socket_MUL_DIV_o1_bus_cntrl_reg(0) <= '1';
        else
          socket_MUL_DIV_o1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 22) then
          socket_MUL_DIV_o1_bus_cntrl_reg(1) <= '1';
        else
          socket_MUL_DIV_o1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 6) then
          socket_MUL_DIV_o1_bus_cntrl_reg(2) <= '1';
        else
          socket_MUL_DIV_o1_bus_cntrl_reg(2) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 23) then
          socket_S1_2_bus_cntrl_reg(0) <= '1';
        else
          socket_S1_2_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 23) then
          socket_S1_2_bus_cntrl_reg(1) <= '1';
        else
          socket_S1_2_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 7) then
          socket_S1_2_bus_cntrl_reg(2) <= '1';
        else
          socket_S1_2_bus_cntrl_reg(2) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 1))) = 24) then
          socket_S3_1_bus_cntrl_reg(0) <= '1';
        else
          socket_S3_1_bus_cntrl_reg(0) <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 1))) = 24) then
          socket_S3_1_bus_cntrl_reg(1) <= '1';
        else
          socket_S3_1_bus_cntrl_reg(1) <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(src_B2(3 downto 0))) = 8) then
          socket_S3_1_bus_cntrl_reg(2) <= '1';
        else
          socket_S3_1_bus_cntrl_reg(2) <= '0';
        end if;
        -- bus control signals for short immediate sockets
        if (squash_B3 = '0' and conv_integer(unsigned(src_B3(1 downto 1))) = 0) then
          simm_cntrl_B3_reg(0) <= '1';
        simm_B3_reg <= tce_sxt(src_B3(0 downto 0), simm_B3_reg'length);
        else
          simm_cntrl_B3_reg(0) <= '0';
        end if;
        -- data control signals for output sockets connected to FUs
        -- control signals for RF read ports
        if (squash_B1 = '0' and conv_integer(unsigned(src_B1(5 downto 5))) = 0 and true) then
          rf_RF_r1_load_reg <= '1';
          rf_RF_r1_opc_reg <= tce_ext(src_B1(4 downto 0), rf_RF_r1_opc_reg'length);
        else
          rf_RF_r1_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(src_B0(5 downto 5))) = 0 and true) then
          rf_RF_r2_load_reg <= '1';
          rf_RF_r2_opc_reg <= tce_ext(src_B0(4 downto 0), rf_RF_r2_opc_reg'length);
        else
          rf_RF_r2_load_reg <= '0';
        end if;

        --control signals for IU read ports
        -- control signals for IU read ports

        -- control signals for FU inputs
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 5))) = 0) then
          fu_ALU_P1_load_reg <= '1';
          fu_ALU_opc_reg <= dst_B1(4 downto 0);
        else
          fu_ALU_P1_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(dst_B0(2 downto 0))) = 2) then
          fu_ALU_P2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(1, socket_ALU_i2_bus_cntrl_reg'length);
        elsif (squash_B3 = '0' and conv_integer(unsigned(dst_B3(4 downto 2))) = 5) then
          fu_ALU_P2_load_reg <= '1';
          socket_ALU_i2_bus_cntrl_reg <= conv_std_logic_vector(0, socket_ALU_i2_bus_cntrl_reg'length);
        else
          fu_ALU_P2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 3))) = 4) then
          fu_LSU_in1t_load_reg <= '1';
          fu_LSU_opc_reg <= dst_B1(2 downto 0);
        else
          fu_LSU_in1t_load_reg <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(dst_B3(4 downto 2))) = 6) then
          fu_LSU_in2_load_reg <= '1';
        else
          fu_LSU_in2_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(dst_B0(2 downto 0))) = 3) then
          fu_LSU_in3_load_reg <= '1';
        else
          fu_LSU_in3_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 1))) = 27) then
          fu_STDOUT_P1_load_reg <= '1';
        else
          fu_STDOUT_P1_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(dst_B0(2 downto 0))) = 4) then
          fu_STDOUT_P2_load_reg <= '1';
        else
          fu_STDOUT_P2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 3))) = 5) then
          fu_MUL_DIV_in1t_load_reg <= '1';
          fu_MUL_DIV_opc_reg <= dst_B1(2 downto 0);
        else
          fu_MUL_DIV_in1t_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(dst_B0(2 downto 0))) = 5) then
          fu_MUL_DIV_in2_load_reg <= '1';
        else
          fu_MUL_DIV_in2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 1))) = 28) then
          fu_CORDIC_P1_load_reg <= '1';
        else
          fu_CORDIC_P1_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(dst_B0(2 downto 0))) = 6) then
          fu_CORDIC_P2_load_reg <= '1';
        else
          fu_CORDIC_P2_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 1))) = 24) then
          fu_COMPARE_AND_ITER_P1_load_reg <= '1';
          fu_COMPARE_AND_ITER_opc_reg <= dst_B1(0 downto 0);
        else
          fu_COMPARE_AND_ITER_P1_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(dst_B0(2 downto 0))) = 7) then
          fu_COMPARE_AND_ITER_P2_load_reg <= '1';
        else
          fu_COMPARE_AND_ITER_P2_load_reg <= '0';
        end if;
        if (squash_B3 = '0' and conv_integer(unsigned(dst_B3(4 downto 4))) = 0) then
          fu_CU_pc_load_reg <= '1';
          fu_CU_opc_reg <= dst_B3(3 downto 0);
        else
          fu_CU_pc_load_reg <= '0';
        end if;
        if (squash_B1 = '0' and conv_integer(unsigned(dst_B1(5 downto 1))) = 26) then
          fu_CU_in_load_reg <= '1';
        else
          fu_CU_in_load_reg <= '0';
        end if;
        if (squash_B0 = '0' and conv_integer(unsigned(dst_B0(2 downto 0))) = 1) then
          fu_CU_in2_load_reg <= '1';
        else
          fu_CU_in2_load_reg <= '0';
        end if;
        if (squash_B2 = '0' and conv_integer(unsigned(dst_B2(5 downto 4))) = 3) then
          fu_CU_ra_load_reg <= '1';
        else
          fu_CU_ra_load_reg <= '0';
        end if;
        -- control signals for RF inputs
        if (squash_B2 = '0' and conv_integer(unsigned(dst_B2(5 downto 5))) = 0 and true) then
          rf_RF_t1_load_reg <= '1';
          rf_RF_t1_opc_reg <= dst_B2(4 downto 0);
        else
          rf_RF_t1_load_reg <= '0';
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
  merged_glock_req <= lock_req(0) or lock_req(1) or lock_req(2);
  pre_decode_merged_glock <= lock or merged_glock_req;
  post_decode_merged_glock <= pre_decode_merged_glock or decode_fill_lock_reg;
  locked <= post_decode_merged_glock_r;
  glock(0) <= post_decode_merged_glock; -- to ALU
  glock(1) <= post_decode_merged_glock; -- to LSU
  glock(2) <= post_decode_merged_glock; -- to STDOUT
  glock(3) <= post_decode_merged_glock; -- to MUL_DIV
  glock(4) <= post_decode_merged_glock; -- to CORDIC
  glock(5) <= post_decode_merged_glock; -- to COMPARE_AND_ITER
  glock(6) <= post_decode_merged_glock; -- to RF
  glock(7) <= post_decode_merged_glock;

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
