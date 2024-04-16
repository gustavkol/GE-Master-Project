library IEEE;
use IEEE.std_logic_1164.all;

package algo_frac_opcodes is

  constant OPC_ALGO_ADD       : std_logic_vector(2 downto 0) := "000";
  constant OPC_ALGO_FRAC      : std_logic_vector(2 downto 0) := "001";
  constant OPC_ALGO_INC_COMP  : std_logic_vector(2 downto 0) := "010";
  constant OPC_ALGO_MASK_ADD  : std_logic_vector(2 downto 0) := "011";
  constant OPC_ALGO_SHIFT_ADD : std_logic_vector(2 downto 0) := "100";
  constant OPC_ALGO_SHIFT_SUB : std_logic_vector(2 downto 0) := "101";
  constant OPC_ALGO_SUB       : std_logic_vector(2 downto 0) := "110";
  
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
    signal comp_term                    : signed(dataw-1 downto 0);
    signal int_1, int_4, int_9, int_16  : integer;
    signal n_prev_frac                  : signed(dataw-1 downto DW_A);
    signal a_prev_frac                  : signed(DW_A-1 downto 0);
    signal term_025_frac, term_050_frac : signed(dataw-1 downto DW_A);
begin



    --Algorithm signals: fractional
    ALGO_SIGNALS: process(t1data, t2data, t1opcode, rstx) begin
        if (rstx = '0') then
            comp_term     <= (others => '0');
            int_16        <= 0;
            int_9         <= 0;
            int_4         <= 0;
            int_1         <= 0;
        else
            if (t1opcode = OPC_ALGO_FRAC) then 
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
    end process;

    a_prev_frac     <= signed(t2data(DW_A-1 downto 0))                                                                                                              when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');
    n_prev_frac     <= signed(t2data(dataw-1 downto DW_A))                                                                                                          when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');
    term_025_frac   <= shift_right(signed(n_prev_frac), 1) + shift_right(signed(a_prev_frac), 1) + shift_left(to_signed(int_1, term_025_frac'length), DW_FRACTION)  when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');
    term_050_frac   <= n_prev_frac + a_prev_frac + shift_left(to_signed(int_4, term_050_frac'length), DW_FRACTION)                                                  when (t1opcode = OPC_ALGO_FRAC and rstx = '1') else (others => '0');


    -- Module logic
    FUNC: process (clk) begin
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
        end if;
    end process;
end rtl;