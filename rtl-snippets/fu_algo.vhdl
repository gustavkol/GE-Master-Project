library IEEE;
use IEEE.std_logic_1164.all;

package algo_opcodes is

  constant OPC_ALGO_ADD       : std_logic_vector(2 downto 0) := "000";
  constant OPC_ALGO_FRAC      : std_logic_vector(2 downto 0) := "001";
  constant OPC_ALGO_INIT      : std_logic_vector(2 downto 0) := "010";
  constant OPC_ALGO_INC_COMP  : std_logic_vector(2 downto 0) := "011";
  constant OPC_ALGO_MASK_ADD  : std_logic_vector(2 downto 0) := "100";
  constant OPC_ALGO_SHIFT_ADD : std_logic_vector(2 downto 0) := "101";
  constant OPC_ALGO_SHIFT_SUB : std_logic_vector(2 downto 0) := "110";
  constant OPC_ALGO_SUB       : std_logic_vector(2 downto 0) := "111";
  
end algo_opcodes;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;
use work.algo_opcodes.all;

entity fu_algo is 
    generic (
        DW_FRACTION             : integer := 4;
        DW_A                    : integer := 8;
        dataw                   : integer := 32
    );
    port (
        t1data : in std_logic_vector(dataw-1 downto 0);
        t1load : in std_logic;
        t1opcode : in  std_logic_vector(2 downto 0);
        t2data : in std_logic_vector(dataw-1 downto 0);
        t2load : in std_logic;
        r1data : out std_logic_vector(dataw-1 downto 0);    --a_next & inc_term_next

        glock   : in std_logic;
        clk     : in std_logic;
        rstx    : in std_logic
    );
end fu_algo;

architecture rtl of fu_algo is

    -- FSM
    type states is (Idle, Run);
    signal state, nextState : states;

    -- Internal registers
    signal inc_term_frac, t2data_reg, compensated_reg, comp_term   : signed(dataw-1 downto 0);
    signal a_reg                                        : signed(DW_A-1 downto 0);
    signal sign_bit                                     : std_logic;
    signal int_1, int_4, int_9, int_16                : integer;


    signal n_prev_frac : signed(dataw-1 downto DW_A);
    signal a_prev_frac : signed(DW_A-1 downto 0);
    signal term_025_frac, term_050_frac : signed(dataw-1 downto DW_A);

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
    COMB: process(glock, t1load, t2load, t1opcode, rstx) begin
        if (rstx = '0') then
            nextState <= Idle;
        else
            case state is 
                when Idle   =>      
                    if (glock = '0' and t1load = '1') then 
                        case t1opcode is
                            when OPC_ALGO_INIT  =>  
                                nextState <= Run;
                            when others         =>  
                                nextState <= Idle;
                        end case;
                    end if;
                when Run    =>  nextState <= Idle;
            end case;
        end if;
    end process;

    --Algorithm signals: integer and fractional
    ALGO_SIGNALS: process(t1data, t2data, t1opcode, rstx) begin
       if (rstx = '0') then
           comp_term     <= (others => '0');
           int_16        <= 0;
           int_9         <= 0;
           int_4         <= 0;
           int_1         <= 0;
       else
           if (state = Idle) then 
               if (t1opcode = OPC_ALGO_INIT or t1opcode = OPC_ALGO_FRAC) then 
                    if(t1data(dataw-1) = '0') then
                        comp_term       <= signed(t1data);
                        int_16          <= 16;
                        int_9           <= 9;
                        int_4           <= 4;
                        int_1           <= 1;
                    else
                        comp_term       <= -signed(t1data);
                        int_16          <= -16;
                        int_9           <= -9;
                        int_4           <= -4;
                        int_1           <= -1;
                    end if;
               end if;
           end if;
       end if;
    end process;
    --Algorithm signals: fractional
    a_prev_frac     <= signed(t2data(DW_A-1 downto 0))                                                                                                              when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');
    n_prev_frac     <= signed(t2data(dataw-1 downto DW_A))                                                                                                          when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');
    term_025_frac   <= shift_right(signed(n_prev_frac), 1) + shift_right(signed(a_prev_frac), 1) + shift_left(to_signed(int_1, term_025_frac'length), DW_FRACTION)  when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');
    term_050_frac   <= n_prev_frac + a_prev_frac + shift_left(to_signed(int_4, term_050_frac'length), DW_FRACTION)                                                  when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');

    -- Module logic
    FUNC: process (clk) begin
        if (rstx = '0') then
            inc_term_frac   <= (others => '0');
            a_reg           <= (others => '0');
            t2data_reg      <= (others => '0');
            compensated_reg <= (others => '0');
            sign_bit        <= '0';
        elsif (clk'event and clk = '1') then
            case state is 
                when Idle   => 
                    if (glock = '0' and t1load = '1') then
                        case t1opcode is
                            when OPC_ALGO_INIT  =>
                                sign_bit    <= t1data(dataw-1);
                                t2data_reg  <= signed(t2data);
                                -- INTEGER
                                if (signed(signed(shift_left(signed(t2data), 1)) + shift_left(to_signed(int_1, t2data'length),DW_FRACTION)) > comp_term) then
                                    -- 0
                                    inc_term_frac <= comp_term;
                                elsif (signed(signed(shift_left(signed(t2data), 2)) + shift_left(to_signed(int_4, t2data'length), DW_FRACTION)) > comp_term) then
                                    -- 1
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(1, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - signed(shift_left(signed(t2data), 1)) - signed(shift_left(to_signed(int_1, t2data'length),DW_FRACTION));
                                    compensated_reg                     <= signed(signed(shift_left(signed(t2data), 1)) + shift_left(to_signed(int_1, t2data'length),DW_FRACTION));
                                elsif ((signed(signed(shift_left(signed(t2data), 2)) + signed(shift_left(signed(t2data), 1)) + shift_left(to_signed(int_9, t2data'length),DW_FRACTION))) > comp_term) then
                                    -- 2
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(2, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - signed(shift_left(signed(t2data), 2)) - signed(shift_left(to_signed(int_4, t2data'length),DW_FRACTION));
                                    compensated_reg                     <= signed(signed(shift_left(signed(t2data), 2)) + shift_left(to_signed(int_4, t2data'length), DW_FRACTION));
                                elsif (signed(signed(shift_left(signed(t2data), 3)) + signed(shift_left(to_signed(int_16, t2data'length),DW_FRACTION))) > comp_term) then
                                    -- 3
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(3, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - signed(shift_left(signed(t2data), 2)) - signed(shift_left(signed(t2data), 1)) - signed(shift_left(to_signed(int_9, t2data'length),DW_FRACTION));
                                    compensated_reg                     <= (signed(signed(shift_left(signed(t2data), 2)) + signed(shift_left(signed(t2data), 1)) + shift_left(to_signed(int_9, t2data'length),DW_FRACTION)));
                                else
                                    --4
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(4, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - signed(shift_left(signed(t2data), 3)) - signed(shift_left(to_signed(int_16, t2data'length),DW_FRACTION));
                                    compensated_reg                     <= signed(signed(shift_left(signed(t2data), 3)) + signed(shift_left(to_signed(int_16, t2data'length),DW_FRACTION)));
                                end if;
                            when OPC_ALGO_FRAC  =>
                                if (term_025_frac > comp_term) then
                                    -- 0.0
                                    r1data(dataw-1 downto DW_A)         <= (others => '0');
                                    r1data(DW_A-1 downto 0)             <= std_logic_vector(a_prev_frac);
                                elsif (term_050_frac > comp_term) then
                                    -- 0.25
                                    if(t1data(dataw-1) = '0') then
                                        r1data(DW_A-1 downto 0)         <= std_logic_vector(a_prev_frac + to_signed(4, DW_A));
                                        r1data(dataw-1 downto DW_A)     <= std_logic_vector(term_025_frac);
                                    else
                                        r1data(DW_A-1 downto 0)         <= std_logic_vector(a_prev_frac - to_signed(4, DW_A));
                                        r1data(dataw-1 downto DW_A)     <= std_logic_vector(-term_025_frac);
                                    end if;
                                else
                                    -- 0.50
                                    if(t1data(dataw-1) = '0') then
                                        r1data(DW_A-1 downto 0)         <= std_logic_vector(a_prev_frac + to_signed(8, DW_A));
                                        r1data(dataw-1 downto DW_A)     <= std_logic_vector(term_050_frac);
                                    else
                                        r1data(DW_A-1 downto 0)         <= std_logic_vector(a_prev_frac - to_signed(8, DW_A));
                                        r1data(dataw-1 downto DW_A)     <= std_logic_vector(-term_050_frac);
                                    end if;
                                end if;
                            when OPC_ALGO_MASK_ADD    =>
                              if (t1data(DW_A-1) = '1') then
                                r1data <= std_logic_vector(signed((dataw-1 downto DW_A => '1') & t1data(DW_A-1 downto 0)) + signed(t2data));
                              else
                                r1data <= std_logic_vector(signed((dataw-1 downto DW_A => '0') & t1data(DW_A-1 downto 0)) + signed(t2data));
                              end if;
                            when OPC_ALGO_SHIFT_ADD   =>
                                r1data <= std_logic_vector(shift_right(signed(t1data), DW_A) + signed(t2data));
                            when OPC_ALGO_SHIFT_SUB   =>
                                r1data <= std_logic_vector(signed(t2data) - shift_right(signed(t1data), DW_A));
                            when OPC_ALGO_ADD         => 
                              r1data <= std_logic_vector(signed(t1data) + signed(t2data));
                            when OPC_ALGO_SUB         => 
                              r1data <= std_logic_vector(signed(t1data) - signed(t2data));
                            when OPC_ALGO_INC_COMP    =>
                              if (signed(t2data) < 0) then
                                  r1data <= std_logic_vector(signed(t1data) - signed(shift_left(signed(t2data),1)));
                              else
                                  r1data <= std_logic_vector(signed(t1data) + signed(shift_left(signed(t2data),1)));
                              end if;
                            when others =>  null;
                        end case;
                    end if;
                when Run    =>  
                    -- FRACTION (FRACTIONAL PART CAN BE CONCATENATED INSTEAD OF ADDED)                  ||||||||||||||||||||||||
                    if (signed(shift_right(signed(t2data_reg), 1)) + to_signed(1, t2data_reg'length) > inc_term_frac) then  -- 2*0.25*N_prev + 0.25^2
                        -- 0.0
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "0000");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(compensated_reg(dataw-DW_A-1 downto 0));
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "0000"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(-signed(compensated_reg(dataw-DW_A-1 downto 0)));
                        end if;

                    elsif (signed(t2data_reg) + signed(shift_left(to_signed(1, t2data_reg'length),DW_FRACTION-2)) > inc_term_frac) then
                        -- 0.25
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "0100");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) + signed(shift_right(signed(t2data_reg(dataw-DW_A-1 downto 0)), 1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)));
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "0100"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(signed(-signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) - signed(shift_right(signed(t2data_reg(dataw-DW_A-1 downto 0)), 1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4))));
                        end if;
                    elsif (signed(shift_right(signed(t2data_reg), 1)) + signed(t2data_reg)) + signed(shift_left(to_signed(1, t2data_reg'length),DW_FRACTION-4)) + signed(shift_left(to_signed(1, t2data_reg'length),DW_FRACTION-1)) > inc_term_frac then
                        -- 0.5
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "1000");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(t2data_reg(dataw-DW_A-1 downto 0)) + signed(resize(a_reg,dataw-DW_A)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-2)));
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "1000"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(signed(-signed(compensated_reg(dataw-DW_A-1 downto 0)) - signed(t2data_reg(dataw-DW_A-1 downto 0)) + signed(resize(a_reg,dataw-DW_A)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-2))));
                        end if;
                    else
                        -- 0.75
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "1100");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(signed(compensated_reg(dataw-DW_A-1 downto 0)) + signed(shift_right(signed(t2data_reg(dataw-DW_A-1 downto 0)), 1)) + signed(t2data_reg(dataw-DW_A-1 downto 0)) 
                                                                + signed(resize(a_reg,dataw-DW_A)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-1)));
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "1100"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(signed(-signed(compensated_reg(dataw-DW_A-1 downto 0)) - signed(shift_right(signed(t2data_reg(dataw-DW_A-1 downto 0)), 1)) - signed(t2data_reg(dataw-DW_A-1 downto 0)) 
                                                                + signed(resize(a_reg,dataw-DW_A)) + signed(shift_right(resize(a_reg,dataw-DW_A),1)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-4)) + signed(shift_left(to_signed(1, dataw-DW_A),DW_FRACTION-1))));
                        end if;
                    end if;

                    -- Resetting internal registers
                    inc_term_frac   <= (others => '0');
                    a_reg           <= (others => '0');
                    t2data_reg      <= (others => '0');
                    compensated_reg <= (others => '0');
                    sign_bit        <= '0';
            end case;
        end if;
    end process;
end rtl;