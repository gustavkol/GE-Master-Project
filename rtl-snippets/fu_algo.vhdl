library IEEE;
use IEEE.std_logic_1164.all;

package algo_opcodes is

  constant OPC_ALGO_INIT      : std_logic_vector(2 downto 0) := "000";
  constant OPC_ALGO_FRAC      : std_logic_vector(2 downto 0) := "001";
  constant OPC_ALGO_MASK_ADD  : std_logic_vector(2 downto 0) := "010";
  constant OPC_ALGO_SHIFT_ADD : std_logic_vector(2 downto 0) := "011";
  constant OPC_ALGO_SHIFT_SUB : std_logic_vector(2 downto 0) := "100";
  constant OPC_ALGO_ADD       : std_logic_vector(2 downto 0) := "101";
  constant OPC_ALGO_SUB       : std_logic_vector(2 downto 0) := "110";
  
end algo_opcodes;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;
use work.algo_opcodes.all;

entity algo is 
    generic (
        DW_FRACTION             : integer := 4;
        DW_A                    : integer := 8;
        dataw                   : integer := 32
    );
    port (
        t1data : in std_logic_vector(dataw-1 downto 0);     --(a_prev + n_prev)
        t1load : in std_logic;
        t1opcode : in  std_logic_vector(2 downto 0);
        t2data : in std_logic_vector(dataw-1 downto 0);     --(inc_term_w_error-inc_term_prev)
        t2load : in std_logic;
        r1data : out std_logic_vector(dataw-1 downto 0);    --a_next & inc_term_next

        glock   : in std_logic;
        clk     : in std_logic;
        rstx    : in std_logic
    );
end algo;

architecture rtl of algo is

    -- FSM
    type states is (Idle, Run);
    signal state, nextState : states;

    -- Internal registers
    signal inc_term_frac, t1data_reg, compensated_reg   : signed(dataw-1 downto 0);
    signal a_reg                                        : signed(DW_A-1 downto 0);
    signal sign_bit                                     : std_logic;

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
                            when OPC_ALGO_INIT  =>  nextState <= Run;
                            when others         =>  nextState <= Idle;
                        end case;
                    end if;
                when Run    =>  nextState <= Idle;
            end case;
        end if;
    end process;

    -- Module logic
    FUNC: process (clk) begin
        if (rstx = '0') then
            inc_term_frac   <= (others => '0');
            a_reg           <= (others => '0');
            t1data_reg      <= (others => '0');
            compensated_reg <= (others => '0');
            sign_bit        <= '0';
        elsif (clk'event and clk = '1') then
            case state is 
                when Idle   => 
                    if (glock = '0' and t1load = '1') then
                        case t1opcode is
                            when OPC_ALGO_INIT  =>
                                sign_bit <= t2data(dataw-1);
                                t1data_reg <= signed(t1data);
                                -- INTEGER
                                if (signed(signed(shift_left(signed(t1data), 1)) + shift_left(to_signed(1, t1data'length),DW_FRACTION)) > abs(signed(t2data))) then
                                    -- 0
                                    inc_term_frac <= signed(t2data);
                                elsif (signed(signed(shift_left(signed(t1data), 2)) + shift_left(to_signed(4, t1data'length), DW_FRACTION)) > abs(signed(t2data))) then
                                    -- 1
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(1, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= signed(signed(t2data) - signed(shift_left(signed(t1data), 1)) - signed(shift_left(to_signed(1, t1data'length),DW_FRACTION)));
                                    compensated_reg                     <= signed(signed(shift_left(signed(t1data), 1)) + shift_left(to_signed(1, t1data'length),DW_FRACTION));
                                elsif ((signed(signed(shift_left(signed(t1data), 2)) + signed(shift_left(signed(t1data), 1)) + shift_left(to_signed(9, t1data'length),DW_FRACTION))) > abs(signed(t2data))) then
                                    -- 2
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(2, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= signed(signed(t2data) - signed(shift_left(signed(t1data), 2)) - signed(shift_left(to_signed(4, t1data'length),DW_FRACTION)));
                                    compensated_reg                     <= signed(signed(shift_left(signed(t1data), 2)) + shift_left(to_signed(4, t1data'length), DW_FRACTION));
                                elsif (signed(signed(shift_left(signed(t1data), 3)) + signed(shift_left(to_signed(1, t1data'length),DW_FRACTION))) > abs(signed(t2data))) then
                                    -- 3
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(3, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= signed(t2data) - signed(shift_left(signed(t1data), 2)) - signed(shift_left(signed(t1data), 1)) - signed(shift_left(to_signed(9, t1data'length),DW_FRACTION));
                                    compensated_reg                     <= (signed(signed(shift_left(signed(t1data), 2)) + signed(shift_left(signed(t1data), 1)) + shift_left(to_signed(9, t1data'length),DW_FRACTION)));
                                else
                                    --4
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(4, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= signed(t2data) - signed(shift_left(signed(t1data), 3)) - signed(shift_left(to_signed(16, t1data'length),DW_FRACTION));
                                    compensated_reg                     <= signed(signed(shift_left(signed(t1data), 3)) + signed(shift_left(to_signed(1, t1data'length),DW_FRACTION)));
                                end if;
                            when OPC_ALGO_FRAC  =>
                                if (signed(shift_right(signed(t1data), 1)) + signed(shift_left(to_signed(1, t1data'length),DW_FRACTION-4)) > abs(signed(t2data))) then
                                    -- 0.0
                                    r1data(dataw-1 downto 0)   <= (others => '0');
                                elsif (signed(t1data) + signed(shift_left(to_signed(1, t1data'length),DW_FRACTION-2)) > abs(signed(t2data))) then
                                    -- 0.25
                                    if (t2data(dataw-1) = '0') then
                                        r1data(DW_A-1 downto 0)     <= (DW_A-1 downto DW_FRACTION => '0') & "0100";
                                        r1data(dataw-1 downto DW_A)    <= std_logic_vector(signed(shift_right(signed(t1data(dataw-DW_A-1 downto 0)), 1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)));
                                    else
                                        r1data(DW_A-1 downto 0)     <= std_logic_vector'("11111100");
                                        r1data(dataw-1 downto DW_A)    <= std_logic_vector(-(signed(shift_right(signed(t1data(dataw-DW_A-1 downto 0)), 1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4))));
                                    end if;
                                elsif (signed(shift_right(signed(t1data), 1)) + signed(t1data)) + signed(shift_left(to_signed(1, t1data'length),DW_FRACTION-4)) + signed(shift_left(to_signed(1, t1data'length),DW_FRACTION-1)) > abs(signed(t2data)) then
                                    -- 0.5
                                    if (t2data(dataw-1) = '0') then
                                        r1data(DW_A-1 downto 0)     <= (DW_A-1 downto DW_FRACTION => '0') & "1000";
                                        r1data(dataw-1 downto DW_A)    <= std_logic_vector(signed(t1data(dataw-DW_A-1 downto 0)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-2)));
                                    else
                                        r1data(DW_A-1 downto 0)     <= std_logic_vector'("11111000");
                                        r1data(dataw-1 downto DW_A)    <= std_logic_vector(-(signed(t1data(dataw-DW_A-1 downto 0)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-2))));
                                    end if;
                                else
                                    -- 0.75
                                    if (t2data(dataw-1) = '0') then
                                        r1data(DW_A-1 downto 0)     <= (DW_A-1 downto DW_FRACTION => '0') & "1100";
                                        r1data(dataw-1 downto DW_A)    <= std_logic_vector(signed(shift_right(signed(t1data(dataw-DW_A-1 downto 0)), 1)) + signed(t1data(dataw-DW_A-1 downto 0)) 
                                                                                            + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-1)));
                                    else
                                        r1data(DW_A-1 downto 0)     <= std_logic_vector'("11110100");
                                        r1data(dataw-1 downto DW_A)    <= std_logic_vector(-(signed(shift_right(signed(t1data(dataw-DW_A-1 downto 0)), 1)) + signed(t1data(dataw-DW_A-1 downto 0)) 
                                                                                            + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-1))));
                                    end if;
                                end if;
                            when OPC_ALGO_MASK_ADD    =>
                              if (t1data(7 downto 7) = '1') then
                                r1data <= std_logic_vector(signed((dataw-1 downto DW_A => '1') & t1data(DW_A-1 downto 0)) + signed(t2data));
                              else
                                r1data <= std_logic_vector(signed((dataw-1 downto DW_A => '0') & t1data(DW_A-1 downto 0)) + signed(t2data));
                            when OPC_ALGO_SHIFT_ADD   =>
                                r1data <= std_logic_vector(shift_right(signed(t1data), DW_A) + signed(t2data));
                            when OPC_ALGO_SHIFT_SUB   =>
                                r1data <= std_logic_vector(signed(t2data) - shift_right(signed(t1data), DW_A));
                            when OPC_ALGO_ADD         => 
                              r1data <= std_logic_vector(signed(t1data) + signed(t2data));
                            when OPC_ALGO_SUB         => 
                              r1data <= std_logic_vector(signed(t1data) - signed(t2data));
                            when others =>  null;
                        end case;
                    end if;
                when Run    =>  
                    -- FRACTION (FRACTIONAL PART CAN BE CONCATENATED INSTEAD OF ADDED)                  ||||||||||||||||||||||||
                    if (signed(shift_right(signed(t1data_reg), 1)) + signed(shift_left(to_signed(1, t1data_reg'length),DW_FRACTION-4)) > abs(signed(inc_term_frac))) then
                        -- 0.0
                        if (sign_bit = '0') then
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(compensated_reg(dataw-DW_A-1 downto 0));
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "0000");
                        else
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(-compensated_reg(dataw-DW_A-1 downto 0));
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "0000"));
                        end if;

                    elsif (signed(t1data_reg) + signed(shift_left(to_signed(1, t1data_reg'length),DW_FRACTION-2)) > abs(signed(inc_term_frac))) then
                        -- 0.25
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "0100");
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) + signed(shift_right(signed(t1data_reg(dataw-DW_A-1 downto 0)), 1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)));
                        else
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "0100"));
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(-(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) + signed(shift_right(signed(t1data_reg(dataw-DW_A-1 downto 0)), 1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4))));
                        end if;
                    elsif (signed(shift_right(signed(t1data_reg), 1)) + signed(t1data_reg)) + signed(shift_left(to_signed(1, t1data_reg'length),DW_FRACTION-4)) + signed(shift_left(to_signed(1, t1data_reg'length),DW_FRACTION-1)) > abs(signed(inc_term_frac)) then
                        -- 0.5
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "1000");
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(t1data_reg(dataw-DW_A-1 downto 0)) + signed(resize(a_reg,dataw-DW_A)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-2)));
                        else
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "1000"));
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(-(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(t1data_reg(dataw-DW_A-1 downto 0)) + signed(resize(a_reg,dataw-DW_A)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-2))));
                        end if;
                    else
                        -- 0.75
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "1100");
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(shift_right(signed(t1data_reg(dataw-DW_A-1 downto 0)), 1)) + signed(t1data_reg(dataw-DW_A-1 downto 0)) 
                                                                + signed(resize(a_reg,dataw-DW_A)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-1)));
                        else
                            r1data(DW_A-1 downto 0)   <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "1100"));
                            r1data(dataw-1 downto DW_A)       <= std_logic_vector(-(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(shift_right(signed(t1data_reg(dataw-DW_A-1 downto 0)), 1)) + signed(t1data_reg(dataw-DW_A-1 downto 0)) 
                                                                + signed(resize(a_reg,dataw-DW_A)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-1))));
                        end if;
                    end if;

                    -- Resetting internal registers
                    inc_term_frac   <= (others => '0');
                    a_reg           <= (others => '0');
                    t1data_reg      <= (others => '0');
                    compensated_reg <= (others => '0');
                    sign_bit        <= '0';
            end case;
        end if;
    end process;
end rtl;