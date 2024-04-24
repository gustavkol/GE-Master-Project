library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package algo_opcodes is

  constant OPC_ALGO_ADD       : std_logic_vector(3 downto 0) := "0000";
  constant OPC_ALGO_FRAC      : std_logic_vector(3 downto 0) := "0001";
  constant OPC_ALGO_F_INIT    : std_logic_vector(3 downto 0) := "0010";
  constant OPC_ALGO_INIT      : std_logic_vector(3 downto 0) := "0011";
  constant OPC_ALGO_MASK_ADD  : std_logic_vector(3 downto 0) := "0100";
  constant OPC_ALGO_MERGE     : std_logic_vector(3 downto 0) := "0101";
  constant OPC_ALGO_SHIFT_ADD : std_logic_vector(3 downto 0) := "0110";
  constant OPC_ALGO_SHIFT_SUB : std_logic_vector(3 downto 0) := "0111";
  constant OPC_ALGO_SUB       : std_logic_vector(3 downto 0) := "1000";
  
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
        t1opcode : in  std_logic_vector(3 downto 0);
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
    signal inc_term_frac, n_prev_reg, compensated_reg, comp_term        : signed(dataw-1 downto 0);
    signal a_reg                                                        : signed(DW_A-1 downto 0);
    signal sign_bit                                                     : std_logic;
    signal int_1, int_4, int_8, int_9, int_12, int_16, int_32, int_48, int_64       : integer;

    signal term_1_int, term_2_int, term_3_int, term_4_int               : signed(dataw-1 downto 0);

    signal n_prev_frac, a_sq, term_025_int, term_050_int, term_075_int  : signed(dataw-1 downto DW_A);
    signal a_prev_frac                                                  : signed(DW_A-1 downto 0);
    signal a_prev_abs, a_n, a_k                                         : signed(8-1 downto 0);
    signal term_025_frac, a_sq_frac, a_sq_int                           : signed(dataw-1 downto DW_A);
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

    --Algorithm signals: common for integer and fractional
    ALGO_SIGNALS: process(t1data, t2data, t1opcode, state, rstx) begin
       if (rstx = '0') then
            comp_term       <= (others => '0');
            int_64          <= 0;
            int_48          <= 0;
            int_32          <= 0;
            int_16          <= 0;
            int_12          <= 0;
            int_9           <= 0;
            int_8           <= 0;
            int_4           <= 0;
            int_1           <= 0;
       else
            if (state = Run) then 
                if(sign_bit = '0') then
                    comp_term       <= signed(t1data);
                    int_64          <= 64;
                    int_48          <= 48;
                    int_32          <= 32;
                    int_16          <= 16;
                    int_12          <= 12;
                    int_9           <= 9;
                    int_8           <= 8;
                    int_4           <= 4;
                    int_1           <= 1;
                else
                    comp_term       <= -signed(t1data);
                    int_64          <= -64;
                    int_48          <= -48;
                    int_32          <= -32;
                    int_16          <= -16;
                    int_12          <= -12;
                    int_9           <= -9;
                    int_8           <= -8;
                    int_4           <= -4;
                    int_1           <= -1;
                end if;
            elsif (t1opcode = OPC_ALGO_INIT or t1opcode = OPC_ALGO_FRAC) then 
                if(t1data(dataw-1) = '0') then
                    comp_term       <= signed(t1data);
                    int_64          <= 64;
                    int_48          <= 48;
                    int_32          <= 32;
                    int_16          <= 16;
                    int_12          <= 12;
                    int_9           <= 9;
                    int_8           <= 8;
                    int_4           <= 4;
                    int_1           <= 1;
                else
                    comp_term       <= -signed(t1data);
                    int_64          <= -64;
                    int_48          <= -48;
                    int_32          <= -32;
                    int_16          <= -16;
                    int_12          <= -12;
                    int_9           <= -9;
                    int_8           <= -8;
                    int_4           <= -4;
                    int_1           <= -1;
                end if;
            end if;
       end if;
    end process;

    A_SQUARED: process(a_prev_abs, rstx) begin
        if (rstx = '0') then
            a_sq <= (others => '0');
        else
            case a_prev_abs(6 downto 2) is
                when "00001" =>  a_sq <= to_signed(2, a_sq'length);   -- 0.25
                when "00010" =>  a_sq <= to_signed(8, a_sq'length);   -- 0.5
                when "00011" =>  a_sq <= to_signed(18, a_sq'length);  -- 0.75
                when "00100" =>  a_sq <= to_signed(32, a_sq'length);  -- 1.0
                when "00101" =>  a_sq <= to_signed(50, a_sq'length);  -- 1.25
                when "00110" =>  a_sq <= to_signed(72, a_sq'length);  -- 1.5
                when "00111" =>  a_sq <= to_signed(98, a_sq'length);  -- 1.75
                when "01000" =>  a_sq <= to_signed(128, a_sq'length); -- 2.0
                when "01001" =>  a_sq <= to_signed(162, a_sq'length); -- 2.25
                when "01010" =>  a_sq <= to_signed(200, a_sq'length); -- 2.5
                when "01011" =>  a_sq <= to_signed(242, a_sq'length); -- 2.75
                when "01100" =>  a_sq <= to_signed(288, a_sq'length); -- 3.0
                when "01101" =>  a_sq <= to_signed(338, a_sq'length); -- 3.25
                when "01110" =>  a_sq <= to_signed(392, a_sq'length); -- 3.5
                when "01111" =>  a_sq <= to_signed(450, a_sq'length); -- 3.75
                when "10000" =>  a_sq <= to_signed(512, a_sq'length); -- 4.0
                when others  =>  a_sq <= (others => '0');
            end case;
        end if;
    end process;

    A_SQUARED_INIT: process(a_n, rstx) begin
        if (rstx = '0') then
            a_sq_int    <= (others => '0');
            a_sq_frac   <= (others => '0');
        else
            -- integer
            case a_n(6 downto 4) is
                when "001"  =>  a_sq_int <= shift_left(a_k, 1);                         -- 2*1*a_k
                when "010"  =>  a_sq_int <= shift_left(a_k, 2);                         -- 2*2*a_k
                when "011"  =>  a_sq_int <= shift_left(a_k, 1) + shift_left(a_k, 2);    -- 2*3*a_k
                when "100"  =>  a_sq_int <= shift_left(a_k, 3);                         -- 2*4*a_k
                when others =>  a_sq_int <= (others => '0');
            end case;
            -- fraction
            case a_n(3 downto 2) is
                when "01"   =>  a_sq_frac <= shift_right(a_k, 1);           -- 2*0.25*a_k
                when "10"   =>  a_sq_frac <= a_k;                           -- 2*0.5*a_k
                when "11"   =>  a_sq_frac <= shift_right(a_k, 1) + a_k;     -- 2*0.75*a_k
                when others =>  a_sq_frac <= (others => '0');
            end case;
        end if;
    end process;


    --Algorithm expressions: fractional
    a_prev_frac     <= signed(t2data(DW_A-1 downto 0))      when (t1opcode = OPC_ALGO_FRAC and rstx = '1')      else (others => '0');
    n_prev_frac     <= signed(t2data(dataw-1 downto DW_A))  when (t1opcode = OPC_ALGO_FRAC and rstx = '1')      else (others => '0');
    a_prev_abs      <= a_prev_frac                          when a_prev_frac(DW_A-1) = '0'                      else -a_prev_frac;

    term_025_frac   <= shift_right(n_prev_frac+int_4, 1) + shift_right(a_prev_frac, 1) + a_prev_frac + to_signed(int_1, term_025_frac'length)       when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');
    
    --Algorithm expressions: integer
    term_1_int      <= shift_left(signed(t2data)+int_16, 1) + shift_left(to_signed(int_1, t2data'length),DW_FRACTION)                                        when (t1opcode = OPC_ALGO_INIT and rstx = '1') else (others => '0'); 
    term_2_int      <= shift_left(signed(t2data)+int_32, 2) + shift_left(to_signed(int_4, t2data'length), DW_FRACTION)                                       when (t1opcode = OPC_ALGO_INIT and rstx = '1') else (others => '0');
    term_3_int      <= shift_left(signed(t2data)+int_48, 2) + shift_left(signed(t2data)+int_48, 1) + shift_left(to_signed(int_9, t2data'length),DW_FRACTION) when (t1opcode = OPC_ALGO_INIT and rstx = '1') else (others => '0');
    term_4_int      <= shift_left(signed(t2data)+int_64, 3) + shift_left(to_signed(int_16, t2data'length),DW_FRACTION)                                       when (t1opcode = OPC_ALGO_INIT and rstx = '1') else (others => '0');

    term_025_int    <= to_signed(int_1, dataw-DW_A) + resize(a_reg,dataw-DW_A) + shift_right(int_4+n_prev_reg(dataw-DW_A-1 downto 0), 1)                     when (state = Run and rstx = '1') else (others => '0');
    term_050_int    <= to_signed(int_4, dataw-DW_A) + shift_left(resize(a_reg,dataw-DW_A),1) + int_8 + n_prev_reg(dataw-DW_A-1 downto 0)                     when (state = Run and rstx = '1') else (others => '0');
    term_075_int    <= to_signed(int_9, dataw-DW_A) + shift_left(resize(a_reg,dataw-DW_A),1) + resize(a_reg,dataw-DW_A) 
                                                    + n_prev_reg(dataw-DW_A-1 downto 0) + int_12 + shift_right(int_12+n_prev_reg(dataw-DW_A-1 downto 0), 1)  when (state = Run and rstx = '1') else (others => '0');

    -- Algorithm expression: fractional init
    a_k             <= signed(t2data(DW_A-1 downto 0))      when (t1opcode = OPC_ALGO_F_INIT and rstx = '1')      else (others => '0');
    a_n             <= signed(t1data(DW_A-1 downto 0))      when (t1opcode = OPC_ALGO_F_INIT and rstx = '1')      else (others => '0');
                                                  

    -- Module logic
    FUNC: process (clk) begin
        if (rstx = '0') then
            inc_term_frac   <= (others => '0');
            a_reg           <= (others => '0');
            n_prev_reg      <= (others => '0');
            compensated_reg <= (others => '0');
            sign_bit        <= '0';
        elsif (clk'event and clk = '1') then
            case state is 
                when Idle   => 
                    if (glock = '0' and t1load = '1') then
                        case t1opcode is
                            when OPC_ALGO_INIT  =>
                                sign_bit    <= t1data(dataw-1);
                                -- INTEGER
                                if (term_1_int > comp_term) then
                                    -- 0
                                    inc_term_frac <= comp_term;
                                    n_prev_reg    <= signed(t2data);
                                elsif (term_2_int > comp_term) then
                                    -- 1
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(1, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - term_1_int;
                                    compensated_reg                     <= term_1_int;
                                    n_prev_reg                          <= signed(t2data)+int_16;
                                elsif (term_3_int > comp_term) then
                                    -- 2
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(2, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - term_2_int;
                                    compensated_reg                     <= term_2_int;
                                    n_prev_reg                          <= signed(t2data)+int_32;
                                elsif (term_4_int > comp_term) then
                                    -- 3
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(3, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - term_3_int;
                                    compensated_reg                     <= term_3_int;
                                    n_prev_reg                          <= signed(t2data)+int_48;
                                else
                                    --4
                                    a_reg(DW_A-1 downto DW_FRACTION)    <= to_signed(4, a_reg'length-DW_FRACTION);
                                    inc_term_frac                       <= comp_term - term_4_int;
                                    compensated_reg                     <= term_4_int;
                                    n_prev_reg                          <= signed(t2data)+int_64;
                                end if;
                            when OPC_ALGO_FRAC  =>
                                if (term_025_frac > comp_term) then
                                    -- 0.0
                                    r1data(dataw-1 downto DW_A)         <= (others => '0');
                                    r1data(DW_A-1 downto 0)             <= std_logic_vector(a_prev_frac);
                                    r1data(dataw-1 downto DW_A)         <= std_logic_vector(a_sq);
                                else
                                    -- 0.25
                                    if(t1data(dataw-1) = '0') then
                                        r1data(DW_A-1 downto 0)         <= std_logic_vector(a_prev_frac + to_signed(4, DW_A));
                                        r1data(dataw-1 downto DW_A)     <= std_logic_vector(term_025_frac + a_sq);
                                    else
                                        r1data(DW_A-1 downto 0)         <= std_logic_vector(a_prev_frac - to_signed(4, DW_A));
                                        r1data(dataw-1 downto DW_A)     <= std_logic_vector(a_sq - term_025_frac);
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
                            when OPC_ALGO_MERGE       =>
                              r1data <= t2data(dataw-DW_A-1 downto 0) & t1data(DW_A-1 downto 0);
                            when OPC_ALGO_F_INIT      =>
                              r1data(DW_A-1 downto 0)       <= std_logic_vector(a_n);
                              r1data(dataw-1 downto DW_A)   <= std_logic_vector(a_sq_int + a_sq_frac);
                            when others =>  null;
                        end case;
                    end if;
                when Run    =>  
                    if (term_025_int > inc_term_frac) then  -- 2*0.25*N_prev + 0.25^2
                        -- 0.0
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "0000");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(compensated_reg(dataw-DW_A-1 downto 0));
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "0000"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(-compensated_reg(dataw-DW_A-1 downto 0));
                        end if;

                    elsif (term_050_int > inc_term_frac) then -- 2*0.5*N_prev + 0.5^2
                        -- 0.25
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "0100");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(compensated_reg(dataw-DW_A-1 downto 0) + term_025_int);
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "0100"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(-compensated_reg(dataw-DW_A-1 downto 0) - term_025_int);
                        end if;
                    elsif (term_075_int > inc_term_frac) then -- 2*0.75*N_prev + 0.75^2
                        -- 0.5
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "1000");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(compensated_reg(dataw-DW_A-1 downto 0) + term_050_int);
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "1000"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(-compensated_reg(dataw-DW_A-1 downto 0) - term_050_int);
                        end if;
                    else
                        -- 0.75
                        if (sign_bit = '0') then
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(a_reg(DW_A-1 downto DW_FRACTION) & "1100");
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(compensated_reg(dataw-DW_A-1 downto 0) + term_075_int);
                        else
                            r1data(DW_A-1 downto 0)         <= std_logic_vector(-signed(a_reg(DW_A-1 downto DW_FRACTION) & "1100"));
                            r1data(dataw-1 downto DW_A)     <= std_logic_vector(-compensated_reg(dataw-DW_A-1 downto 0) - term_075_int);
                        end if;
                    end if;

                    -- Resetting internal registers
                    inc_term_frac   <= (others => '0');
                    a_reg           <= (others => '0');
                    n_prev_reg      <= (others => '0');
                    compensated_reg <= (others => '0');
                    sign_bit        <= '0';
            end case;
        end if;
    end process;
end rtl;