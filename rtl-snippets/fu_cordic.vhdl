library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;

entity fu_cordic is 
    generic (
        DW_ANGLE                : integer := 8;
        DW_FRACTION             : integer := 6;
        dataw                   : integer := 32;
        NUM_ITERATIONS          : integer := 11
    );
    port (
        t1data : in std_logic_vector(dataw-1 downto 0);
        t1load : in std_logic;
        t2data : in std_logic_vector(dataw-1 downto 0);
        t2load : in std_logic;
        r1data : out std_logic_vector(dataw-1 downto 0);

        glock   : in std_logic;
        clk     : in std_logic;
        rstx    : in std_logic
    );
end fu_cordic;

architecture rtl of fu_cordic is
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
    signal x_cur_reg, y_cur_reg                 : signed(dataw-1 downto 0);
    signal angle_cur_reg                        : signed(DW_ANGLE+DW_FRACTION-1 downto 0);
    signal sign_bit, sign_increment             : std_logic;
    signal counter                              : integer;

begin
    
    -- Updating next state
    STATE_FF: process (clk, rstx) begin
        if (rstx = '0') then
            state <= Idle;
        elsif (clk'event and clk = '1') then
            state <= nextState;
        end if;
    end process;

    -- Next state logic
    COMB: process(glock, t1load, state, counter, rstx) begin
        if (rstx = '0') then
            nextState <= Idle;
        else
            case state is 
                when Idle   =>      
                    if (glock = '0' and t1load = '1') then 
                        nextState <= Run; 
                    else
                        nextState <= Idle;    
                    end if;
                when Run    =>      
                    if (counter = NUM_ITERATIONS-1) then 
                        nextState <= Idle; 
                    else
                        nextState <= Run;    
                    end if;
            end case;
        end if;
    end process;

    -- Module logic
    FUNC: process (clk, rstx) begin
        if (rstx = '0') then
            x_cur_reg       <= (others => '0');
            y_cur_reg       <= (others => '0');
            angle_cur_reg   <= (others => '0');
            r1data          <= (others => '0');
            counter         <= 0;
            sign_bit        <= '0';
            sign_increment  <= '0';
        elsif (clk'event and clk = '1') then
            case state is 
                when Idle   => 
                    if (glock = '0' and t1load = '1') then 
                        -- Adjusting from 4 fraction bits to 6 fraction bits
                        x_cur_reg <= shift_left(signed(t2data), 2-1) + shift_right(signed(t2data), 4-2) + shift_right(signed(t2data), 5-2) + shift_right(signed(t2data),6-2);
                        if (to_integer(signed(t1data)) > 90) then
                            angle_cur_reg <= resize(signed(to_signed(180, t1data'length) - signed(t1data)),DW_ANGLE) & (DW_FRACTION-1 downto 0 => '0');
                            sign_bit      <= '1';
                        else
                            angle_cur_reg <= resize(signed(t1data),DW_ANGLE) & (DW_FRACTION-1 downto 0 => '0');
                            sign_bit      <= '0';
                        end if;                        
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
                            -- Adjusting from 6 fraction bits to 4 fraction bits
                            r1data <= std_logic_vector(shift_right(-x_cur_reg, 2)); -- updating output
                        else
                            -- Adjusting from 6 fraction bits to 4 fraction bits
                            r1data <= std_logic_vector(shift_right(x_cur_reg, 2)); -- updating output
                        end if ;
                        y_cur_reg       <= (others => '0');
                        counter         <= 0;
                        sign_increment  <= '0';
                    end if;
            end case;
        end if;
    end process;
end rtl;
