#include "OSAL.hh"

OPERATION(CORDIC)
TRIGGER

signed int     angle     = INT(1);
signed int     x_scale   = INT(2);

signed int     y_cur_reg = 0;
unsigned int   iterations = 11;
signed int     sign_increment = 0;
signed int     sign_bit;

const int rotated_angle_array[11] = {
    0b0101101000000,   // 45
    0b0011010100100,  // 26.5625
    0b0001110001000,  // 14.125
    0b0000111001000,  // 7.125
    0b0000011100100,  // 3.5625
    0b0000001110000,  // 1.75
    0b0000000111000,  // 0.875
    0b0000000011100,  // 0.4375
    0b0000000010000,  // 0.25
    0b0000000000111,  // 0.109375
    0b0000000000011  // 0.05595
};

// Initializing
x_scale       = (x_scale >> 1) + (x_scale >> 4) + (x_scale >> 5) + (x_scale >> 6); // K_n = 0.6088 ~ 0.609375 = 2^-1 + 2^-4 + 2^-5 + 2^-6
if (angle > 90) {
    angle       = (180 - angle) << 6;
    sign_bit    = -1;
}
else {
    angle       = angle << 6;
    sign_bit    = 1;
}

// Iterations
for (int iter = 0; iter < iterations; ++iter) {
    if (sign_increment == 0) {   // +
        x_scale         = x_scale - (y_cur_reg >> iter);
        y_cur_reg       = y_cur_reg + (x_scale >> iter);
        angle           = angle - rotated_angle_array[iter];
    }
    else {                          //-
        x_scale         = x_scale + (y_cur_reg >> iter);
        y_cur_reg       = y_cur_reg - (x_scale >> iter);
        angle           = angle + rotated_angle_array[iter];
    }

    if (angle >= 0)
        sign_increment    = 0;
    else
        sign_increment    = 1;
}

//IO(3) = static_cast<signed> (x_scale);
IO(3) = static_cast<signed> (x_scale);
return true;

END_TRIGGER;
END_OPERATION(CORDIC)



OPERATION(COMPARE_AND_ITER)
TRIGGER
	int     a_n_prev    = INT(1);   // a_prev + n_prev
	int     inc_term   	= INT(2);   // inc_term_w_error - inc_term_prev

    int inc_step = 0b0100;
    int sign_bit = (inc_term >= 0) ? 1 : -1;

    int delta_a;
    int compensated_term;

    if (sign_bit == -1) {
        do {
            delta_a -= inc_step;                                  
            compensated_term -= (a_n_prev >> 1) + (inc_step >> 1);
        } while (compensated_term > inc_term);

        compensated_term += (a_n_prev >> 1) + (inc_step >> 1);
        delta_a += inc_step;  
    } else {
        do {
            delta_a += inc_step;
            compensated_term += (a_n_prev >> 1) + (inc_step >> 1);
        } while (compensated_term < inc_term);

        compensated_term -= (a_n_prev >> 1) + (inc_step >> 1);
        delta_a -= inc_step;       
    }

	
	int result = (delta_a << 24) | (compensated_term  & 0x00FFFFFF); // a_next & inc_term_next
    IO(3) = static_cast<signed> (result);
END_TRIGGER;
END_OPERATION(COMPARE_AND_ITER)


OPERATION(COMPARE_AND_ITER_F)
TRIGGER
	int     a_n_prev    = INT(1);   // a_prev + n_prev
	int     inc_term   	= INT(2);   // inc_term_w_error - inc_term_prev

    int inc_step = 0b0100;
    int sign_bit = (inc_term >= 0) ? 1 : -1;

    int delta_a;
    int compensated_term;

    if (sign_bit == -1) {
        do {
            delta_a -= inc_step;                                  
            compensated_term -= (a_n_prev >> 1) + (inc_step >> 1);
        } while (compensated_term > inc_term);

        compensated_term += (a_n_prev >> 1) + (inc_step >> 1);
        delta_a += inc_step;  
    } else {
        do {
            delta_a += inc_step;
            compensated_term += (a_n_prev >> 1) + (inc_step >> 1);
        } while (compensated_term < inc_term);

        compensated_term -= (a_n_prev >> 1) + (inc_step >> 1);
        delta_a -= inc_step;       
    }

	int result = (delta_a << 24) | (compensated_term  & 0x00FFFFFF); // a_next & inc_term_next
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(COMPARE_AND_ITER_F)






OPERATION(CONST_MULT_BN)
TRIGGER
	int     a     	= INT(1);
	int     b   	= INT(2);
	
    int result = (a << 5+4) + (a << 4-1) - (a >> 5-4) - (a >> 10-4);
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(CONST_MULT_BN)

OPERATION(CONST_MULT_C0)
TRIGGER
	int     a     	= INT(1);
	int     b   	= INT(2);

    int result = (a << 7+4) + (a << 1+4) + (a << 0+4) + (a << 4-1) + (a << 4-2);
	
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(CONST_MULT_C0)

OPERATION(CONST_MULT_N0)
TRIGGER
	int     a     	= INT(1);
	int     b   	= INT(2);

    int result = (a << 4+4) + (a << 4-2) - (a >> 6-4);

    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(CONST_MULT_N0)



OPERATION(MASK_ADD)
TRIGGER
	int     a     	= INT(1);
	int     b   	= INT(2);

    a = (a << 24);
    a = (a >> 24);

    int result = a + b;
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(MASK_ADD)

OPERATION(SHIFT_ADD)
TRIGGER
	int     a     	= INT(1);
	int     b   	= INT(2);

    a = (a >> 8);

    int result = a + b;
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(SHIFT_ADD)
