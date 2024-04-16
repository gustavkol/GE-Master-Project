library IEEE;
use IEEE.Std_Logic_1164.all;
use std.textio.all;
use ieee.numeric_std.all;

entity testbench is
end testbench;

architecture behav of testbench is

  --  Declaration and binding of the component that will be instantiated.
   component fu_under_test
      port(
      t1data    : in std_logic_vector(31 downto 0);
      t1load    : in  std_logic;
      t2data    : in std_logic_vector(31 downto 0);
      t2load    : in  std_logic;
      r1data    : out std_logic_vector(31 downto 0);
      glock     : in  std_logic;
      rstx      : in  std_logic;
      clk       : in  std_logic);
   end component;


   for tested_fu_0 : fu_under_test use entity work.fu_cordic;

  --  Specify registers for the ports.
   signal t1data        : std_logic_vector(31 downto 0);
   signal t1load        : std_logic_vector(1-1 downto 0);
   signal t2data        : std_logic_vector(31 downto 0);
   signal t2load        : std_logic_vector(1-1 downto 0);
   signal r1data        : std_logic_vector(31 downto 0);
   signal glock : std_logic;
   signal rstx  : std_logic;
   signal clk   : std_logic;


begin
  --  Map ports of the FU to registers.
   tested_fu_0  :       fu_under_test
      port map (
         t1data => t1data,
         t1load => t1load(0),
         t2data => t2data,
         t2load => t2load(0),
         r1data => r1data,
         clk => clk,
         rstx => rstx,
         glock => glock);
  process

    -- Arrays for stimulus.
      type t1data_data_array is array (natural range <>) of
         std_logic_vector(31 downto 0);

      constant t1data_data : t1data_data_array := --angle
      ("00000000000000000000000000111100",       -- @0 = 60
       "00000000000000000000000000000000",       -- @1 = 0
       "00000000000000000000000000000000",       -- @2 = 0
       "00000000000000000000000000000000",       -- @3 = 0
       "00000000000000000000000000000000",       -- @4 = 0
       "00000000000000000000000000000000",       -- @5 = 0
       "00000000000000000000000000000000",       -- @6 = 0
       "00000000000000000000000000000000",       -- @7 = 0
       "00000000000000000000000000000000",       -- @8 = 0
       "00000000000000000000000000000000",       -- @9 = 0
       "00000000000000000000000000000000",       -- @10 = 0
       "00000000000000000000000001100100",       -- @11 = 100
       "00000000000000000000000000000000",       -- @12 = 0
       "00000000000000000000000000000000",       -- @13 = 0
       "00000000000000000000000000000000",       -- @14 = 0
       "00000000000000000000000000000000",       -- @15 = 0
       "00000000000000000000000000000000",       -- @16 = 0
       "00000000000000000000000000000000",       -- @17 = 0
       "00000000000000000000000000000000",       -- @18 = 0
       "00000000000000000000000000000000",       -- @19 = 0
       "00000000000000000000000000000000",       -- @20 = 0
       "00000000000000000000000000000000",       -- @21 = 0
       "00000000000000000000000001110011",       -- @22 = 115
       "00000000000000000000000000000000",       -- @23 = 0
       "00000000000000000000000000000000",       -- @24 = 0
       "00000000000000000000000000000000",       -- @25 = 0
       "00000000000000000000000000000000",       -- @26 = 0
       "00000000000000000000000000000000",       -- @27 = 0
       "00000000000000000000000000000000",       -- @28 = 0
       "00000000000000000000000000000000",       -- @29 = 0
       "00000000000000000000000000000000",       -- @30 = 0
       "00000000000000000000000000000000",       -- @31 = 0
       "00000000000000000000000000000000",       -- @32 = 0
       "00000000000000000000000000000000",       -- @33 = 0
       "00000000000000000000000000000000");      -- @34 = 0

      type t2data_data_array is array (natural range <>) of
         std_logic_vector(31 downto 0);

      constant t2data_data : t2data_data_array := --x_scale
      ("00000000000010111110000101011111",       -- @0 = 778591
       "00000000000000000000000000000000",       -- @1 = 0
       "00000000000000000000000000000000",       -- @2 = 0
       "00000000000000000000000000000000",       -- @3 = 0
       "00000000000000000000000000000000",       -- @4 = 0
       "00000000000000000000000000000000",       -- @5 = 0
       "00000000000000000000000000000000",       -- @6 = 0
       "00000000000000000000000000000000",       -- @7 = 0
       "00000000000000000000000000000000",       -- @8 = 0
       "00000000000000000000000000000000",       -- @9 = 0
       "00000000000000000000000000000000",       -- @10 = 0
       "00000000000000000000000000000000",       -- @10 = 0
       "00000000000000000000000010001100",       -- @11 = 140
       "00000000000000000000000000000000",       -- @12 = 0
       "00000000000000000000000000000000",       -- @13 = 0
       "00000000000000000000000000000000",       -- @14 = 0
       "00000000000000000000000000000000",       -- @15 = 0
       "00000000000000000000000000000000",       -- @16 = 0
       "00000000000000000000000000000000",       -- @17 = 0
       "00000000000000000000000000000000",       -- @17 = 0
       "00000000000000000000000000000000",       -- @18 = 0
       "00000000000000000000000000000000",       -- @19 = 0
       "00000000000000000000000000000000",       -- @20 = 0s
       "00000000000000000000000000000000",       -- @21 = 0
       "00000000000000000110001110011011",       -- @22 = 25499
       "00000000000000000000000000000000",       -- @23 = 0
       "00000000000000000000000000000000",       -- @24 = 0
       "00000000000000000000000000000000",       -- @25 = 0
       "00000000000000000000000000000000",       -- @26 = 0
       "00000000000000000000000000000000",       -- @27 = 0
       "00000000000000000000000000000000",       -- @28 = 0
       "00000000000000000000000000000000",       -- @29 = 0
       "00000000000000000000000000000000",       -- @30 = 0
       "00000000000000000000000000000000",       -- @31 = 0
       "00000000000000000000000000000000",       -- @32 = 0
       "00000000000000000000000000000000",       -- @33 = 0
       "00000000000000000000000000000000");      -- @34 = 0


    -- Opcodes for each clock cycle.

    -- Load signals for each cycle
      type t1load_data_array is array (natural range <>) of
         std_logic_vector(0 downto 0);

      constant t1load_data : t1load_data_array :=
      ("1",      -- @0
       "0",      -- @1
       "0",      -- @2
       "0",      -- @3
       "0",      -- @4
       "0",      -- @5
       "0",      -- @6
       "0",      -- @7
       "0",      -- @8
       "0",      -- @9
       "0",      -- @10
       "1",      -- @11
       "0",      -- @12
       "0",      -- @13
       "0",      -- @14
       "0",      -- @15
       "0",      -- @16
       "0",      -- @17
       "0",      -- @18
       "0",      -- @19
       "0",      -- @20  
       "0",      -- @21
       "1",      -- @22
       "0",      -- @23
       "0",      -- @24
       "0",      -- @25
       "0",      -- @26
       "0",      -- @27
       "0",      -- @28
       "0",      -- @29
       "0",      -- @30
       "0",      -- @31   
       "0",      -- @32
       "0",      -- @33   
       "0");      -- @34

      type t2load_data_array is array (natural range <>) of
         std_logic_vector(0 downto 0);

      constant t2load_data : t2load_data_array :=
      ("1",      -- @0
       "0",      -- @1
       "0",      -- @2
       "0",      -- @3
       "0",      -- @4
       "0",      -- @5
       "0",      -- @6
       "0",      -- @7
       "0",      -- @8
       "0",      -- @9
       "0",      -- @10
       "1",      -- @11
       "0",      -- @12
       "0",      -- @13
       "0",      -- @14
       "0",      -- @15
       "0",      -- @16
       "0",      -- @17
       "0",      -- @18
       "0",      -- @19
       "0",      -- @20   
       "0",      -- @21
       "1",      -- @22
       "0",      -- @23
       "0",      -- @24
       "0",      -- @25
       "0",      -- @26
       "0",      -- @27
       "0",      -- @28
       "0",      -- @29
       "0",      -- @30
       "0",      -- @31   
       "0",      -- @32
       "0",      -- @33   
       "0");      -- @324


    -- Arrays for expected outputs for each output port.
      type r1data_data_array is array (natural range <>) of
         std_logic_vector(31 downto 0);

      constant r1data_data : r1data_data_array :=
      ("00000000000000000000000000000000",       -- @0 = 0
       "00000000000000000000000000000000",       -- @1 = 0
       "00000000000000000000000000000000",       -- @2 = 0
       "00000000000000000000000000000000",       -- @3 = 0
       "00000000000000000000000000000000",       -- @4 = 0
       "00000000000000000000000000000000",       -- @5 = 0
       "00000000000000000000000000000000",       -- @6 = 0
       "00000000000000000000000000000000",       -- @7 = 0
       "00000000000000000000000000000000",       -- @8 = 0
       "00000000000000000000000000000000",       -- @9 = 0
       "00000000000000000000000000000000",       -- @10 = 0
       "00000000000000000000000000000000",       -- @11 = 0
       "00000000000001011001100001110001",       -- @12 = 366705
       "00000000000000000000000000000000",       -- @13 = 0
       "00000000000000000000000000000000",       -- @14 = 0
       "00000000000000000000000000000000",       -- @15 = 0
       "00000000000000000000000000000000",       -- @16 = 0
       "00000000000000000000000000000000",       -- @17 = 0
       "00000000000000000000000000000000",       -- @18 = 0
       "00000000000000000000000000000000",       -- @19 = 0
       "00000000000000000000000000000000",       -- @20 = 0
       "00000000000000000000000000000000",       -- @21 = 0
       "00000000000000000000000000000000",       -- @22 = 0
       "01111111111111111111111111100101",       -- @23 = -27
       "00000000000000000000000000000000",       -- @24 = 0
       "00000000000000000000000000000000",       -- @25 = 0
       "00000000000000000000000000000000",       -- @26 = 0
       "00000000000000000000000000000000",       -- @27 = 0
       "00000000000000000000000000000000",       -- @28 = 0
       "00000000000000000000000000000000",       -- @29 = 0
       "00000000000000000000000000000000",       -- @30 = 0
       "00000000000000000000000000000000",       -- @31 = 0
       "00000000000000000000000000000000",       -- @32 = 0
       "00000000000000000000000000000000",       -- @33 = 0
       "11111111111111111101011100000011");      -- @34 = 0

      constant IGNORE_OUTPUT_COUNT : integer := 12;
      constant TOTAL_CYCLE_COUNT : integer := 34;


     variable current_cycle : integer;
  begin

    -- Initialize the clock signal.
    clk <= '0';

    -- Reset active to initialize regs
    rstx <= '0';
    wait for 1 ns;

    -- Release reset.
    rstx <= '1';
    -- Global lock off.
    glock <= '0';


    for current_cycle in 0 to TOTAL_CYCLE_COUNT - 1 loop

    -- The actual test bench code.
      t1data <= t1data_data(current_cycle);
      t1load <= t1load_data(current_cycle);
      t2data <= t2data_data(current_cycle);
      t2load <= t2load_data(current_cycle);


      if current_cycle mod IGNORE_OUTPUT_COUNT = 0 and current_cycle /= 0 then
        assert r1data = r1data_data(current_cycle)
            report "TCE Assert: Verification failed at cycle " & integer'image(current_cycle) & " for output 0" &
                    " actual: " & integer'image(to_integer(signed(r1data))) &
                    " expected: " & integer'image(to_integer(signed(r1data_data(current_cycle))))
            severity error;
        end if;

      -- Generate a clock pulse.
      -- TODO: Generate the clock in a separate component.
      wait for 1 ns;
      clk <= not clk;
      wait for 1 ns;
      clk <= not clk;

    end loop;  -- current_cycle

    -- Ends the simulation (at least in case of ghdl).
    wait;
  end process;
end behav;