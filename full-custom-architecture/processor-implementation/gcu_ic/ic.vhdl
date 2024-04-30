library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.ext;
use IEEE.std_logic_arith.sxt;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;
use work.tta0_globals.all;
use work.tce_util.all;

entity tta0_interconn is

  port (
    clk : in std_logic;
    rstx : in std_logic;
    glock : in std_logic;
    socket_lsu_i1_data : out std_logic_vector(7 downto 0);
    socket_lsu_o1_data0 : in std_logic_vector(31 downto 0);
    socket_lsu_o1_bus_cntrl : in std_logic_vector(1 downto 0);
    socket_lsu_i2_data : out std_logic_vector(31 downto 0);
    socket_lsu_i2_bus_cntrl : in std_logic_vector(1 downto 0);
    socket_alu_comp_i1_data : out std_logic_vector(31 downto 0);
    socket_alu_comp_i2_data : out std_logic_vector(31 downto 0);
    socket_alu_comp_o1_data0 : in std_logic_vector(31 downto 0);
    socket_alu_comp_o1_bus_cntrl : in std_logic_vector(4 downto 0);
    socket_gcu_i1_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    socket_gcu_i1_bus_cntrl : in std_logic_vector(1 downto 0);
    socket_gcu_i2_data : out std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    socket_gcu_i2_bus_cntrl : in std_logic_vector(1 downto 0);
    socket_gcu_o1_data0 : in std_logic_vector(IMEMADDRWIDTH-1 downto 0);
    socket_gcu_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_FU_ALGORITHM_i1_data : out std_logic_vector(31 downto 0);
    socket_FU_ALGORITHM_i2_data : out std_logic_vector(31 downto 0);
    socket_FU_ALGORITHM_o1_data0 : in std_logic_vector(31 downto 0);
    socket_FU_ALGORITHM_o1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_RF_8x32_o1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_o1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_i1_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_i1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_i1_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_i1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_FU_CORDIC_i1_data : out std_logic_vector(31 downto 0);
    socket_FU_CORDIC_i2_data : out std_logic_vector(31 downto 0);
    socket_FU_CORDIC_o1_data0 : in std_logic_vector(31 downto 0);
    socket_FU_CORDIC_o1_bus_cntrl : in std_logic_vector(1 downto 0);
    socket_RF_8x32_1_o1_1_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_2_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_3_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_3_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_RF_8x32_1_o1_1_1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_2_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_1_1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_1_1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_1_2_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_2_1_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_3_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_3_1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_3_1_bus_cntrl : in std_logic_vector(2 downto 0);
    socket_RF_8x32_1_o1_1_2_1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_2_1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_1_3_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_1_3_1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_2_1_1_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_2_1_1_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_3_1_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_3_1_1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_3_1_1_bus_cntrl : in std_logic_vector(1 downto 0);
    socket_RF_8x32_1_o1_1_1_3_2_data : out std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_2_1_2_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_2_1_1_1_data0 : in std_logic_vector(31 downto 0);
    socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl : in std_logic_vector(0 downto 0);
    socket_RF_8x32_1_o1_1_1_3_1_1_data : out std_logic_vector(31 downto 0);
    simm_B1 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1 : in std_logic_vector(0 downto 0);
    simm_B2 : in std_logic_vector(31 downto 0);
    simm_cntrl_B2 : in std_logic_vector(0 downto 0);
    simm_B3 : in std_logic_vector(31 downto 0);
    simm_cntrl_B3 : in std_logic_vector(0 downto 0);
    simm_B1_1 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_1 : in std_logic_vector(0 downto 0);
    simm_B1_2 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_2 : in std_logic_vector(0 downto 0);
    simm_B1_3 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_3 : in std_logic_vector(0 downto 0);
    simm_B1_4 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_4 : in std_logic_vector(0 downto 0);
    simm_B1_5 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_5 : in std_logic_vector(0 downto 0);
    simm_B1_6 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_6 : in std_logic_vector(0 downto 0);
    simm_B1_7 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_7 : in std_logic_vector(0 downto 0);
    simm_B1_8 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_8 : in std_logic_vector(0 downto 0);
    simm_B1_9 : in std_logic_vector(31 downto 0);
    simm_cntrl_B1_9 : in std_logic_vector(0 downto 0));

end tta0_interconn;

architecture comb_andor of tta0_interconn is

  signal databus_B1 : std_logic_vector(31 downto 0);
  signal databus_B1_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_alt2 : std_logic_vector(31 downto 0);
  signal databus_B1_alt3 : std_logic_vector(31 downto 0);
  signal databus_B1_simm : std_logic_vector(31 downto 0);
  signal databus_B2 : std_logic_vector(31 downto 0);
  signal databus_B2_alt0 : std_logic_vector(31 downto 0);
  signal databus_B2_alt1 : std_logic_vector(31 downto 0);
  signal databus_B2_alt2 : std_logic_vector(31 downto 0);
  signal databus_B2_alt3 : std_logic_vector(31 downto 0);
  signal databus_B2_simm : std_logic_vector(31 downto 0);
  signal databus_B3 : std_logic_vector(31 downto 0);
  signal databus_B3_alt0 : std_logic_vector(31 downto 0);
  signal databus_B3_alt1 : std_logic_vector(31 downto 0);
  signal databus_B3_alt2 : std_logic_vector(31 downto 0);
  signal databus_B3_alt3 : std_logic_vector(31 downto 0);
  signal databus_B3_alt4 : std_logic_vector(31 downto 0);
  signal databus_B3_simm : std_logic_vector(31 downto 0);
  signal databus_B1_1 : std_logic_vector(31 downto 0);
  signal databus_B1_1_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_1_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_1_simm : std_logic_vector(31 downto 0);
  signal databus_B1_2 : std_logic_vector(31 downto 0);
  signal databus_B1_2_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_2_simm : std_logic_vector(31 downto 0);
  signal databus_B1_3 : std_logic_vector(31 downto 0);
  signal databus_B1_3_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_3_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_3_alt2 : std_logic_vector(31 downto 0);
  signal databus_B1_3_simm : std_logic_vector(31 downto 0);
  signal databus_B1_4 : std_logic_vector(31 downto 0);
  signal databus_B1_4_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_4_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_4_simm : std_logic_vector(31 downto 0);
  signal databus_B1_5 : std_logic_vector(31 downto 0);
  signal databus_B1_5_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_5_simm : std_logic_vector(31 downto 0);
  signal databus_B1_6 : std_logic_vector(31 downto 0);
  signal databus_B1_6_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_6_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_6_alt2 : std_logic_vector(31 downto 0);
  signal databus_B1_6_simm : std_logic_vector(31 downto 0);
  signal databus_B1_7 : std_logic_vector(31 downto 0);
  signal databus_B1_7_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_7_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_7_simm : std_logic_vector(31 downto 0);
  signal databus_B1_8 : std_logic_vector(31 downto 0);
  signal databus_B1_8_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_8_simm : std_logic_vector(31 downto 0);
  signal databus_B1_9 : std_logic_vector(31 downto 0);
  signal databus_B1_9_alt0 : std_logic_vector(31 downto 0);
  signal databus_B1_9_alt1 : std_logic_vector(31 downto 0);
  signal databus_B1_9_alt2 : std_logic_vector(31 downto 0);
  signal databus_B1_9_simm : std_logic_vector(31 downto 0);

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

  component tta0_input_mux_3 is
    generic (
      BUSW_0 : integer := 32;
      BUSW_1 : integer := 32;
      BUSW_2 : integer := 32;
      DATAW : integer := 32);
    port (
      databus0 : in std_logic_vector(BUSW_0-1 downto 0);
      databus1 : in std_logic_vector(BUSW_1-1 downto 0);
      databus2 : in std_logic_vector(BUSW_2-1 downto 0);
      data : out std_logic_vector(DATAW-1 downto 0);
      databus_cntrl : in std_logic_vector(1 downto 0));
  end component;

  component tta0_input_mux_4 is
    generic (
      BUSW_0 : integer := 32;
      BUSW_1 : integer := 32;
      BUSW_2 : integer := 32;
      BUSW_3 : integer := 32;
      DATAW : integer := 32);
    port (
      databus0 : in std_logic_vector(BUSW_0-1 downto 0);
      databus1 : in std_logic_vector(BUSW_1-1 downto 0);
      databus2 : in std_logic_vector(BUSW_2-1 downto 0);
      databus3 : in std_logic_vector(BUSW_3-1 downto 0);
      data : out std_logic_vector(DATAW-1 downto 0);
      databus_cntrl : in std_logic_vector(1 downto 0));
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

  component tta0_output_socket_cons_2_1 is
    generic (
      BUSW_0 : integer := 32;
      BUSW_1 : integer := 32;
      DATAW_0 : integer := 32);
    port (
      databus0_alt : out std_logic_vector(BUSW_0-1 downto 0);
      databus1_alt : out std_logic_vector(BUSW_1-1 downto 0);
      data0 : in std_logic_vector(DATAW_0-1 downto 0);
      databus_cntrl : in std_logic_vector(1 downto 0));
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

  component tta0_output_socket_cons_5_1 is
    generic (
      BUSW_0 : integer := 32;
      BUSW_1 : integer := 32;
      BUSW_2 : integer := 32;
      BUSW_3 : integer := 32;
      BUSW_4 : integer := 32;
      DATAW_0 : integer := 32);
    port (
      databus0_alt : out std_logic_vector(BUSW_0-1 downto 0);
      databus1_alt : out std_logic_vector(BUSW_1-1 downto 0);
      databus2_alt : out std_logic_vector(BUSW_2-1 downto 0);
      databus3_alt : out std_logic_vector(BUSW_3-1 downto 0);
      databus4_alt : out std_logic_vector(BUSW_4-1 downto 0);
      data0 : in std_logic_vector(DATAW_0-1 downto 0);
      databus_cntrl : in std_logic_vector(4 downto 0));
  end component;


begin -- comb_andor

  -- Dump the value on the buses into a file once in clock cycle
  -- setting DUMP false will disable dumping

  -- Do not synthesize this process!
  -- pragma synthesis_off
  -- pragma translate_off
  file_output : process

    file regularfileout : text;
    file executionfileout : text;

    variable lineout : line;
    variable start : boolean := true;
    variable cyclecount : integer := 0;
    variable executioncount : integer := 0;

    constant DUMP : boolean := true;
    constant REGULARDUMPFILE : string := "bus.dump";
    constant EXECUTIONDUMPFILE : string := "execbus.dump";

    -- Rounds integer up to next multiple of four.
    function ceil4 (
      constant val : natural)
      return natural is
    begin  -- function ceil4
      return natural(ceil(real(val)/real(4)))*4;
    end function ceil4;

   -- Extends std_logic_vector to multiple of four.
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
    if DUMP = true then
      if start = true then
        file_open(regularfileout, REGULARDUMPFILE, write_mode);
        file_open(executionfileout, EXECUTIONDUMPFILE, write_mode);
        start := false;
      end if;

      -- wait until rising edge of clock
      wait on clk until clk = '1' and clk'last_value = '0';
      if (cyclecount > 5) then
        write(lineout, cyclecount-6);
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B2));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B3));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_1));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_2));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_3));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_4));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_5));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_6));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_7));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_8));
        write(lineout, string'(","));
        write(lineout, to_unsigned_hex(databus_B1_9));

        writeline(regularfileout, lineout);
        if glock = '0' then
          write(lineout, executioncount);
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B2));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B3));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_1));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_2));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_3));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_4));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_5));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_6));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_7));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_8));
          write(lineout, string'(","));
          write(lineout, to_unsigned_hex(databus_B1_9));

          writeline(executionfileout, lineout);
          executioncount := executioncount + 1;
        end if;
      end if;
      cyclecount := cyclecount + 1;
    end if;
  end process file_output;
  -- pragma translate_on
  -- pragma synthesis_on

  FU_ALGORITHM_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1,
      data => socket_FU_ALGORITHM_i1_data);

  FU_ALGORITHM_i2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B2,
      data => socket_FU_ALGORITHM_i2_data);

  FU_ALGORITHM_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_alt0,
      databus1_alt => databus_B3_alt0,
      databus2_alt => databus_B1_3_alt0,
      data0 => socket_FU_ALGORITHM_o1_data0,
      databus_cntrl => socket_FU_ALGORITHM_o1_bus_cntrl);

  FU_CORDIC_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1,
      data => socket_FU_CORDIC_i1_data);

  FU_CORDIC_i2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B2,
      data => socket_FU_CORDIC_i2_data);

  FU_CORDIC_o1 : tta0_output_socket_cons_2_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B2_alt0,
      databus1_alt => databus_B3_alt1,
      data0 => socket_FU_CORDIC_o1_data0,
      databus_cntrl => socket_FU_CORDIC_o1_bus_cntrl);

  RF_8x32_1_i1 : tta0_input_mux_2
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B3,
      databus1 => databus_B2,
      data => socket_RF_8x32_1_i1_data,
      databus_cntrl => socket_RF_8x32_1_i1_bus_cntrl);

  RF_8x32_1_o1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B2_alt1,
      data0 => socket_RF_8x32_1_o1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_bus_cntrl);

  RF_8x32_1_o1_1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_1,
      data => socket_RF_8x32_1_o1_1_data);

  RF_8x32_1_o1_1_1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_1_alt0,
      data0 => socket_RF_8x32_1_o1_1_1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_1_1_bus_cntrl);

  RF_8x32_1_o1_1_1_1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_2_alt0,
      data0 => socket_RF_8x32_1_o1_1_1_1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_1_1_1_bus_cntrl);

  RF_8x32_1_o1_1_1_2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_3,
      data => socket_RF_8x32_1_o1_1_1_2_data);

  RF_8x32_1_o1_1_1_3 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_6,
      data => socket_RF_8x32_1_o1_1_1_3_data);

  RF_8x32_1_o1_1_1_3_1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_5_alt0,
      data0 => socket_RF_8x32_1_o1_1_1_3_1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_1_1_3_1_bus_cntrl);

  RF_8x32_1_o1_1_1_3_1_1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_9,
      data => socket_RF_8x32_1_o1_1_1_3_1_1_data);

  RF_8x32_1_o1_1_1_3_2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_9,
      data => socket_RF_8x32_1_o1_1_1_3_2_data);

  RF_8x32_1_o1_1_2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_3,
      data => socket_RF_8x32_1_o1_1_2_data);

  RF_8x32_1_o1_1_2_1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_4_alt0,
      data0 => socket_RF_8x32_1_o1_1_2_1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_1_2_1_bus_cntrl);

  RF_8x32_1_o1_1_2_1_1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_6,
      data => socket_RF_8x32_1_o1_1_2_1_1_data);

  RF_8x32_1_o1_1_2_1_1_1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_8_alt0,
      data0 => socket_RF_8x32_1_o1_1_2_1_1_1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_1_2_1_1_1_bus_cntrl);

  RF_8x32_1_o1_1_2_1_2 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_7_alt0,
      data0 => socket_RF_8x32_1_o1_1_2_1_2_data0,
      databus_cntrl => socket_RF_8x32_1_o1_1_2_1_2_bus_cntrl);

  RF_8x32_1_o1_1_3 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_4,
      data => socket_RF_8x32_1_o1_1_3_data);

  RF_8x32_1_o1_1_3_1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_7,
      data => socket_RF_8x32_1_o1_1_3_1_data);

  RF_8x32_1_o1_2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_2,
      data => socket_RF_8x32_1_o1_2_data);

  RF_8x32_1_o1_2_1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_5,
      data => socket_RF_8x32_1_o1_2_1_data);

  RF_8x32_1_o1_2_1_1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1_8,
      data => socket_RF_8x32_1_o1_2_1_1_data);

  RF_8x32_1_o1_3 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_3_alt1,
      databus1_alt => databus_B1_1_alt1,
      databus2_alt => databus_B1_6_alt0,
      data0 => socket_RF_8x32_1_o1_3_data0,
      databus_cntrl => socket_RF_8x32_1_o1_3_bus_cntrl);

  RF_8x32_1_o1_3_1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_4_alt1,
      databus1_alt => databus_B1_6_alt1,
      databus2_alt => databus_B1_9_alt0,
      data0 => socket_RF_8x32_1_o1_3_1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_3_1_bus_cntrl);

  RF_8x32_1_o1_3_1_1 : tta0_output_socket_cons_2_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_7_alt1,
      databus1_alt => databus_B1_9_alt1,
      data0 => socket_RF_8x32_1_o1_3_1_1_data0,
      databus_cntrl => socket_RF_8x32_1_o1_3_1_1_bus_cntrl);

  RF_8x32_i1 : tta0_input_mux_2
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B3,
      databus1 => databus_B2,
      data => socket_RF_8x32_i1_data,
      databus_cntrl => socket_RF_8x32_i1_bus_cntrl);

  RF_8x32_o1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_alt1,
      data0 => socket_RF_8x32_o1_data0,
      databus_cntrl => socket_RF_8x32_o1_bus_cntrl);

  alu_comp_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B1,
      data => socket_alu_comp_i1_data);

  alu_comp_i2 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B2,
      data => socket_alu_comp_i2_data);

  alu_comp_o1 : tta0_output_socket_cons_5_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      BUSW_3 => 32,
      BUSW_4 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B3_alt2,
      databus1_alt => databus_B1_alt2,
      databus2_alt => databus_B1_3_alt2,
      databus3_alt => databus_B1_6_alt2,
      databus4_alt => databus_B1_9_alt2,
      data0 => socket_alu_comp_o1_data0,
      databus_cntrl => socket_alu_comp_o1_bus_cntrl);

  gcu_i1 : tta0_input_mux_3
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW => IMEMADDRWIDTH)
    port map (
      databus0 => databus_B1,
      databus1 => databus_B2,
      databus2 => databus_B3,
      data => socket_gcu_i1_data,
      databus_cntrl => socket_gcu_i1_bus_cntrl);

  gcu_i2 : tta0_input_mux_3
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW => IMEMADDRWIDTH)
    port map (
      databus0 => databus_B1,
      databus1 => databus_B2,
      databus2 => databus_B3,
      data => socket_gcu_i2_data,
      databus_cntrl => socket_gcu_i2_bus_cntrl);

  gcu_o1 : tta0_output_socket_cons_3_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      DATAW_0 => IMEMADDRWIDTH)
    port map (
      databus0_alt => databus_B1_alt3,
      databus1_alt => databus_B2_alt2,
      databus2_alt => databus_B3_alt3,
      data0 => socket_gcu_o1_data0,
      databus_cntrl => socket_gcu_o1_bus_cntrl);

  lsu_i1 : tta0_input_mux_1
    generic map (
      BUSW_0 => 32,
      DATAW => 8)
    port map (
      databus0 => databus_B1,
      data => socket_lsu_i1_data);

  lsu_i2 : tta0_input_mux_4
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      BUSW_2 => 32,
      BUSW_3 => 32,
      DATAW => 32)
    port map (
      databus0 => databus_B2,
      databus1 => databus_B1_2,
      databus2 => databus_B1_5,
      databus3 => databus_B1_8,
      data => socket_lsu_i2_data,
      databus_cntrl => socket_lsu_i2_bus_cntrl);

  lsu_o1 : tta0_output_socket_cons_2_1
    generic map (
      BUSW_0 => 32,
      BUSW_1 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B3_alt4,
      databus1_alt => databus_B2_alt3,
      data0 => socket_lsu_o1_data0,
      databus_cntrl => socket_lsu_o1_bus_cntrl);

  simm_socket_B1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_simm,
      data0 => simm_B1,
      databus_cntrl => simm_cntrl_B1);

  simm_socket_B2 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B2_simm,
      data0 => simm_B2,
      databus_cntrl => simm_cntrl_B2);

  simm_socket_B3 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B3_simm,
      data0 => simm_B3,
      databus_cntrl => simm_cntrl_B3);

  simm_socket_B1_1 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_1_simm,
      data0 => simm_B1_1,
      databus_cntrl => simm_cntrl_B1_1);

  simm_socket_B1_2 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_2_simm,
      data0 => simm_B1_2,
      databus_cntrl => simm_cntrl_B1_2);

  simm_socket_B1_3 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_3_simm,
      data0 => simm_B1_3,
      databus_cntrl => simm_cntrl_B1_3);

  simm_socket_B1_4 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_4_simm,
      data0 => simm_B1_4,
      databus_cntrl => simm_cntrl_B1_4);

  simm_socket_B1_5 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_5_simm,
      data0 => simm_B1_5,
      databus_cntrl => simm_cntrl_B1_5);

  simm_socket_B1_6 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_6_simm,
      data0 => simm_B1_6,
      databus_cntrl => simm_cntrl_B1_6);

  simm_socket_B1_7 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_7_simm,
      data0 => simm_B1_7,
      databus_cntrl => simm_cntrl_B1_7);

  simm_socket_B1_8 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_8_simm,
      data0 => simm_B1_8,
      databus_cntrl => simm_cntrl_B1_8);

  simm_socket_B1_9 : tta0_output_socket_cons_1_1
    generic map (
      BUSW_0 => 32,
      DATAW_0 => 32)
    port map (
      databus0_alt => databus_B1_9_simm,
      data0 => simm_B1_9,
      databus_cntrl => simm_cntrl_B1_9);

  databus_B1 <= tce_ext(databus_B1_alt0, databus_B1'length) or tce_ext(databus_B1_alt1, databus_B1'length) or tce_ext(databus_B1_alt2, databus_B1'length) or tce_ext(databus_B1_alt3, databus_B1'length) or tce_ext(databus_B1_simm, databus_B1'length);
  databus_B2 <= tce_ext(databus_B2_alt0, databus_B2'length) or tce_ext(databus_B2_alt1, databus_B2'length) or tce_ext(databus_B2_alt2, databus_B2'length) or tce_ext(databus_B2_alt3, databus_B2'length) or tce_ext(databus_B2_simm, databus_B2'length);
  databus_B3 <= tce_ext(databus_B3_alt0, databus_B3'length) or tce_ext(databus_B3_alt1, databus_B3'length) or tce_ext(databus_B3_alt2, databus_B3'length) or tce_ext(databus_B3_alt3, databus_B3'length) or tce_ext(databus_B3_alt4, databus_B3'length) or tce_ext(databus_B3_simm, databus_B3'length);
  databus_B1_1 <= tce_ext(databus_B1_1_alt0, databus_B1_1'length) or tce_ext(databus_B1_1_alt1, databus_B1_1'length) or tce_ext(databus_B1_1_simm, databus_B1_1'length);
  databus_B1_2 <= tce_ext(databus_B1_2_alt0, databus_B1_2'length) or tce_ext(databus_B1_2_simm, databus_B1_2'length);
  databus_B1_3 <= tce_ext(databus_B1_3_alt0, databus_B1_3'length) or tce_ext(databus_B1_3_alt1, databus_B1_3'length) or tce_ext(databus_B1_3_alt2, databus_B1_3'length) or tce_ext(databus_B1_3_simm, databus_B1_3'length);
  databus_B1_4 <= tce_ext(databus_B1_4_alt0, databus_B1_4'length) or tce_ext(databus_B1_4_alt1, databus_B1_4'length) or tce_ext(databus_B1_4_simm, databus_B1_4'length);
  databus_B1_5 <= tce_ext(databus_B1_5_alt0, databus_B1_5'length) or tce_ext(databus_B1_5_simm, databus_B1_5'length);
  databus_B1_6 <= tce_ext(databus_B1_6_alt0, databus_B1_6'length) or tce_ext(databus_B1_6_alt1, databus_B1_6'length) or tce_ext(databus_B1_6_alt2, databus_B1_6'length) or tce_ext(databus_B1_6_simm, databus_B1_6'length);
  databus_B1_7 <= tce_ext(databus_B1_7_alt0, databus_B1_7'length) or tce_ext(databus_B1_7_alt1, databus_B1_7'length) or tce_ext(databus_B1_7_simm, databus_B1_7'length);
  databus_B1_8 <= tce_ext(databus_B1_8_alt0, databus_B1_8'length) or tce_ext(databus_B1_8_simm, databus_B1_8'length);
  databus_B1_9 <= tce_ext(databus_B1_9_alt0, databus_B1_9'length) or tce_ext(databus_B1_9_alt1, databus_B1_9'length) or tce_ext(databus_B1_9_alt2, databus_B1_9'length) or tce_ext(databus_B1_9_simm, databus_B1_9'length);

end comb_andor;
