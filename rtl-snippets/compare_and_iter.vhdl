library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;

entity compare_and_iter is 
    generic (
        DW_FRACTION             : integer := 4;
        dataw                   : integer := 32
        DW_A                    : integer := 6;
    );
    port (
        t1data : in std_logic_vector(dataw-1 downto 0);     --(a_prev + n_prev)
        t1load : in std_logic;
        t2data : in std_logic_vector(dataw-1 downto 0);     --(inc_term_w_error-inc_term_prev)
        t2load : in std_logic;
        r1data : out std_logic_vector(dataw-1 downto 0);    --a_next & inc_term_next

        glock   : in std_logic;
        clk     : in std_logic;
        rstx    : in std_logic
    );
end compare_and_iter;

architecture rtl of compare_and_iter is

    -- FSM
    type states is (Idle, Run);
    signal state, nextState : states;

    -- Internal registers
    signal inc_term_frac, t1data_reg            : signed(dataw-1 downto 0);
    signal a_reg                                : signed(DW_A-1 downto 0);
    signal sign_bit                             : std_logic;

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
    COMB: process(glock, t1load, t2load, counter, rstx) begin
        if (rstx = '0') then
            nextState <= Idle;
        else
            case state is 
                when Idle   =>      if (glock = '0' and t1load = '1')   then nextState <= Run; end if;
                when Run    =>                                          then nextState <= Idle; end if;
            end case;
        end if;
    end process;

    -- Module logic
    FUNC: process (clk) begin
        if (rstx = '0') then
            inc_term_frac   <= (others => '0');
            a_reg           <= (others => '0');
            t1data_reg      <= (others => '0');
            sign_bit        <= '0';
        elsif (clk'event and clk = '1') then
            case state is 
                when Idle   => 
                    if (glock = '0' and t1load = '1') then 
                        sign_bit <= t2data(31 downto 31);
                        t1data_reg <= signed(t1data);
                        -- INTEGER
                        if (signed(signed(shift_left(signed(t1data), 1)) + (1<<DW_FRACTION)) > signed(t2data)) then
                            -- 0
                            inc_term_frac <= signed(t2data);
                        elsif (signed(signed(shift_left(signed(t1data), 2)) + (4 << DW_FRACTION)) > signed(t2data)) then
                            -- 1
                            a_reg(DW_A-1 downto 2) <= to_unsigned(1, a_reg'length-2);
                            inc_term_frac <= signed(t2data) - signed(shift_left(signed(t1data), 1)) - signed(1<<DW_FRACTION);
                        elsif (signed(signed(shift_left(signed(t1data), 2)) + signed(shift_left(signed(t1data), 1)) + 9 << (DW_FRACTION))) > signed(t2data)) then
                            -- 2
                            a_reg(DW_A-1 downto 2) <= to_unsigned(2, a_reg'length-2);
                            inc_term_frac <= signed(t2data) - signed(shift_left(signed(t1data), 2)) - signed(4<<DW_FRACTION);
                        elsif (signed(signed(shift_left(signed(t1data), 3)) + (16 << DW_FRACTION) > signed(t2data)) then
                            -- 3
                            a_reg(DW_A-1 downto 2) <= to_unsigned(3, a_reg'length-2);
                            inc_term_frac <= signed(t2data) - signed(shift_left(signed(t1data), 2)) - signed(shift_left(signed(t1data), 1)) - signed(9<<DW_FRACTION);
                        else
                            --4
                            a_reg(DW_A-1 downto 2) <= to_unsigned(4, a_reg'length-2);
                            inc_term_frac <= signed(t2data) - signed(shift_left(signed(t1data), 3)) - signed(16<<DW_FRACTION);
                        end if;
                    end if;
                when Run    =>  
                    -- FRACTION
                    if (signed(shift_right(signed(t1data_reg), 1)) + signed(1<<DW_FRACTION-4) > signed(inc_term_frac)) then
                        -- 0.0
                        r1data(dataw-1 downto dataw-DW_A)   <= std_logic_vector(a_reg & "00");
                        r1data(dataw-DW_A-1 downto 0)       <= std_logic_vector(inc_term_frac(dataw-DW_A-1 downto 0));
                    elsif (signed(t1data_reg) + signed(1<<DW_FRACTION-3) > signed(inc_term_frac)) then
                        -- 0.25
                        r1data(dataw-1 downto dataw-DW_A-1) <= std_logic_vector(a_reg & "01");
                        r1data(dataw-DW_A-1 downto 0)       <= std_logic_vector(signed(inc_term_frac(dataw-DW_A-1 downto 0)) - signed(shift_right(signed(t1data_reg), 1)) - signed(1<<DW_FRACTION-4));
                    elsif (signed(shift_right(signed(t1data_reg), 1)) + signed(t1data_reg)) + signed(1<<DW_FRACTION-4) + signed(1<<DW_FRACTION-3) > signed(inc_term_frac) then
                        -- 0.5
                        r1data(dataw-1 downto dataw-DW_A-1) <= std_logic_vector(a_reg & "10");
                        r1data(dataw-DW_A-1 downto 0)       <= std_logic_vector(signed(inc_term_frac(dataw-DW_A-1 downto 0)) - signed(t1data_reg) - signed(1<<DW_FRACTION-3));
                    else
                        -- 0.75
                        r1data(dataw-1 downto dataw-DW_A-1) <= std_logic_vector(a_reg & "11");
                        r1data(dataw-DW_A-1 downto 0)       <= std_logic_vector(signed(inc_term_frac(dataw-DW_A-1 downto 0)) - signed(shift_right(signed(t1data_reg), 1)) - signed(t1data_reg) - signed(1<<DW_FRACTION-4) - signed(1<<DW_FRACTION-3));
                    end if;
            end case;
        end if;
    end process;
end rtl;
