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
IO(3) = x_scale;
return true;

END_TRIGGER;
END_OPERATION(CORDIC)



OPERATION(COMP_TERM_INIT)
TRIGGER
	int     a_prev     	= INT(1);
	int     n_prev   	= INT(2);
	
    IO(3) = 2*a_prev*n_prev + a_prev*a_prev;
END_TRIGGER;
END_OPERATION(COMP_TERM_INIT)