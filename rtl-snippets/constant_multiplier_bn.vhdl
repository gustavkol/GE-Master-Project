-- 2 * f_s / v_s = 32.468
op3      <= std_logic_vector(unsigned(shift_left(unsigned(op1),5+4)) + unsigned(shift_left(unsigned(op1),4-1)) 
                            - unsigned(shift_right(unsigned(op1),5-4)) - unsigned(shift_right(unsigned(op1),10-4))); 
