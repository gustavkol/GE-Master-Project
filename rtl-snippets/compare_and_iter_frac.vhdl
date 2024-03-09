if (signed(shift_right(signed(op1), 1)) + signed(shift_left(to_signed(1, op1'length),4-4)) > abs(signed(op2))) then
    -- 0.0
    op3(31 downto 0)   <= (others => '0');
elsif (signed(op1) + signed(shift_left(to_signed(1, op1'length),4-2)) > abs(signed(op2))) then
    -- 0.25
    if (op2(31) = '0') then
        op3(8-1 downto 0)     <= (8-1 downto 4 => '0') & "0100";
        op3(32-1 downto 8)    <= std_logic_vector(signed(shift_right(signed(op1(32-8-1 downto 0)), 1)) + signed(shift_left(to_signed(1, 32-8),4-4)));
    else
        op3(8-1 downto 0)     <= std_logic_vector(resize(-signed(std_logic_vector'("0100")), 8));
        op3(32-1 downto 8)    <= std_logic_vector(-(signed(shift_right(signed(op1(32-8-1 downto 0)), 1)) + signed(shift_left(to_signed(1, 32-8),4-4))));
    end if;
elsif (signed(shift_right(signed(op1), 1)) + signed(op1)) + signed(shift_left(to_signed(1, op1'length),4-4)) + signed(shift_left(to_signed(1, op1'length),4-1)) > abs(signed(op2)) then
    -- 0.5
    if (op2(31) = '0') then
        op3(8-1 downto 0)     <= (8-1 downto 4 => '0') & "1000";
        op3(32-1 downto 8)    <= std_logic_vector(signed(op1(32-8-1 downto 0)) + signed(shift_left(to_signed(1, 32-8),4-2)));
    else
        op3(8-1 downto 0)     <= std_logic_vector(resize(-signed(std_logic_vector'("1000")), 8));
        op3(32-1 downto 8)    <= std_logic_vector(-(signed(op1(32-8-1 downto 0)) + signed(shift_left(to_signed(1, 32-8),4-2))));
    end if;
else
    -- 0.75
    if (op2(31) = '0') then
        op3(8-1 downto 0)     <= (8-1 downto 4 => '0') & "1100";
        op3(32-1 downto 8)    <= std_logic_vector(signed(shift_right(signed(op1(32-8-1 downto 0)), 1)) + signed(op1(32-8-1 downto 0)) 
                                                            + signed(shift_left(to_signed(1, 32-8),4-4)) + signed(shift_left(to_signed(1, 32-8),4-1)));
    else
        op3(8-1 downto 0)     <= std_logic_vector(resize(-signed(std_logic_vector'("1100")), 8));
        op3(32-1 downto 8)    <= std_logic_vector(-(signed(shift_right(signed(op1(32-8-1 downto 0)), 1)) + signed(op1(32-8-1 downto 0)) 
                                                            + signed(shift_left(to_signed(1, 32-8),4-4)) + signed(shift_left(to_signed(1, 32-8),4-1))));
    end if;
end if;