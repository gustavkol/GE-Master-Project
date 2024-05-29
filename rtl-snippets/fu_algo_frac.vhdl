-- RTL implementation of FU_ALGO_{min} presented in report
--
-- Mapping to operations presented in the thesis:
-- --------------------------------------------------
-- This file               -   Thesis
-- --------------------------------------------------
-- OPC_ALGO_ADD            -   add
-- OPC_ALGO_FRAC           -   compare_and_iter_frac
-- OPC_ALGO_F_INIT         -   compare_and_iter_term
-- OPC_ALGO_MASK_ADD       -   mask_add
-- OPC_ALGO_MERGE          -   merge
-- OPC_ALGO_SHIFT_ADD      -   shift_add
-- OPC_ALGO_SHIFT_SUB      -   shift_sub
-- OPC_ALGO_SUB            -   sub

library IEEE;
use IEEE.std_logic_1164.all;

package algo_frac_opcodes is

  constant OPC_ALGO_ADD       : std_logic_vector(2 downto 0) := "000";
  constant OPC_ALGO_FRAC      : std_logic_vector(2 downto 0) := "001";
  constant OPC_ALGO_F_INIT    : std_logic_vector(2 downto 0) := "010";
  constant OPC_ALGO_MASK_ADD  : std_logic_vector(2 downto 0) := "011";
  constant OPC_ALGO_MERGE     : std_logic_vector(2 downto 0) := "100";
  constant OPC_ALGO_SHIFT_ADD : std_logic_vector(2 downto 0) := "101";
  constant OPC_ALGO_SHIFT_SUB : std_logic_vector(2 downto 0) := "110";
  constant OPC_ALGO_SUB       : std_logic_vector(2 downto 0) := "111";
  
end algo_frac_opcodes;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_misc.all;
use work.algo_frac_opcodes.all;

entity fu_algo_frac is 
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
        r1data : out std_logic_vector(dataw-1 downto 0);

        glock   : in std_logic;
        clk     : in std_logic;
        rstx    : in std_logic
    );
end fu_algo_frac;

architecture rtl of fu_algo_frac is
    signal comp_term                            : signed(dataw-1 downto 0);
    signal int_1, int_4                         : integer;
    signal n_prev_frac, a_sq                    : signed(dataw-1 downto DW_A);
    signal a_prev_frac                          : signed(DW_A-1 downto 0);
    signal a_prev_abs, a_n, a_k                 : signed(8-1 downto 0);
    signal term_025_frac, a_sq_frac, a_sq_int   : signed(dataw-1 downto DW_A);
begin



    --Algorithm signals: fractional
    ALGO_SIGNALS: process(t1data, t2data, t1opcode, rstx) begin
        if (rstx = '0') then
            comp_term     <= (others => '0');
            int_4         <= 0;
            int_1         <= 0;
        else
            if (t1opcode = OPC_ALGO_FRAC) then 
                if(t1data(dataw-1) = '0') then
                    comp_term       <= signed(t1data);
                    int_4           <= 4;
                    int_1           <= 1;
                else
                    comp_term       <= -signed(t1data);
                    int_4           <= -4;
                    int_1           <= -1;
                end if;
            else
                comp_term     <= (others => '0');
                int_4         <= 0;
                int_1         <= 0;
            end if;
        end if;
    end process;

    -- Process calculating 2*a_n^2
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

    -- Process calculating 2*a_n*a_k
    A_SQUARED_INIT: process(a_n, a_k, rstx) begin
        if (rstx = '0') then
            a_sq_int    <= (others => '0');
            a_sq_frac   <= (others => '0');
        else
            -- integer
            case a_n(6 downto 4) is
                when "001"  =>  a_sq_int <= shift_left(resize(a_k,a_sq_int'length),1);                                              -- 2*1*a_k
                when "010"  =>  a_sq_int <= shift_left(resize(a_k,a_sq_int'length),2);                                              -- 2*2*a_k
                when "011"  =>  a_sq_int <= shift_left(resize(a_k,a_sq_int'length),1) + shift_left(resize(a_k,a_sq_int'length),2);  -- 2*3*a_k
                when "100"  =>  a_sq_int <= shift_left(resize(a_k,a_sq_int'length),3);                                              -- 2*4*a_k
                when others =>  a_sq_int <= (others => '0');
            end case;
            -- fraction
            case a_n(3 downto 2) is
                when "01"   =>  a_sq_frac <= resize(shift_right(a_k, 1), a_sq_frac'length);           -- 2*0.25*a_k
                when "10"   =>  a_sq_frac <= resize(a_k, a_sq_frac'length);                           -- 2*0.5*a_k
                when "11"   =>  a_sq_frac <= resize(shift_right(a_k, 1) + a_k, a_sq_frac'length);     -- 2*0.75*a_k
                when others =>  a_sq_frac <= (others => '0');
            end case;
        end if;
    end process;

    --Algorithm expressions: fractional
    a_prev_frac     <= signed(t2data(DW_A-1 downto 0))      when (t1opcode = OPC_ALGO_FRAC and rstx = '1')      else (others => '0');
    n_prev_frac     <= signed(t2data(dataw-1 downto DW_A))  when (t1opcode = OPC_ALGO_FRAC and rstx = '1')      else (others => '0');
    a_prev_abs      <= a_prev_frac                          when a_prev_frac(DW_A-1) = '0'                      else -a_prev_frac;
    
    -- Comparator term
    term_025_frac   <= shift_right(n_prev_frac+int_4, 1) + shift_right(a_prev_frac, 1) + a_prev_frac + to_signed(int_1, term_025_frac'length)       when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');

    -- Algorithm expression: fractional init
    a_k             <= signed(t2data(DW_A-1 downto 0))      when (t1opcode = OPC_ALGO_F_INIT and rstx = '1')      else (others => '0');
    a_n             <= signed(t1data(DW_A-1 downto 0))      when (t1opcode = OPC_ALGO_F_INIT and rstx = '1')      else (others => '0');


    -- Operation logic
    FUNC: process (clk, rstx) begin
        if (rstx = '0') then
            r1data <= (others => '0');
        elsif (clk'event and clk = '1') then
            if (glock = '0' and t1load = '1') then
                case t1opcode is
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
                    when others =>
                end case;
            end if;
        end if;
    end process;
end rtl;