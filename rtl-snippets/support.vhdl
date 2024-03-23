library IEEE;
use IEEE.std_logic_1164.all;

package support_opcodes is

  constant OPC_SUPPORT_CORDIC   : std_logic_vector(1 downto 0) := "00";
  constant OPC_SUPPORT_BN       : std_logic_vector(1 downto 0) := "01";
  constant OPC_SUPPORT_C0       : std_logic_vector(1 downto 0) := "10";
  constant OPC_SUPPORT_N0       : std_logic_vector(1 downto 0) := "11";
  
end support_opcodes;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;
use work.support_opcodes.all;

entity support is 
    generic (
        DW_ANGLE                : integer := 8;
        DW_FRACTION             : integer := 6;
        dataw                   : integer := 32;
        DW_CALCULATION_TERMS    : integer := 16;
        NUM_ITERATIONS          : integer := 11
    );
    port (
        t1data : in std_logic_vector(dataw-1 downto 0);
        t1load : in std_logic;
        t1opcode : in  std_logic_vector(1 downto 0);
        t2data : in std_logic_vector(dataw-1 downto 0);
        t2load : in std_logic;
        r1data : out std_logic_vector(dataw-1 downto 0);

        glock   : in std_logic;
        clk     : in std_logic;
        rstx    : in std_logic
    );
end cordic;

architecture rtl of support is
    -- Local parameters
    constant DW_ROTATED_ANGLE_INTEGER : integer := 7;

    -- Angle rotation constants
    type rotation_type is array (0 to NUM_ITERATIONS-1) of signed(DW_ROTATED_ANGLE_INTEGER+DW_ROTATED_ANGLE_INTEGER-2 downto 0);
    constant rotated_angle_array : rotation_type := ("0101101000000", --45
                                                    "0011010100100", --26.5625
                                                    "0001110001000", --14.125
                                                    "0000111001000", -- 7.125
                                                    "0000011100100", -- 3.5625
                                                    "0000001110000", -- 1.75
                                                    "0000000111000", -- 0.875
                                                    "0000000011100", -- 0.4375
                                                    "0000000010000", -- 0.25
                                                    "0000000000111", -- 0.109375
                                                    "0000000000011"); -- 0.05595
    
    -- FSM
    type states is (Idle, Run);
    signal state, nextState : states;

    -- Internal registers
    signal x_cur_reg, y_cur_reg                 : signed(DW_CALCULATION_TERMS+DW_FRACTION-1 downto 0);
    signal angle_cur_reg                        : signed(DW_ANGLE+DW_FRACTION-1 downto 0);
    signal sign_bit, sign_increment, done_reg   : std_logic;
    signal counter                              : integer;

begin
    
    -- Updating next state
    STATE_FF: process (clk) begin
        if (rstx = '0') then
            state <= Idle;
        elsif (clk'event and clk = '1') then
            state <= nextState;
        end if;
    end process;

    -- Next state logic
    COMB: process(glock, t1load, t2load, rstx) begin
        if (rstx = '0') then
            nextState <= Idle;
        else
            case state is 
                when Idle   =>      
                    if (glock = '0' and t1load = '1') then 
                        case t1opcode is
                            when OPC_SUPPORT_CORDIC  =>  nextState <= Run;
                            when others              =>  nextState <= Idle;
                        end case;
                    end if;
                when Run    =>  
                    if (counter = NUM_ITERATIONS-1) then
                        nextState <= Idle;
                    end if;
            end case;
        end if;
    end process;

    -- Module logic
    FUNC: process (clk) begin
        if (rstx = '0') then
            x_cur_reg       <= (others => '0');
            y_cur_reg       <= (others => '0');
            angle_cur_reg   <= (others => '0');
            counter         <= 0;
            sign_bit        <= '0';
            sign_increment  <= '0';
            done_reg        <= '0';
        elsif (clk'event and clk = '1') then
            case state is 
                when Idle   => 
                    if (glock = '0' and t1load = '1') then 
                        case t1opcode is
                            when OPC_SUPPORT_CORDIC  =>
                                x_cur_reg <= (shift_right(signed(t2data), 1) + shift_right(signed(t2data), 4) + shift_right(signed(t2data), 5) + shift_right(signed(t2data), 6));
                                --x_cur_reg <= shift_left(signed(t2data), 6-1) + shift_left(signed(t2data), 6-4) + shift_left(signed(t2data), 6-5) + signed(t2data);
                                if (to_integer(signed(t1data)) > 90) then
                                    angle_cur_reg <= signed(to_signed(180, t1data'length) - signed(t1data)) & (5 downto 0 => '0');
                                    sign_bit      <= '1';
                                else
                                    angle_cur_reg <= (signed(t1data) & (5 downto 0 => '0'));
                                    sign_bit      <= '0';
                                end if; 
                            when OPC_SUPPORT_BN =>
                                -- 2 * f_s / v_s = 32.468
                                r1data  <= std_logic_vector(unsigned(shift_left(unsigned(t1data),5+4)) + unsigned(shift_left(unsigned(t1data),4-1)) 
                                            - unsigned(shift_right(unsigned(t1data),5-4)) - unsigned(shift_right(unsigned(t1data),10-4))); 
                            when OPC_SUPPORT_C0 =>
                                -- (2*p*(f_s/v_s)^2) * 10^-3 = 131.767 = 0b0100000111100
                                r1data  <= std_logic_vector(unsigned(shift_left(unsigned(t1data),7+4)) + unsigned(shift_left(unsigned(t1data),1+4)) + unsigned(shift_left(unsigned(t1data),0+4))
                                            + unsigned(shift_left(unsigned(t1data),4-1)) + unsigned(shift_left(unsigned(t1data),4-2)));
                            when OPC_SUPPORT_N0 =>
                                -- (f_s/v_s) * 10^-3 = 16.234
                                r1data  <= std_logic_vector(unsigned(shift_left(unsigned(t1data),4+4)) + unsigned(shift_left(unsigned(t1data),4-2)) - unsigned(shift_right(unsigned(t1data),6-4)));
                            when others => null;
                    end if;
                when Run    =>      
                    if (counter /= NUM_ITERATIONS-1) then
                        if (sign_increment = '0') then
                            x_cur_reg <= x_cur_reg - shift_right(signed(y_cur_reg),counter);
                            y_cur_reg <= y_cur_reg + shift_right(signed(x_cur_reg),counter);
                            if (to_integer(angle_cur_reg - rotated_angle_array(counter)) > 0) then
                                sign_increment <= '0';
                            else
                                sign_increment <= '1';
                            end if;
                            angle_cur_reg <= angle_cur_reg - rotated_angle_array(counter);
                        else
                            x_cur_reg <= x_cur_reg + shift_right(signed(y_cur_reg),counter);
                            y_cur_reg <= y_cur_reg - shift_right(signed(x_cur_reg),counter);
                            if (to_integer(angle_cur_reg + rotated_angle_array(counter)) > 0) then
                                sign_increment <= '0';
                            else
                                sign_increment <= '1';
                            end if;
                            angle_cur_reg <= angle_cur_reg + rotated_angle_array(counter);
                        end if;
                        counter <= counter + 1;
                    else
                        if (sign_bit = '1') then
                            r1data <= std_logic_vector(resize(signed(-x_cur_reg), r1data'length)); -- updating output
                        else
                            r1data <= std_logic_vector(resize(x_cur_reg, r1data'length)); -- updating output
                        end if ;
                    end if;
            end case;
        end if;
    end process;
end rtl;
