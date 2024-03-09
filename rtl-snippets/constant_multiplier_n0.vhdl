-- (f_s/v_s) * 10^-3 = 16.234
op3      <= std_logic_vector(unsigned(shift_left(unsigned(op1),4+4)) + unsigned(shift_left(unsigned(op1),4-2)) - unsigned(shift_right(unsigned(op1),6-4)));