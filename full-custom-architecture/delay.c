#include "delay.h"
#include <stdio.h>

/**************************************************** CUSTOM OPERATION SET FUNCTIONALITY ****************************************************/

// Calculates delay to reference point (k=0) for all elements
void first_point_delay(int r_0, int angle, int *delay_array, int *inc_term_array) {
    // Finding delay N_{0,0}
    _OA_CONST_MULT_N0(r_0, 0, delay_array[0]); 

    // Finding cosine expressions
    int x_scale;                        
    _OA_CONST_MULT_C0(r_0, 0, x_scale);                 //  2*p*(f_s/v_s)^2*r_0

    int c_0;
    _OA_CORDIC(angle, x_scale, c_0);                    //  2*p*(f_s/v_s)^2*r_0 * cos(angle)

    int inc_term_pos = A0_CONST - c_0;                  //  A_0 - C_0



    // Performing increment and compare iterations
    int inc_term_next;
    int error_next;
    int a_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_init(delay_array[0], &delay_array[1], &a_next, &inc_term_next, &error_next, inc_term_pos);
    inc_term_pos += (A0_CONST << 1);

    compare_and_iter_first_point(delay_array[1], &delay_array[2], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[2], &delay_array[3], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[3], &delay_array[4], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[4], &delay_array[5], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[5], &delay_array[6], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[6], &delay_array[7], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[7], &delay_array[8], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[8], &delay_array[9], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[9], &delay_array[10], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[10], &delay_array[11], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[11], &delay_array[12], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[12], &delay_array[13], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[13], &delay_array[14], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[14], &delay_array[15], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[15], &delay_array[16], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[16], &delay_array[17], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[17], &delay_array[18], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[18], &delay_array[19], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[19], &delay_array[20], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[20], &delay_array[21], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[21], &delay_array[22], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[22], &delay_array[23], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[23], &delay_array[24], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[24], &delay_array[25], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[25], &delay_array[26], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[26], &delay_array[27], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[27], &delay_array[28], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[28], &delay_array[29], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[29], &delay_array[30], &a_next, &inc_term_next, &error_next, &inc_term_pos);
    compare_and_iter_first_point(delay_array[30], &delay_array[31], &a_next, &inc_term_next, &error_next, &inc_term_pos);

    // Calculating increment terms for next point
    int term_b_n;
    _OA_CONST_MULT_BN(r_0, 0, term_b_n);                         //2(f_s/v_s)*r_0
    int cos_b_n;
    _OA_CORDIC(angle, B_N_CORDIC_CONST, cos_b_n);

    inc_term_array[0] = term_b_n - cos_b_n + (1 << 4);
    inc_term_array[1] = inc_term_array[0] - cos_b_n;
    inc_term_array[2] = inc_term_array[1] - cos_b_n;
    inc_term_array[3] = inc_term_array[2] - cos_b_n;
    inc_term_array[4] = inc_term_array[3] - cos_b_n;
    inc_term_array[5] = inc_term_array[4] - cos_b_n;
    inc_term_array[6] = inc_term_array[5] - cos_b_n;
    inc_term_array[7] = inc_term_array[6] - cos_b_n;
    inc_term_array[8] = inc_term_array[7] - cos_b_n;
    inc_term_array[9] = inc_term_array[8] - cos_b_n;
    inc_term_array[10] = inc_term_array[9] - cos_b_n;
    inc_term_array[11] = inc_term_array[10] - cos_b_n;
    inc_term_array[12] = inc_term_array[11] - cos_b_n;
    inc_term_array[13] = inc_term_array[12] - cos_b_n;
    inc_term_array[14] = inc_term_array[13] - cos_b_n;
    inc_term_array[15] = inc_term_array[14] - cos_b_n;
    inc_term_array[16] = inc_term_array[15] - cos_b_n;
    inc_term_array[17] = inc_term_array[16] - cos_b_n;
    inc_term_array[18] = inc_term_array[17] - cos_b_n;
    inc_term_array[19] = inc_term_array[18] - cos_b_n;
    inc_term_array[20] = inc_term_array[19] - cos_b_n;
    inc_term_array[21] = inc_term_array[20] - cos_b_n;
    inc_term_array[22] = inc_term_array[21] - cos_b_n;
    inc_term_array[23] = inc_term_array[22] - cos_b_n;
    inc_term_array[24] = inc_term_array[23] - cos_b_n;
    inc_term_array[25] = inc_term_array[24] - cos_b_n;
    inc_term_array[26] = inc_term_array[25] - cos_b_n;
    inc_term_array[27] = inc_term_array[26] - cos_b_n;
    inc_term_array[28] = inc_term_array[27] - cos_b_n;
    inc_term_array[29] = inc_term_array[28] - cos_b_n;
    inc_term_array[30] = inc_term_array[29] - cos_b_n;
    inc_term_array[31] = inc_term_array[30] - cos_b_n;
}

// Calculates delay to scanpoint k=1 for all elements
void second_point_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    compare_and_iter_init(delay_array[0], &delay_array[0], &a_array[0], &inc_term_prev_array[0], &error_array[0], inc_term_array[0]);
    inc_term_array[0] += 0b0100000;

    compare_and_iter_second_point(&delay_array[1], a_array[0], &a_array[1], inc_term_prev_array[0], &inc_term_prev_array[1], &error_array[1], &inc_term_array[1]);
    compare_and_iter_second_point(&delay_array[2], a_array[1], &a_array[2], inc_term_prev_array[1], &inc_term_prev_array[2], &error_array[2], &inc_term_array[2]);
    compare_and_iter_second_point(&delay_array[3], a_array[2], &a_array[3], inc_term_prev_array[2], &inc_term_prev_array[3], &error_array[3], &inc_term_array[3]);
    compare_and_iter_second_point(&delay_array[4], a_array[3], &a_array[4], inc_term_prev_array[3], &inc_term_prev_array[4], &error_array[4], &inc_term_array[4]);
    compare_and_iter_second_point(&delay_array[5], a_array[4], &a_array[5], inc_term_prev_array[4], &inc_term_prev_array[5], &error_array[5], &inc_term_array[5]);
    compare_and_iter_second_point(&delay_array[6], a_array[5], &a_array[6], inc_term_prev_array[5], &inc_term_prev_array[6], &error_array[6], &inc_term_array[6]);
    compare_and_iter_second_point(&delay_array[7], a_array[6], &a_array[7], inc_term_prev_array[6], &inc_term_prev_array[7], &error_array[7], &inc_term_array[7]);
    compare_and_iter_second_point(&delay_array[8], a_array[7], &a_array[8], inc_term_prev_array[7], &inc_term_prev_array[8], &error_array[8], &inc_term_array[8]);
    compare_and_iter_second_point(&delay_array[9], a_array[8], &a_array[9], inc_term_prev_array[8], &inc_term_prev_array[9], &error_array[9], &inc_term_array[9]);
    compare_and_iter_second_point(&delay_array[10], a_array[9], &a_array[10], inc_term_prev_array[9], &inc_term_prev_array[10], &error_array[10], &inc_term_array[10]);    
    compare_and_iter_second_point(&delay_array[11], a_array[10], &a_array[11], inc_term_prev_array[10], &inc_term_prev_array[11], &error_array[11], &inc_term_array[11]);
    compare_and_iter_second_point(&delay_array[12], a_array[11], &a_array[12], inc_term_prev_array[11], &inc_term_prev_array[12], &error_array[12], &inc_term_array[12]);
    compare_and_iter_second_point(&delay_array[13], a_array[12], &a_array[13], inc_term_prev_array[12], &inc_term_prev_array[13], &error_array[13], &inc_term_array[13]);
    compare_and_iter_second_point(&delay_array[14], a_array[13], &a_array[14], inc_term_prev_array[13], &inc_term_prev_array[14], &error_array[14], &inc_term_array[14]);
    compare_and_iter_second_point(&delay_array[15], a_array[14], &a_array[15], inc_term_prev_array[14], &inc_term_prev_array[15], &error_array[15], &inc_term_array[15]);
    compare_and_iter_second_point(&delay_array[16], a_array[15], &a_array[16], inc_term_prev_array[15], &inc_term_prev_array[16], &error_array[16], &inc_term_array[16]);
    compare_and_iter_second_point(&delay_array[17], a_array[16], &a_array[17], inc_term_prev_array[16], &inc_term_prev_array[17], &error_array[17], &inc_term_array[17]);
    compare_and_iter_second_point(&delay_array[18], a_array[17], &a_array[18], inc_term_prev_array[17], &inc_term_prev_array[18], &error_array[18], &inc_term_array[18]);
    compare_and_iter_second_point(&delay_array[19], a_array[18], &a_array[19], inc_term_prev_array[18], &inc_term_prev_array[19], &error_array[19], &inc_term_array[19]);
    compare_and_iter_second_point(&delay_array[20], a_array[19], &a_array[20], inc_term_prev_array[19], &inc_term_prev_array[20], &error_array[20], &inc_term_array[20]);
    compare_and_iter_second_point(&delay_array[21], a_array[20], &a_array[21], inc_term_prev_array[20], &inc_term_prev_array[21], &error_array[21], &inc_term_array[21]);
    compare_and_iter_second_point(&delay_array[22], a_array[21], &a_array[22], inc_term_prev_array[21], &inc_term_prev_array[22], &error_array[22], &inc_term_array[22]);
    compare_and_iter_second_point(&delay_array[23], a_array[22], &a_array[23], inc_term_prev_array[22], &inc_term_prev_array[23], &error_array[23], &inc_term_array[23]);
    compare_and_iter_second_point(&delay_array[24], a_array[23], &a_array[24], inc_term_prev_array[23], &inc_term_prev_array[24], &error_array[24], &inc_term_array[24]);
    compare_and_iter_second_point(&delay_array[25], a_array[24], &a_array[25], inc_term_prev_array[24], &inc_term_prev_array[25], &error_array[25], &inc_term_array[25]);
    compare_and_iter_second_point(&delay_array[26], a_array[25], &a_array[26], inc_term_prev_array[25], &inc_term_prev_array[26], &error_array[26], &inc_term_array[26]);
    compare_and_iter_second_point(&delay_array[27], a_array[26], &a_array[27], inc_term_prev_array[26], &inc_term_prev_array[27], &error_array[27], &inc_term_array[27]);
    compare_and_iter_second_point(&delay_array[28], a_array[27], &a_array[28], inc_term_prev_array[27], &inc_term_prev_array[28], &error_array[28], &inc_term_array[28]);
    compare_and_iter_second_point(&delay_array[29], a_array[28], &a_array[29], inc_term_prev_array[28], &inc_term_prev_array[29], &error_array[29], &inc_term_array[29]);
    compare_and_iter_second_point(&delay_array[30], a_array[29], &a_array[30], inc_term_prev_array[29], &inc_term_prev_array[30], &error_array[30], &inc_term_array[30]);
    compare_and_iter_second_point(&delay_array[31], a_array[30], &a_array[31], inc_term_prev_array[30], &inc_term_prev_array[31], &error_array[31], &inc_term_array[31]);
}

// Calculates delay to scanpoint k>1 for all elements
void next_point_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    compare_and_iter_next_point(&delay_array[0], &a_array[0], &inc_term_prev_array[0], &error_array[0], &inc_term_array[0]);
    compare_and_iter_next_point(&delay_array[1], &a_array[1], &inc_term_prev_array[1], &error_array[1], &inc_term_array[1]);
    compare_and_iter_next_point(&delay_array[2], &a_array[2], &inc_term_prev_array[2], &error_array[2], &inc_term_array[2]);
    compare_and_iter_next_point(&delay_array[3], &a_array[3], &inc_term_prev_array[3], &error_array[3], &inc_term_array[3]);
    compare_and_iter_next_point(&delay_array[4], &a_array[4], &inc_term_prev_array[4], &error_array[4], &inc_term_array[4]);
    compare_and_iter_next_point(&delay_array[5], &a_array[5], &inc_term_prev_array[5], &error_array[5], &inc_term_array[5]);
    compare_and_iter_next_point(&delay_array[6], &a_array[6], &inc_term_prev_array[6], &error_array[6], &inc_term_array[6]);
    compare_and_iter_next_point(&delay_array[7], &a_array[7], &inc_term_prev_array[7], &error_array[7], &inc_term_array[7]);
    compare_and_iter_next_point(&delay_array[8], &a_array[8], &inc_term_prev_array[8], &error_array[8], &inc_term_array[8]);
    compare_and_iter_next_point(&delay_array[9], &a_array[9], &inc_term_prev_array[9], &error_array[9], &inc_term_array[9]);
    compare_and_iter_next_point(&delay_array[10], &a_array[10], &inc_term_prev_array[10], &error_array[10], &inc_term_array[10]);
    compare_and_iter_next_point(&delay_array[11], &a_array[11], &inc_term_prev_array[11], &error_array[11], &inc_term_array[11]);
    compare_and_iter_next_point(&delay_array[12], &a_array[12], &inc_term_prev_array[12], &error_array[12], &inc_term_array[12]);
    compare_and_iter_next_point(&delay_array[13], &a_array[13], &inc_term_prev_array[13], &error_array[13], &inc_term_array[13]);
    compare_and_iter_next_point(&delay_array[14], &a_array[14], &inc_term_prev_array[14], &error_array[14], &inc_term_array[14]);
    compare_and_iter_next_point(&delay_array[15], &a_array[15], &inc_term_prev_array[15], &error_array[15], &inc_term_array[15]);
    compare_and_iter_next_point(&delay_array[16], &a_array[16], &inc_term_prev_array[16], &error_array[16], &inc_term_array[16]);
    compare_and_iter_next_point(&delay_array[17], &a_array[17], &inc_term_prev_array[17], &error_array[17], &inc_term_array[17]);
    compare_and_iter_next_point(&delay_array[18], &a_array[18], &inc_term_prev_array[18], &error_array[18], &inc_term_array[18]);
    compare_and_iter_next_point(&delay_array[19], &a_array[19], &inc_term_prev_array[19], &error_array[19], &inc_term_array[19]);
    compare_and_iter_next_point(&delay_array[20], &a_array[20], &inc_term_prev_array[20], &error_array[20], &inc_term_array[20]);
    compare_and_iter_next_point(&delay_array[21], &a_array[21], &inc_term_prev_array[21], &error_array[21], &inc_term_array[21]);
    compare_and_iter_next_point(&delay_array[22], &a_array[22], &inc_term_prev_array[22], &error_array[22], &inc_term_array[22]);
    compare_and_iter_next_point(&delay_array[23], &a_array[23], &inc_term_prev_array[23], &error_array[23], &inc_term_array[23]);
    compare_and_iter_next_point(&delay_array[24], &a_array[24], &inc_term_prev_array[24], &error_array[24], &inc_term_array[24]);
    compare_and_iter_next_point(&delay_array[25], &a_array[25], &inc_term_prev_array[25], &error_array[25], &inc_term_array[25]);
    compare_and_iter_next_point(&delay_array[26], &a_array[26], &inc_term_prev_array[26], &error_array[26], &inc_term_array[26]);
    compare_and_iter_next_point(&delay_array[27], &a_array[27], &inc_term_prev_array[27], &error_array[27], &inc_term_array[27]);
    compare_and_iter_next_point(&delay_array[28], &a_array[28], &inc_term_prev_array[28], &error_array[28], &inc_term_array[28]);
    compare_and_iter_next_point(&delay_array[29], &a_array[29], &inc_term_prev_array[29], &error_array[29], &inc_term_array[29]);
    compare_and_iter_next_point(&delay_array[30], &a_array[30], &inc_term_prev_array[30], &error_array[30], &inc_term_array[30]);
    compare_and_iter_next_point(&delay_array[31], &a_array[31], &inc_term_prev_array[31], &error_array[31], &inc_term_array[31]);
}


// Initiation function
void compare_and_iter_init(int n_prev, int *n_next, int *a_next, int *inc_term_next, int *error_next, int inc_term) {
    int out;

    _OA_COMPARE_AND_ITER_INT(inc_term, n_prev, out);
                                                            //int compensated           = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_SHIFT_SUB(out, inc_term,*error_next);               //*error_next               = in2 - compensated;
    _OA_SHIFT_ADD(out, 0,*inc_term_next);                   //*inc_term_next            = compensated;
    _OA_MASK_ADD(out, n_prev, *n_next);                     //*n_next                   = n_prev + delta_a;
    _OA_MERGE(out, *n_next, *a_next);                       // a_n_next                 = a_next & n_next;
}

// Next delay function in k=0
void compare_and_iter_first_point(int n_prev, int *n_next, int *a_prev, int *inc_term_prev, int *error_prev, int *inc_term) {
    int inc_term_w_error = *inc_term + *error_prev;
    int in2 = inc_term_w_error - *inc_term_prev;
    int out;

    _OA_COMPARE_AND_ITER_F(in2, *a_prev, out);    
                                                            //int compensated           = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_SHIFT_SUB(out, in2,*error_prev);                    //*error_next               = in2 - compensated;
    _OA_SHIFT_ADD(out, *inc_term_prev,*inc_term_prev);       //*inc_term_next            = compensated + inc_term_prev;
    _OA_MASK_ADD(out, n_prev, *n_next);                     //*n_next                   = n_prev + delta_a;
    _OA_MERGE(out, *n_next, *a_prev);                       // a_n_next                 = a_next & n_next;

    *inc_term = *inc_term + (A0_CONST << 1);
}

// Initiation function in k=1
void compare_and_iter_second_point(int *n_prev, int a_prev, int *a_cur, int inc_term_prev, int *inc_term_next, int *error_prev, int *inc_term) {
    int out;

    _OA_COMPARE_AND_ITER_F_INIT(a_prev, *a_cur, out);

    
    _OA_SHIFT_ADD(out, inc_term_prev,*inc_term_next);
    _OA_MASK_ADD(out, *n_prev, *n_prev);
    *error_prev = *inc_term - *inc_term_next;
    _OA_MERGE(out, *n_prev, *a_cur);
    *inc_term = *inc_term + 0b0100000;
}

// Next delay function in k>1
void compare_and_iter_next_point(int *n_prev, int *a_prev, int *inc_term_prev, int *error_prev, int *inc_term) {
    // Propagate previous values
    int inc_term_w_error = *inc_term + *error_prev;
    int in2 = inc_term_w_error - *inc_term_prev;
    int out;

    _OA_COMPARE_AND_ITER_F(in2, *a_prev, out);
                                                            //int compensated           = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_SHIFT_SUB(out, in2,*error_prev);                    //*error_next               = in2 - compensated;
    _OA_SHIFT_ADD(out, *inc_term_prev,*inc_term_prev);      //*inc_term_next            = compensated + inc_term_prev;
    _OA_MASK_ADD(out, *n_prev, *n_prev);                    //*a_next                   = a_prev + delta_a;
    _OA_MERGE(out, *n_prev, *a_prev);                       // a_n_next                 = a_next & n_next;

    *inc_term = *inc_term + 0b0100000;
}








/**************************************************** BASE OPERATION SET FUNCTIONALITY ****************************************************/

// Function calculating all delays for scanpoint k = 0
void init_delay_base(int r_0, int angle, int *delay_array, int *inc_term_array) {
    // Finding delay N_{0,0}
    delay_array[0] = (r_0 << (4+4)) + (r_0 << (4-2)) - (r_0 >> (6-4));

    // Finding cosine expressions
    int x_scale = (r_0 << (7+4)) + (r_0 << (1+4)) + (r_0 << (0+4)) + (r_0 << (4-1)) + (r_0 << (4-2));   //  2*p*(f_s/v_s)^2*r_0

    int c_0;
    _OA_CORDIC(angle, x_scale, c_0);                                                                    //  2*p*(f_s/v_s)^2*r_0 * cos(angle)

    int inc_term_pos = A0_CONST - c_0;                                                                  //  A_0 - C_0

    int term_b_n = (r_0 << (5+4)) + (r_0 << (4-1)) - (r_0 >> (5-4)) - (r_0 >> (10-4));                  // 2(f_s/v_s)*r_0
    
    int cos_b_n;
    _OA_CORDIC(angle, B_N_CORDIC_CONST, cos_b_n);
    
    inc_term_array[0] = term_b_n - cos_b_n + (1 << 4);

    // Performing increment and compare iterations
    int inc_term_next;
    int error_next;
    int a_next;

    int inc_term_prev = 0;
    int error_prev = 0;
    int a_prev = 0;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[0], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[1] = inc_term_array[0] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[1], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[2], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[2] = inc_term_array[1] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[2], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[3], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[3] = inc_term_array[2] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[3], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[4], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[4] = inc_term_array[3] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[4], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[5], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[5] = inc_term_array[4] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[5], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[6], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[6] = inc_term_array[5] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[6], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[7], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[7] = inc_term_array[6] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[7], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[8], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[8] = inc_term_array[7] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[8], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[9], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[9] = inc_term_array[8] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[9], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[10], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[10] = inc_term_array[9] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[10], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[11], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[11] = inc_term_array[10] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[11], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[12], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[12] = inc_term_array[11] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[12], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[13], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[13] = inc_term_array[12] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[13], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[14], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[14] = inc_term_array[13] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[14], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[15], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[15] = inc_term_array[14] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[15], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[16], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[16] = inc_term_array[15] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[16], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[17], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[17] = inc_term_array[16] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[17], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[18], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[18] = inc_term_array[17] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[18], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[19], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[19] = inc_term_array[18] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[19], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[20], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[20] = inc_term_array[19] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[20], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[21], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[21] = inc_term_array[20] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[21], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[22], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[2] = inc_term_array[21] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[22], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[23], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[23] = inc_term_array[22] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[23], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[24], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[24] = inc_term_array[23] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[24], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[25], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[25] = inc_term_array[24] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[25], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[26], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[26] = inc_term_array[25] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[26], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[27], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[27] = inc_term_array[26] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[27], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[28], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[28] = inc_term_array[27] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[28], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[29], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[29] = inc_term_array[28] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[29], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[30], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[30] = inc_term_array[29] - cos_b_n;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[30], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[31], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[31] = inc_term_array[30] - cos_b_n;
}

// Function calculating all delays for scanpoints k > 0
void next_delay_base(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    increment_and_compare_next(&delay_array[0], &a_array[0], &error_array[0], &inc_term_prev_array[0], inc_term_array[0]);
    increment_and_compare_next(&delay_array[1], &a_array[1], &error_array[1], &inc_term_prev_array[1], inc_term_array[1]);
    increment_and_compare_next(&delay_array[2], &a_array[2], &error_array[2], &inc_term_prev_array[2], inc_term_array[2]);
    increment_and_compare_next(&delay_array[3], &a_array[3], &error_array[3], &inc_term_prev_array[3], inc_term_array[3]);
    increment_and_compare_next(&delay_array[4], &a_array[4], &error_array[4], &inc_term_prev_array[4], inc_term_array[4]);
    increment_and_compare_next(&delay_array[5], &a_array[5], &error_array[5], &inc_term_prev_array[5], inc_term_array[5]);
    increment_and_compare_next(&delay_array[6], &a_array[6], &error_array[6], &inc_term_prev_array[6], inc_term_array[6]);
    increment_and_compare_next(&delay_array[7], &a_array[7], &error_array[7], &inc_term_prev_array[7], inc_term_array[7]);
    increment_and_compare_next(&delay_array[8], &a_array[8], &error_array[8], &inc_term_prev_array[8], inc_term_array[8]);
    increment_and_compare_next(&delay_array[9], &a_array[9], &error_array[9], &inc_term_prev_array[9], inc_term_array[9]);
    increment_and_compare_next(&delay_array[10], &a_array[10], &error_array[10], &inc_term_prev_array[10], inc_term_array[10]);
    increment_and_compare_next(&delay_array[11], &a_array[11], &error_array[11], &inc_term_prev_array[11], inc_term_array[11]);
    increment_and_compare_next(&delay_array[12], &a_array[12], &error_array[12], &inc_term_prev_array[12], inc_term_array[12]);
    increment_and_compare_next(&delay_array[13], &a_array[13], &error_array[13], &inc_term_prev_array[13], inc_term_array[13]);
    increment_and_compare_next(&delay_array[14], &a_array[14], &error_array[14], &inc_term_prev_array[14], inc_term_array[14]);
    increment_and_compare_next(&delay_array[15], &a_array[15], &error_array[15], &inc_term_prev_array[15], inc_term_array[15]);
    increment_and_compare_next(&delay_array[16], &a_array[16], &error_array[16], &inc_term_prev_array[16], inc_term_array[16]);
    increment_and_compare_next(&delay_array[17], &a_array[17], &error_array[17], &inc_term_prev_array[17], inc_term_array[17]);
    increment_and_compare_next(&delay_array[18], &a_array[18], &error_array[18], &inc_term_prev_array[18], inc_term_array[18]);
    increment_and_compare_next(&delay_array[19], &a_array[19], &error_array[19], &inc_term_prev_array[19], inc_term_array[19]);
    increment_and_compare_next(&delay_array[20], &a_array[20], &error_array[20], &inc_term_prev_array[20], inc_term_array[20]);
    increment_and_compare_next(&delay_array[21], &a_array[21], &error_array[21], &inc_term_prev_array[21], inc_term_array[21]);
    increment_and_compare_next(&delay_array[22], &a_array[22], &error_array[22], &inc_term_prev_array[22], inc_term_array[22]);
    increment_and_compare_next(&delay_array[23], &a_array[23], &error_array[23], &inc_term_prev_array[23], inc_term_array[23]);
    increment_and_compare_next(&delay_array[24], &a_array[24], &error_array[24], &inc_term_prev_array[24], inc_term_array[24]);
    increment_and_compare_next(&delay_array[25], &a_array[25], &error_array[25], &inc_term_prev_array[25], inc_term_array[25]);
    increment_and_compare_next(&delay_array[26], &a_array[26], &error_array[26], &inc_term_prev_array[26], inc_term_array[26]);
    increment_and_compare_next(&delay_array[27], &a_array[27], &error_array[27], &inc_term_prev_array[27], inc_term_array[27]);
    increment_and_compare_next(&delay_array[28], &a_array[28], &error_array[28], &inc_term_prev_array[28], inc_term_array[28]);
    increment_and_compare_next(&delay_array[29], &a_array[29], &error_array[29], &inc_term_prev_array[29], inc_term_array[29]);
    increment_and_compare_next(&delay_array[30], &a_array[30], &error_array[30], &inc_term_prev_array[30], inc_term_array[30]);
    increment_and_compare_next(&delay_array[31], &a_array[31], &error_array[31], &inc_term_prev_array[31], inc_term_array[31]);
    
    
    inc_term_array[0] += 0b0100000; //+= 2
    inc_term_array[1] += 0b0100000; //+= 2
    inc_term_array[2] += 0b0100000; //+= 2
    inc_term_array[3] += 0b0100000; //+= 2
    inc_term_array[4] += 0b0100000; //+= 2
    inc_term_array[5] += 0b0100000; //+= 2
    inc_term_array[6] += 0b0100000; //+= 2
    inc_term_array[7] += 0b0100000; //+= 2
    inc_term_array[8] += 0b0100000; //+= 2
    inc_term_array[9] += 0b0100000; //+= 2
    inc_term_array[10] += 0b0100000; //+= 2
    inc_term_array[11] += 0b0100000; //+= 2
    inc_term_array[12] += 0b0100000; //+= 2
    inc_term_array[13] += 0b0100000; //+= 2
    inc_term_array[14] += 0b0100000; //+= 2
    inc_term_array[15] += 0b0100000; //+= 2
    inc_term_array[16] += 0b0100000; //+= 2
    inc_term_array[17] += 0b0100000; //+= 2
    inc_term_array[18] += 0b0100000; //+= 2
    inc_term_array[19] += 0b0100000; //+= 2
    inc_term_array[20] += 0b0100000; //+= 2
    inc_term_array[21] += 0b0100000; //+= 2
    inc_term_array[22] += 0b0100000; //+= 2
    inc_term_array[23] += 0b0100000; //+= 2
    inc_term_array[24] += 0b0100000; //+= 2
    inc_term_array[25] += 0b0100000; //+= 2
    inc_term_array[26] += 0b0100000; //+= 2
    inc_term_array[27] += 0b0100000; //+= 2
    inc_term_array[28] += 0b0100000; //+= 2
    inc_term_array[29] += 0b0100000; //+= 2
    inc_term_array[30] += 0b0100000; //+= 2
    inc_term_array[31] += 0b0100000; //+= 2
}


// Function calculating next delay for initial scanpoint k = 0
void increment_and_compare_init(int n_prev, int a_prev, int inc_term_prev, int error_prev, int inc_term, int *n_next, int *a_next, int *inc_term_next, int *error_next) {
    // Propagate previous a to get an initial guess for a
    int a_cur = a_prev;
    int inc_term_w_error = inc_term + error_prev;
    int sign_bit = (inc_term_w_error >= inc_term_prev) ? 1 : -1;
    int comp_term = inc_term_prev;

    int cur_error = 0;
    int iter_term = 0;


    // Finding a_n through increment and compare algorithm
    int n_cur = n_prev;
    if (sign_bit == -1) {
        while (comp_term > inc_term_w_error) {
            iter_term = - (n_cur >> 1) - a_cur + 1;     
            a_cur -= INC_STEP;
            comp_term += iter_term;
        }
        if(inc_term + error_prev - inc_term_prev < 0) {
            comp_term -= iter_term;
            a_cur += INC_STEP;
        }
        cur_error = inc_term_w_error - comp_term;       
    } else {
        while (comp_term < inc_term_w_error) {
            iter_term = (n_cur >> 1) + a_cur + 1; 
            a_cur += INC_STEP;
            comp_term += iter_term;
        } 
        if(inc_term + error_prev - inc_term_prev > 0) {
            comp_term -= iter_term;
            a_cur -= INC_STEP;
        }
        cur_error = inc_term_w_error - comp_term;
    }

    // Values to propagate to next calculation
    *inc_term_next = comp_term;
    *error_next = cur_error;
    *n_next = n_prev + a_cur;
    *a_next = a_cur;
}

// Function calculating delay to scanpoint k>0
void increment_and_compare_next(int *n_prev, int *a_prev, int *inc_term_prev, int *error_prev, int inc_term) {

    // Propagate previous values
    int a_cur = *a_prev;
    int inc_term_w_error = inc_term + *error_prev;
    int sign_bit = (inc_term_w_error >= *inc_term_prev) ? 1 : -1;
    int comp_term = *inc_term_prev;
    int cur_error = 0;
    int iter_term = 0;

    // Finding a_n through increment and compare algorithm
    int n_cur = *n_prev;
    if (sign_bit == -1) {
        while (comp_term > inc_term_w_error) {
            iter_term = - (n_cur >> 1) - a_cur + 1;
            a_cur -= INC_STEP;
            comp_term += iter_term;
        }
        cur_error = inc_term_w_error - comp_term;
        if(cur_error > -(iter_term >> 1)) {
            comp_term -= iter_term;
            a_cur += INC_STEP;
            cur_error = inc_term_w_error - comp_term;
        }
    } else {
        while (comp_term < inc_term_w_error) {
            iter_term = (n_cur >> 1) + a_cur + 1;
            a_cur += INC_STEP;
            comp_term += iter_term;
        }
        cur_error = inc_term_w_error - comp_term;
        if(-cur_error > (iter_term >> 1)) {
            comp_term -= iter_term;
            a_cur -= INC_STEP;
            cur_error = inc_term_w_error - comp_term;
        }
    }


    // Values to propagate to next calculation
    *inc_term_prev = comp_term;
    *error_prev = cur_error;
    *n_prev = *n_prev + a_cur;
    *a_prev = a_cur;
}