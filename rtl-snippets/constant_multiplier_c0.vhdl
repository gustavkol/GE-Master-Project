-- (2*p*(f_s/v_s)^2) * 10^-3 = 131.767 = 0b0100000111100
op3      <= std_logic_vector(unsigned(shift_left(unsigned(op1),7+4)) + unsigned(shift_left(unsigned(op1),1+4)) + unsigned(shift_left(unsigned(op1),0+4))
                            + unsigned(shift_left(unsigned(op1),4-1)) + unsigned(shift_left(unsigned(op1),4-2)));