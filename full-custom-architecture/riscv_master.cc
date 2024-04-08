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

if (sign_bit = -1) {
    x_scale = -x_scale;
}

IO(3) = static_cast<signed> (x_scale);
return true;

END_TRIGGER;
END_OPERATION(CORDIC)



OPERATION(COMPARE_AND_ITER_INT)
TRIGGER
	signed int a_n_prev = INT(2);   // a_prev + n_prev
	signed int inc_term = INT(1);   // inc_term_w_error - inc_term_prev

    signed int delta_a = 0;
    signed int compensated_term = 0;
    signed int fractional_inc_term = 0;

    if (inc_term < 0) {
        if (((1 << 4) - (a_n_prev << 1)) < inc_term) {  // < 1
            delta_a = 0;
            compensated_term = 0;
        } else if (((4 << 4) - (a_n_prev << 2)) < inc_term) { // < 2
            delta_a = -(1 << 4);
            compensated_term = (1 << 4) - (a_n_prev << 1);
        } else if (((9 << 4) - (a_n_prev << 1) - (a_n_prev << 2)) < inc_term) { // < 3
            delta_a = -(2 << 4);
            compensated_term = (4 << 4) - (a_n_prev << 2);
        } else if (((16 << 4) - (a_n_prev << 3)) < inc_term) { // < 4
            delta_a = -(3 << 4);
            compensated_term = (9 << 4) - (a_n_prev << 1) - (a_n_prev << 2);
        } else {
            delta_a = -(4 << 4);
            compensated_term = (16 << 4) - (a_n_prev << 3);
        }

        fractional_inc_term = inc_term - compensated_term;

        if (((1 << 2) - (a_n_prev >> 1)) < fractional_inc_term) { // < 0.25
            delta_a = delta_a - 0;
            compensated_term = compensated_term + 0;
        } else if (((1 << 3) - a_n_prev) < fractional_inc_term) { // < 0.5
            delta_a = delta_a - (1 << 2);
            compensated_term = compensated_term + ((1 << 2) - (a_n_prev >> 1));
        } else if (((1 << 3) + 1 - a_n_prev - (a_n_prev >> 1)) < fractional_inc_term) { // < 0.75
            delta_a = delta_a - (1 << 3);
            compensated_term = compensated_term + ((1 << 3) - a_n_prev);
        } else {
            delta_a = delta_a - (1 << 2) - (1 << 3);
            compensated_term = compensated_term + ((1 << 3) + 1 - a_n_prev - (a_n_prev >> 1));
        }
    } else {
        if (((1 << 4) + (a_n_prev << 1)) > inc_term) {
            delta_a = 0;
            compensated_term = 0;
        } else if (((4 << 4) + (a_n_prev << 2)) > inc_term) {
            delta_a = (1 << 4);
            compensated_term = (1 << 4) + (a_n_prev << 1);
        } else if (((9 << 4) + (a_n_prev << 1) + (a_n_prev << 2)) > inc_term) {
            delta_a = (2 << 4);
            compensated_term = (4 << 4) + (a_n_prev << 2);
        } else if (((16 << 4) + (a_n_prev << 3)) > inc_term) {
            delta_a = (3 << 4);
            compensated_term = (9 << 4) + (a_n_prev << 1) + (a_n_prev << 2);
        } else {
            delta_a = (4 << 4);
            compensated_term = (16 << 4) + (a_n_prev << 3);
        }

        fractional_inc_term = inc_term - compensated_term;

        if (((1 << 2) + (a_n_prev >> 1)) > fractional_inc_term) { // 0.25
            delta_a = delta_a + 0;
            compensated_term = compensated_term + 0;
        } else if (((1 << 3) + a_n_prev) > fractional_inc_term) { // 0.5
            delta_a = delta_a + (1 << 2);
            compensated_term = compensated_term + ((1 << 2) + (a_n_prev >> 1));
        } else if (((1 << 3) + 1 + a_n_prev + (a_n_prev >> 1)) > fractional_inc_term) { // 0.75
            delta_a = delta_a + (1 << 3);
            compensated_term = compensated_term + ((1 << 3) + a_n_prev);
        } else {
            delta_a = delta_a + (1 << 2) + (1 << 3);
            compensated_term = compensated_term + ((1 << 3) + 1 + a_n_prev + (a_n_prev >> 1));
        }      
    }

	
	signed int result = (compensated_term  << 8) | (delta_a & 0x000000FF); // a_next & inc_term_next
    IO(3) = static_cast<signed> (result);
END_TRIGGER;
END_OPERATION(COMPARE_AND_ITER_INT)


OPERATION(COMPARE_AND_ITER_F)
TRIGGER
	signed int a_n_prev = INT(2);   // a_prev + n_prev
	signed int inc_term = INT(1);   // inc_term_w_error - inc_term_prev

    signed int delta_a = 0;
    signed int compensated_term = 0;

    if (inc_term < 0) {
        if (((1 << 2) - (a_n_prev >> 1)) < inc_term) { // 0.25
            delta_a = 0;
            compensated_term = 0;
        } else if (((1 << 3) - a_n_prev) < inc_term) { // 0.5
            delta_a = -(1 << 2);
            compensated_term = (1 << 2) - (a_n_prev >> 1);
        } else if (((1 << 3) + 1 - a_n_prev - (a_n_prev >> 1)) < inc_term) { // 0.75
            delta_a = -(1 << 3);
            compensated_term = (1 << 3) - a_n_prev;
        } else {
            delta_a = -(1 << 2) - (1 << 3);
            compensated_term = (1 << 3) + 1 - a_n_prev - (a_n_prev >> 1);
        }
            
    } else {
        if (((1 << 2) + (a_n_prev >> 1)) > inc_term) { // 0.25
            delta_a = 0;
            compensated_term = 0;
        } else if (((1 << 3) + a_n_prev) > inc_term) { // 0.5
            delta_a = (1 << 2);
            compensated_term = ((1 << 2) + (a_n_prev >> 1));
        } else if (((1 << 3) + 1 + a_n_prev + (a_n_prev >> 1)) > inc_term) { // 0.75
            delta_a = (1 << 3);
            compensated_term = ((1 << 3) + a_n_prev);
        } else {
            delta_a = (1 << 2) + (1 << 3);
            compensated_term = ((1 << 3) + 1 + a_n_prev + (a_n_prev >> 1));
        }      
    }

	signed int result = (compensated_term  << 8) | (delta_a & 0x000000FF); // a_next & inc_term_next
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
	int  a = INT(1);
	int  b = INT(2);

    a = (a << 24);
    a = (a >> 24);

    int result = a + b;
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(MASK_ADD)

OPERATION(SHIFT_ADD)
TRIGGER
	int a = INT(1);
	int b = INT(2);

    a = (a >> 8);

    int result = a + b;
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(SHIFT_ADD)


OPERATION(SHIFT_SUB)
TRIGGER
	signed int a = INT(1);
	signed int b = INT(2);

    a = (a >> 8);

    signed int result = b - a;
    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(SHIFT_SUB)

OPERATION(INC_COMP_32)
TRIGGER
	signed int inc_term = INT(1);
	signed int a_prev   = INT(2);

    signed int a_prev_sq = 0;
    if (a_prev & 0x0000000F == 0b0100) {
        a_prev_sq += 0b00001;
    } else if (a_prev & 0x0000000F == 0b1000) {
        a_prev_sq += 0b00100;
    } else if (a_prev & 0x0000000F == 0b1100) {
        a_prev_sq += 0b01001;
    }

    if ((a_prev >> 4) == 0b0100) {    // 4^2
        a_prev_sq = a_prev_sq + (16 << 4);
    } else if ((a_prev >> 4) == 0b0011) {
        a_prev_sq = a_prev_sq + (9 << 4);
    } else if ((a_prev >> 4) == 0b0010) {
        a_prev_sq = a_prev_sq + (4 << 4);
    } else if ((a_prev >> 4) == 0b0001) {
        a_prev_sq = a_prev_sq + (1 << 4);
    }

    signed int result = inc_term + 32;
    if (a_prev < 0)
        result -= a_prev_sq;
    else
        result += a_prev_sq;

    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(INC_COMP_32)

OPERATION(INC_COMP_NEXT)
TRIGGER
	signed int inc_term = INT(1);
	signed int a_prev   = INT(2);

    signed int a_prev_sq = 0;
    if ((a_prev & 0x0000000F) == 12) {
        a_prev_sq = 9; // 0.5625
    } else if ((a_prev & 0x0000000F) == 8) {
        a_prev_sq = 4;  // 0.25
    } else if ((a_prev & 0x0000000F) == 4) {
        a_prev_sq = 1;  // 0.0625
    }


    if ((a_prev >> 4) == 4) {    // 4^2
        a_prev_sq = a_prev_sq + (16 << 4);
    } else if ((a_prev >> 4) == 3) {
        a_prev_sq = a_prev_sq + (9 << 4);
    } else if ((a_prev >> 4) == 2) {
        a_prev_sq = a_prev_sq + (4 << 4);
    } else if ((a_prev >> 4) == 1) {
        a_prev_sq = a_prev_sq + (1 << 4);
    }

    signed int result;
    if (a_prev < 0) {
        //result = inc_term - (a_prev_sq << 1);
        result = inc_term - (a_prev << 1);
        //result = inc_term - 40;
    }
    else {
        //result = inc_term + (a_prev_sq << 1);
        result = inc_term + (a_prev << 1);
        //result = inc_term + 40;
        //result = inc_term + 50;
    }

    IO(3) = static_cast<signed> (result);
    return true;
END_TRIGGER;
END_OPERATION(INC_COMP_NEXT)