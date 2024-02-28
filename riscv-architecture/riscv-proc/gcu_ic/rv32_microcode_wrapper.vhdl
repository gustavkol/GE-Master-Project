-- Copyright (c) 2021-2022 Tampere University.
--
-- This file is part of OpenASIP.
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

-- Authors: Kari Hepola 2021-2022
-- Description: Wrapper around the RISC-V microcode

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
use work.tta0_globals.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
use IEEE.math_real.all;


entity rv32_microcode_wrapper is
  port (
    clk  : in std_logic;
    rstx : in std_logic;
    instruction_in  : in  std_logic_vector(32 - 1 downto 0);
    instruction_out : out std_logic_vector(INSTRUCTIONWIDTH - 1 downto 0);
    simm_out         : out std_logic_vector(32 - 1 downto 0);
    ifetch_stall : out std_logic;
    rv_jump : out std_logic;
    rv_auipc : out std_logic;
    rv_offset : out std_logic_vector(31 downto 0);
    glock_in        : in  std_logic);

end rv32_microcode_wrapper;

architecture rtl of rv32_microcode_wrapper is

  component rv32_microcode is
      port(
            clk            : in std_logic;
              rstx           : in std_logic;
              glock_in       : in std_logic;
              data_hazard_in : in std_logic;
              rs1_hazard_in  : in std_logic;
              rs2_hazard_in  : in std_logic;
              halt           : in std_logic;
            
          fu_opcode_in  : in  std_logic_vector(17 - 1 downto 0);
          moves_out     : out std_logic_vector(INSTRUCTIONWIDTH - 1 downto 0));
  end component;

  constant op_lat_width_c : integer := 2;
  constant rs1_bus_width_c : integer := 12;
  constant rs2_bus_width_c : integer := 9;
  constant rd_bus_width_c : integer := 9;
  constant simm_bus_width_c : integer := 7;

  constant rs1_bus_start_c : integer := 9;
  constant rs2_bus_start_c : integer := 0;
  constant rd_bus_start_c : integer := 21;
  constant simm_bus_start_c : integer := 30;

  constant rs1_RF_start_c : integer := 6;
  constant rs2_RF_start_c : integer := 3;
  constant rd_RF_start_c : integer := 0;
  constant RF_width_c : integer := 5;

  constant rd_nop_c : std_logic_vector(rd_bus_width_c-1 downto 0) := "000100000";

  signal opcode : std_logic_vector(6 downto 0);

  type opcode_encodings is array (0 to 2) of std_logic_vector(6 downto 0);

  constant frame_r_c : opcode_encodings := ("0110011", "0001011", "0000000");
  constant frame_i_c : opcode_encodings := ("0010011", "0000011", "1100111");
  constant frame_s_c : opcode_encodings := ("0100011", "0000000", "0000000");
  constant frame_b_c : opcode_encodings := ("1100011", "0000000", "0000000");
  constant frame_u_c : opcode_encodings := ("0010111", "0110111", "0000000");
  constant frame_j_c : opcode_encodings := ("1101111", "0000000", "0000000");

  signal is_r_frame  : std_logic;
  signal is_i_frame  : std_logic;
  signal is_s_frame  : std_logic;
  signal is_b_frame  : std_logic;
  signal is_u_frame  : std_logic;
  signal is_j_frame  : std_logic;

  signal is_s_frame_r  : std_logic;
  signal is_b_frame_r  : std_logic;

  signal i_type_simm : std_logic_vector(11 downto 0);
  signal s_type_simm : std_logic_vector(11 downto 0);
  signal b_type_simm : std_logic_vector(11 downto 0);
  signal u_type_simm : std_logic_vector(19 downto 0);
  signal j_type_simm : std_logic_vector(19 downto 0);

  signal imm : std_logic_vector(32 - 1 downto 0);

  signal simm_r : std_logic_vector(32 - 1 downto 0);

  signal fu_opcode : std_logic_vector(17 - 1 downto 0);

  signal funct3 : std_logic_vector(2 downto 0);
  signal funct7 : std_logic_vector(6 downto 0);

  signal translated_instruction : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);

  signal moves : std_logic_vector(INSTRUCTIONWIDTH-1 downto 0);

  signal rs1_move : std_logic_vector(rs1_bus_width_c-1 downto 0);
  signal rs2_move : std_logic_vector(rs2_bus_width_c-1 downto 0);
  signal rd_move : std_logic_vector(rd_bus_width_c-1 downto 0);
  signal simm_move : std_logic_vector(simm_bus_width_c-1 downto 0);

  signal rd_bus_move : std_logic_vector(rd_bus_width_c-1 downto 0);

  signal rs1_RF_index : std_logic_vector(RF_width_c-1 downto 0);
  signal rs2_RF_index : std_logic_vector(RF_width_c-1 downto 0);
  signal rd_RF_index : std_logic_vector(RF_width_c-1 downto 0);

  signal rs1_RF_index_r : std_logic_vector(RF_width_c-1 downto 0);
  signal rs2_RF_index_r : std_logic_vector(RF_width_c-1 downto 0);
  signal rd_RF_index_r  : std_logic_vector(RF_width_c-1 downto 0);

  signal rd_move_r : std_logic_vector(rd_bus_width_c-1 downto 0);

  signal instruction : std_logic_vector(32 - 1 downto 0);

  signal is_control_flow_op : std_logic;

  signal is_control_flow_op_r : std_logic;

  signal bubble : std_logic;

  signal data_hazard : std_logic;
  signal data_hazard_r : std_logic;


  signal stall_ifetch : std_logic;
  signal stall_ifetch_r : std_logic;

  type state_type is (EXECUTE, HANDLE_CONTROL_FLOW_OP, FILL_INSTRUCTION_PIPELINE ,HANDLE_OP_LATENCY);

  signal CS : state_type;
  signal NS : state_type;

  signal rs1_hazard : std_logic;
  signal rs2_hazard : std_logic;

  signal op_latency_stall : std_logic;
  signal op_latency_stall_r : std_logic;
  signal op_latency_counter_r : unsigned(op_lat_width_c-1 downto 0);
  signal op_latency : unsigned(op_lat_width_c-1 downto 0);

  signal rv_jump_wire : std_logic;

  signal filling_instruction_pipeline : std_logic;

  signal rv_auipc_wire : std_logic;

  signal handle_control_flow_ns : std_logic;

  signal handling_control_op : std_logic;


  begin

  rv_auipc_wire <= '1' when (opcode = frame_u_c(0) and filling_instruction_pipeline = '0') else '0';
  rv_auipc <= rv_auipc_wire;

  rv_jump <= rv_jump_wire;

  rv_offset <= imm;

  rv_jump_wire <= '1' when (opcode = "1101111" and filling_instruction_pipeline = '0') else '0';

  instruction <= instruction_in;

  is_control_flow_op <= '1' when (is_b_frame = '1' or is_j_frame = '1' or opcode = frame_i_c(2))
  else '0';

  ifetch_stall <= stall_ifetch;

  process(clk, rstx)
  begin
    if(rstx = '0') then
      op_latency_counter_r <= to_unsigned(0,op_lat_width_c);
    elsif(clk'event and clk = '1') then
      if(glock_in = '0') then
        if(op_latency_stall = '1' and filling_instruction_pipeline = '0' ) then
          op_latency_counter_r <= op_latency_counter_r + to_unsigned(1,op_lat_width_c);
        else
          op_latency_counter_r <= to_unsigned(0,op_lat_width_c);
        end if;
      end if;
    end if;
  end process;

  process(op_latency_counter_r, op_latency)
  begin
    if(op_latency_counter_r = op_latency) then
      op_latency_stall <= '0';
    else
      op_latency_stall <= '1';
    end if;
  end process;

  fsm_cp : process(rv_auipc_wire, rv_jump_wire, rd_move, is_control_flow_op, glock_in, CS ,  op_latency_stall) 
  begin
    NS <= EXECUTE;
    stall_ifetch <= '0';
    bubble <= '0';
    rd_bus_move <= rd_move;
    filling_instruction_pipeline <= '0';
    handle_control_flow_ns <= '0';
    handling_control_op <= '0';
    CASE(CS) is 
          

      when EXECUTE =>
        if(glock_in = '1') then
            bubble <= '1';
            stall_ifetch <= '0';
            NS <= EXECUTE;
          elsif (rv_jump_wire = '1' or rv_auipc_wire = '1') then
             rd_bus_move <= rd_move;
             stall_ifetch <= '0';
             bubble <= '1';
             if rv_auipc_wire = '0' then
               NS <= FILL_INSTRUCTION_PIPELINE;
             end if;
          elsif(op_latency_stall = '1') then
            bubble <= '0';
            NS <= HANDLE_OP_LATENCY;
            stall_ifetch <= '1';
            rd_bus_move <= rd_nop_c;
          elsif (is_control_flow_op = '1') then
            bubble <= '0';
            stall_ifetch <= '1';
            NS <= HANDLE_CONTROL_FLOW_OP;
            handle_control_flow_ns <= '1';
          else
            bubble <= '0';
            stall_ifetch <= '0';
            NS <= EXECUTE;
          end if;
        
        when HANDLE_OP_LATENCY =>
          bubble <= '1';
          stall_ifetch <= '1';
          rd_bus_move <= rd_nop_c;
          NS <= HANDLE_OP_LATENCY;
          if(op_latency_stall = '0') then
            NS <= EXECUTE;
            stall_ifetch <= '0';
            rd_bus_move <= rd_move;
          end if;

      when HANDLE_CONTROL_FLOW_OP =>
        bubble <= '1';
        rd_bus_move <= rd_nop_c;
        NS <= FILL_INSTRUCTION_PIPELINE;
        stall_ifetch <= '0';
        handling_control_op <= '1';
      
      when FILL_INSTRUCTION_PIPELINE =>
        filling_instruction_pipeline <= '1';
        bubble <= '1';
        rd_bus_move <= rd_nop_c;
        stall_ifetch <= '0';
        NS <= EXECUTE;
      
    
    end case;
  end process fsm_cp;


  process(clk, rstx)
  begin
    if(rstx = '0') then
      data_hazard_r <= '0';
      is_control_flow_op_r <= '0';
      stall_ifetch_r <= '0';
      simm_r <= (others => '0');
      CS <= EXECUTE;
      op_latency_stall_r <= '0';
    elsif(clk'event and clk = '1') then
      if(glock_in = '0') then
        is_control_flow_op_r <= is_control_flow_op;
        data_hazard_r <= data_hazard;
        stall_ifetch_r <= stall_ifetch;
        simm_r <= imm;
        op_latency_stall_r <= op_latency_stall;
        CS <= NS;
      end if;
    end if;
  end process;

  process(clk, rstx)
  begin
    if(rstx = '0') then
      is_s_frame_r <= '0';
      is_b_frame_r <= '0';
    elsif(clk'event and clk = '1') then
      if(glock_in = '0' and filling_instruction_pipeline = '0') then
        is_s_frame_r <= is_s_frame;
        is_b_frame_r <= is_b_frame;
      end if;
    end if;
  end process;

  process(rs1_RF_index, rs2_RF_index, rd_RF_index_r, is_s_frame_r, is_b_frame_r, is_i_frame, is_u_frame, is_j_frame, CS )
  begin
    rs1_hazard <= '0';
    rs2_hazard <= '0';
    if(CS = EXECUTE) then
      if(unsigned(rd_RF_index_r) = 0) then
        data_hazard <= '0';
      elsif(is_s_frame_r = '1' or is_b_frame_r = '1') then
        data_hazard <= '0';
      elsif(is_i_frame = '1' and rs1_RF_index /= rd_RF_index_r) then
        data_hazard <= '0';
      elsif(is_u_frame = '1' or is_j_frame = '1') then
        data_hazard <= '0';
      
      elsif(rs1_RF_index = rd_RF_index_r or rs2_RF_index = rd_RF_index_r) then
        data_hazard <= '1';
        if(rs1_RF_index = rd_RF_index_r) then
          rs1_hazard <= '1';
        end if;
        if(rs2_RF_index = rd_RF_index_r) then
          rs2_hazard <= '1';
        end if;
      else
        data_hazard <= '0';
      end if;
    else
        data_hazard <= '0';
    end if;
  end process;
        



  process (instruction, opcode)
  begin
    opcode <= instruction(6 downto 0);
    funct3 <= instruction(14 downto 12);
    funct7 <= instruction(31 downto 25);

    --Route LUI through ALU
    if opcode /= frame_u_c(1) then
      rs1_RF_index <= instruction(19 downto 15);
    else 
      rs1_RF_index <= (others => '0');
    end if;
    rs2_RF_index <= instruction(24 downto 20);
    rd_RF_index <= instruction(11 downto 7);
  end process;

  simm_out <= simm_r;

  fu_opcode <= funct7 & funct3 & opcode;

  rv32_microcode_i : rv32_microcode
  port map(
    clk              => clk,
    rstx             => rstx,
    glock_in         => glock_in,
    data_hazard_in   => data_hazard,
    rs1_hazard_in    => rs1_hazard,
    rs2_hazard_in    => rs2_hazard,
    halt             => filling_instruction_pipeline,
    fu_opcode_in => fu_opcode,
    moves_out    => moves);

  process (instruction)
  begin --process
    i_type_simm <= instruction(31 downto 20);
    s_type_simm <= instruction(31 downto 25) & instruction(11 downto 7);
    b_type_simm <= instruction(31 downto 31) & instruction(7 downto 7) & instruction(30 downto 25) &  instruction(11 downto 8);
    u_type_simm <= instruction(31 downto 12);
    j_type_simm <= instruction(31 downto 31) & instruction(19 downto 12) & instruction(20 downto 20) & instruction(30 downto 21);
  end process;

  process (clk, rstx)
  begin
    if(rstx = '0') then
       rs1_RF_index_r <= (others => '0');
       rs2_RF_index_r <= (others => '0');
       rd_RF_index_r  <= (others => '0');
    elsif(clk'event and clk='1') then
      if(glock_in = '0' and (bubble = '0' or rv_jump_wire = '1' or rv_auipc_wire = '1')) then
        rs1_RF_index_r <= rs1_RF_index;
        rs2_RF_index_r <= rs2_RF_index;
        rd_RF_index_r  <= rd_RF_index;
      end if;
    end if;
  end process;

  process (clk, rstx)
  begin
    if(rstx = '0') then
      --NOP
      rd_move_r <= rd_nop_c;
    elsif(clk'event and clk='1') then
      if(glock_in = '0') then
        rd_move_r <= rd_bus_move;
      end if;
    end if;
  end process;

  process(i_type_simm, s_type_simm, b_type_simm, u_type_simm, j_type_simm, is_i_frame, is_s_frame, is_b_frame, is_u_frame)
  begin
    if(is_i_frame = '1') then
      imm <= std_logic_vector(resize(signed(i_type_simm), 32));
    elsif(is_s_frame = '1') then
      imm <= std_logic_vector(resize(signed(s_type_simm), 32));
    elsif(is_b_frame = '1') then
      imm <= std_logic_vector(shift_left(resize(signed(b_type_simm), 32), 1));
    elsif(is_u_frame = '1') then
      imm <= std_logic_vector(shift_left(resize(signed(u_type_simm), 32), 12));
    else
      imm <= std_logic_vector(shift_left(resize(signed(j_type_simm), 32),1));
    end if;
  end process;

  process (opcode)
  begin
    is_r_frame <= '0';
    is_i_frame <= '0';
    is_s_frame <= '0';
    is_b_frame <= '0';
    is_u_frame <= '0';
    is_j_frame <= '0';
    if(frame_r_c(0) = opcode or frame_r_c(1) = opcode) then
      is_r_frame <= '1';
    elsif(frame_i_c(0) = opcode or frame_i_c(1) = opcode or frame_i_c(2) = opcode) then
      is_i_frame <= '1';
    elsif(frame_s_c(0) = opcode) then
      is_s_frame <= '1';
    elsif(frame_b_c(0) = opcode) then
      is_b_frame <= '1';
    elsif(frame_u_c(0) = opcode or frame_u_c(1) = opcode) then
      is_u_frame <= '1';
    elsif(frame_j_c(0) = opcode) then
      is_j_frame <= '1';
    end if;
  end process;

  process(moves, rd_RF_index, is_b_frame, is_s_frame)
  begin
    rd_move <= moves(rd_bus_start_c+rd_bus_width_c-1 downto rd_bus_start_c);
    --Don't assign when LUI or operation that does not have WB
    if(is_b_frame = '0' and is_s_frame = '0') then
      rd_move(rd_RF_start_c+RF_width_c-1 downto rd_RF_start_c) <= rd_RF_index;
    end if;
  end process;

  --Always map the RF index to the instruction, pass the simm value straight pass
  --the decoder and control it with the src code
  process (moves, rs1_RF_index, rs2_RF_index, is_r_frame, is_s_frame, is_b_frame, is_i_frame, rs1_hazard, rs2_hazard)
  begin
    rs1_move <= moves(rs1_bus_start_c+rs1_bus_width_c-1 downto rs1_bus_start_c);
    rs2_move <= moves(rs2_bus_start_c+rs2_bus_width_c-1 downto rs2_bus_start_c);
    simm_move <= moves(simm_bus_start_c + simm_bus_width_c - 1 downto simm_bus_start_c);

    if((is_r_frame = '1' or is_s_frame = '1' or is_b_frame = '1' or is_i_frame = '1') and rs1_hazard = '0') then
        rs1_move(rs1_RF_start_c+RF_width_c-1 downto rs1_RF_start_c) <= rs1_RF_index;
    end if;

    if((is_r_frame = '1' or is_s_frame = '1' or is_b_frame = '1') and rs2_hazard = '0') then
      rs2_move(rs2_RF_start_c+RF_width_c-1 downto rs2_RF_start_c) <= rs2_RF_index;
    end if;
  end process;

  process(rs1_move, rs2_move, rd_move_r, simm_move, bubble)
  begin
    --Assign to NOP by default so unused busses are idle
    translated_instruction <= "1010000000100000100000100000100000000";
    translated_instruction(rd_bus_start_c+rd_bus_width_c-1 downto rd_bus_start_c) <= rd_move_r;
    if(bubble = '0') then
      translated_instruction(rs1_bus_start_c+rs1_bus_width_c-1 downto rs1_bus_start_c) <= rs1_move;
      translated_instruction(rs2_bus_start_c+rs2_bus_width_c-1 downto rs2_bus_start_c) <= rs2_move;
      translated_instruction(simm_bus_start_c + simm_bus_width_c - 1 downto simm_bus_start_c) <= simm_move;
    end if;
  end process;

  process(fu_opcode)
  begin
    if fu_opcode(10-1 downto 0) =  "0010000011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(10-1 downto 0) =  "0100000011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(10-1 downto 0) =  "0000000011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(10-1 downto 0) =  "1010000011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(10-1 downto 0) =  "1000000011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000011000110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000011010110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000010000110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000010010110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000010100110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000010110110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000011100110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    elsif fu_opcode(17-1 downto 0) =  "00000011110110011" then
       op_latency <= to_unsigned(1,op_lat_width_c);
    else
      op_latency <= to_unsigned(0,op_lat_width_c);
    end if;
  end process;
  

  instruction_out <= translated_instruction;

  --pragma translate_off

  Detect_simulation_end : process
  begin
    --Wait for infinite loop
    wait until clk'event and clk = '1' and  filling_instruction_pipeline = '0' and unsigned(instruction) = to_unsigned(111, instruction'length);
    wait until clk'event and clk = '1';
    assert false report "Simulation Finished!" severity failure;
  end process;

  process(clk, rstx)
  variable instruction_counter_v : integer := 0;
  begin
    if rstx = '0' then
      instruction_counter_v := 0;
    elsif clk'event and clk = '1' then
      if bubble = '0' or rv_jump_wire = '1' or rv_auipc_wire = '1' then
        instruction_counter_v := instruction_counter_v + 1;
      end if;
    end if;
  end process;

  file_output : process

  file rv_instruction_trace : text;
  file cycle_information : text;
  variable line_out : line;
  variable cycle_line : line;
  variable start : boolean := true;
  variable cycles : integer := 0;
  variable stalls : integer := 0;

  variable valid_instruction : std_logic := '0';

  -- Rounds integer up to next multiple of four.
  function ceil4 (
    constant val : natural)
    return natural is
  begin  -- function ceil4
    return natural(ceil(real(val)/real(4)))*4;
  end function ceil4;

  function ext_to_multiple_of_4 (
    constant slv : std_logic_vector)
    return std_logic_vector is
  begin
    return std_logic_vector(resize(
    unsigned(slv), ceil4(slv'length)));
  end function ext_to_multiple_of_4;

  function to_unsigned_hex (
    constant slv : std_logic_vector) return string is
    variable resized_slv : std_logic_vector(ceil4(slv'length)-1 downto 0);
    variable result      : string(1 to ceil4(slv'length)/4)
      := (others => ' ');
    subtype digit_t is std_logic_vector(3 downto 0);
    variable digit : digit_t := "0000";
  begin
    resized_slv := ext_to_multiple_of_4(slv);
    for i in result'range loop
      digit := resized_slv(
        resized_slv'length-((i-1)*4)-1 downto resized_slv'length-(i*4));
      case digit is
        when "0000" => result(i) := '0';
        when "0001" => result(i) := '1';
        when "0010" => result(i) := '2';
        when "0011" => result(i) := '3';
        when "0100" => result(i) := '4';
        when "0101" => result(i) := '5';
        when "0110" => result(i) := '6';
        when "0111" => result(i) := '7';
        when "1000" => result(i) := '8';
        when "1001" => result(i) := '9';
        when "1010" => result(i) := 'a';
        when "1011" => result(i) := 'b';
        when "1100" => result(i) := 'c';
        when "1101" => result(i) := 'd';
        when "1110" => result(i) := 'e';
        when "1111" => result(i) := 'f';
        -- For TTAsim bustrace compatibility
        when others => 
          result := (others => '0');
          return result;
      end case;
    end loop;  -- i in result'range
    return result;
  end function to_unsigned_hex;

  begin
    if start = true then
      file_open(rv_instruction_trace, "riscv_instruction_trace.dump", write_mode);
      file_open(cycle_information, "cycles.dump", write_mode);
      start := false;
    end if;

    --rising edge
    wait on clk until clk = '1' and clk'last_value = '0';

    valid_instruction := (not bubble) or rv_jump_wire or rv_auipc_wire;
    cycles := cycles + 1;

    if (bubble = '1' and rv_jump_wire = '0' and rv_auipc_wire = '0') then
      stalls := stalls + 1;
    end if;
    if(glock_in = '0' and valid_instruction = '1') then
      write(line_out, to_unsigned_hex(instruction));
      writeline(rv_instruction_trace, line_out);
    end if; 

    --End of simulation
    if(valid_instruction = '1' and unsigned(instruction) = to_unsigned(111, instruction'length)) then
      write(cycle_line, string'("TOTAL CYCLES: "));
      write(cycle_line, cycles);
      writeline(cycle_information, cycle_line);
      write(cycle_line, string'("STALL CYCLES: "));
      write(cycle_line, stalls);
      writeline(cycle_information, cycle_line);
    end if;
  end process file_output;

  --pragma translate_on

end architecture rtl;


    


