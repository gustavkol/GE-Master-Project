#include "delay.h"
#include <stdio.h>



// #define REFLECT_REMAINDER(X)	((crc) reflect((X), WIDTH))         // DO SOMETHING SIMILAR WITH INCREMENT OF comp_term?

// Calculates delay to reference point
void init_delay(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array) {
    // Finding delay N_{0,0}
    _OA_CONST_MULT_N0(r_0, 0, delay_array[0]); 

    // Finding cosine expressions
    int x_scale;                        
    _OA_CONST_MULT_C0(r_0, 0, x_scale);                  //  2*p*(f_s/v_s)^2*r_0
    int c_0 = cordic_cosine(x_scale, angle);         //  2*p*(f_s/v_s)^2*r_0 * cos(angle)
    int inc_term_pos = A0_CONST - c_0;               //  A_0 - C_0

    // Performing increment and compare iterations
    int inc_term_next;
    int error_next;
    int a_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter(delay_array[0], &delay_array[1], &a_next, &inc_term_next, &error_next, inc_term_pos);

    int inc_term_prev = inc_term_next;
    int error_prev = error_next;
    //error_array[1] = error_next;
    int a_prev = a_next;

    // for (int i = 1; i < NUM_HALF_TRANSDUCERS; ++i) {
    //     // Finding increment values
    //     inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0

    //     // Calculating next delay value
    //     compare_and_iter_frac(delay_array[i], &delay_array[i+1], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);

    //     // Updating input parameters the next iteration
    //     a_prev = a_next;
    //     inc_term_prev = inc_term_next;
    //     error_prev = error_next;

    //     inc_term_array[i+1] = inc_term_array[i] - cos_b_n;
    // }

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[1], &delay_array[2], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[2] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[2], &delay_array[3], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[3] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[3], &delay_array[4], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[4] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[4], &delay_array[5], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[5] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[5], &delay_array[6], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[6] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[6], &delay_array[7], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[7] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[7], &delay_array[8], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[8] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[8], &delay_array[9], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[9] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[9], &delay_array[10], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[10] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[10], &delay_array[11], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[11] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[11], &delay_array[12], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[12] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[12], &delay_array[13], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[13] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[13], &delay_array[14], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[14] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[14], &delay_array[15], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    //error_array[15] = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[15], &delay_array[16], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[16], &delay_array[17], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[17], &delay_array[18], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[18], &delay_array[19], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[19], &delay_array[20], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[20], &delay_array[21], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[21], &delay_array[22], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[22], &delay_array[23], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[23], &delay_array[24], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[24], &delay_array[25], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[25], &delay_array[26], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[26], &delay_array[27], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[27], &delay_array[28], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[28], &delay_array[29], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[29], &delay_array[30], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[30], &delay_array[31], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter_frac(delay_array[31], &delay_array[32], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    int term_b_n;
    int cos_b_n = cordic_cosine(B_N_CORDIC_CONST, angle);    
    _OA_CONST_MULT_BN(r_0, 0, term_b_n);                         //2(f_s/v_s)*r_0
    inc_term_array[0] = term_b_n - cos_b_n + (1 << 4); // 3247 + 2.776
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
    inc_term_array[32] = inc_term_array[31] - cos_b_n;

}



void compare_and_iter(int n_prev, int *n_next, int *a_next, int *inc_term_next, int *error_next, int inc_term) {
    int out;

    _OA_COMPARE_AND_ITER_INT(inc_term, n_prev, out);
                                                            //int compensated           = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_SHIFT_SUB(out, inc_term,*error_next);               //*error_next               = in2 - compensated;
    _OA_SHIFT_ADD(out, 0,*inc_term_next);                   //*inc_term_next            = compensated;
    _OA_MASK_ADD(out, n_prev, *n_next);                     //*n_next                   = n_prev + delta_a;
    _OA_MERGE(out, *n_next, *a_next);                       // a_n_next                 = a_next & n_next;
}

void compare_and_iter_frac(int n_prev, int *n_next, int a_prev, int *a_next, 
                    int inc_term_prev, int *inc_term_next, int error_prev, 
                    int *error_next, int inc_term) {
    int inc_term_w_error = inc_term + error_prev;
    int in2 = inc_term_w_error - inc_term_prev;
    int out;

    _OA_COMPARE_AND_ITER_F(in2, a_prev, out);    
                                                            //int compensated           = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_SHIFT_SUB(out, in2,*error_next);                    //*error_next               = in2 - compensated;
    _OA_SHIFT_ADD(out, inc_term_prev,*inc_term_next);       //*inc_term_next            = compensated + inc_term_prev;
    _OA_MASK_ADD(out, n_prev, *n_next);                     //*n_next                   = n_prev + delta_a;
    _OA_MERGE(out, *n_next, *a_next);                       // a_n_next                 = a_next & n_next;
}

void compare_and_iter_next(int *n_prev, int *a_prev, int *inc_term_prev, int *error_prev, int *inc_term) {
    // Propagate previous values
    int out;
    int in2 = *inc_term + *error_prev;

    //iprintf("IN: %d, %d\n\n", in2, *n_prev);

    _OA_COMPARE_AND_ITER_INT(in2, *n_prev, out);
                                                            //int compensated    = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_SHIFT_SUB(out, in2,*error_prev);                    //*error_next               = in2 - compensated;
    _OA_SHIFT_ADD(out, 0,*inc_term_prev);                   //*inc_term_next            = compensated + inc_term_prev;
    _OA_MASK_ADD(out, *n_prev, *n_prev);                    //*a_next                   = a_prev + delta_a;
    _OA_MERGE(out, *n_prev, *a_prev);                       // a_n_next                 = a_next & n_next;

    *inc_term = *inc_term + 0b0100000;

    //iprintf("%d\n%d\n%d\n%d\n%d\n\n", in2, *error_prev, *inc_term_prev, *n_prev, *a_prev);
}

void compare_and_iter_next_frac(int *n_prev, int *a_prev, int *inc_term_prev, int *error_prev, int *inc_term) {

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







void next_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    // for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
    //     compare_and_iter_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    //     inc_term_array[i] += 0b0100000; //+= 2
    // }

    compare_and_iter_next(&delay_array[0], &a_array[0], &inc_term_prev_array[0],  &error_array[0], &inc_term_array[0]);
    compare_and_iter_next(&delay_array[1], &a_array[1], &inc_term_prev_array[1],  &error_array[1], &inc_term_array[1]);
    compare_and_iter_next(&delay_array[2], &a_array[2], &inc_term_prev_array[2],  &error_array[2], &inc_term_array[2]);
    compare_and_iter_next(&delay_array[3], &a_array[3], &inc_term_prev_array[3],  &error_array[3], &inc_term_array[3]);
    compare_and_iter_next(&delay_array[4], &a_array[4], &inc_term_prev_array[4],  &error_array[4], &inc_term_array[4]);
    compare_and_iter_next(&delay_array[5], &a_array[5], &inc_term_prev_array[5],  &error_array[5], &inc_term_array[5]);
    compare_and_iter_next(&delay_array[6], &a_array[6], &inc_term_prev_array[6],  &error_array[6], &inc_term_array[6]);
    compare_and_iter_next(&delay_array[7], &a_array[7], &inc_term_prev_array[7],  &error_array[7], &inc_term_array[7]);
    compare_and_iter_next(&delay_array[8], &a_array[8], &inc_term_prev_array[8],  &error_array[8], &inc_term_array[8]);
    compare_and_iter_next(&delay_array[9], &a_array[9], &inc_term_prev_array[9],  &error_array[9], &inc_term_array[9]);
    compare_and_iter_next(&delay_array[10], &a_array[10], &inc_term_prev_array[10], &error_array[10],  &inc_term_array[10]);
    compare_and_iter_next(&delay_array[11], &a_array[11], &inc_term_prev_array[11], &error_array[11],  &inc_term_array[11]);
    compare_and_iter_next(&delay_array[12], &a_array[12], &inc_term_prev_array[12], &error_array[12],  &inc_term_array[12]);
    compare_and_iter_next(&delay_array[13], &a_array[13], &inc_term_prev_array[13], &error_array[13],  &inc_term_array[13]);
    compare_and_iter_next(&delay_array[14], &a_array[14], &inc_term_prev_array[14], &error_array[14],  &inc_term_array[14]);
    compare_and_iter_next(&delay_array[15], &a_array[15], &inc_term_prev_array[15], &error_array[15],  &inc_term_array[15]);
    compare_and_iter_next(&delay_array[16], &a_array[16], &inc_term_prev_array[16], &error_array[16],  &inc_term_array[16]);
    compare_and_iter_next(&delay_array[17], &a_array[17], &inc_term_prev_array[17], &error_array[17],  &inc_term_array[17]);
    compare_and_iter_next(&delay_array[18], &a_array[18], &inc_term_prev_array[18], &error_array[18],  &inc_term_array[18]);
    compare_and_iter_next(&delay_array[19], &a_array[19], &inc_term_prev_array[19], &error_array[19],  &inc_term_array[19]);
    compare_and_iter_next(&delay_array[20], &a_array[20], &inc_term_prev_array[20], &error_array[20],  &inc_term_array[20]);
    compare_and_iter_next(&delay_array[21], &a_array[21], &inc_term_prev_array[21], &error_array[21],  &inc_term_array[21]);
    compare_and_iter_next(&delay_array[22], &a_array[22], &inc_term_prev_array[22], &error_array[22],  &inc_term_array[22]);
    compare_and_iter_next(&delay_array[23], &a_array[23], &inc_term_prev_array[23], &error_array[23],  &inc_term_array[23]);
    compare_and_iter_next(&delay_array[24], &a_array[24], &inc_term_prev_array[24], &error_array[24], &inc_term_array[24]);
    compare_and_iter_next(&delay_array[25], &a_array[25], &inc_term_prev_array[25], &error_array[25], &inc_term_array[25]);
    compare_and_iter_next(&delay_array[26], &a_array[26], &inc_term_prev_array[26], &error_array[26], &inc_term_array[26]);
    compare_and_iter_next(&delay_array[27], &a_array[27], &inc_term_prev_array[27], &error_array[27], &inc_term_array[27]);
    compare_and_iter_next(&delay_array[28], &a_array[28], &inc_term_prev_array[28], &error_array[28], &inc_term_array[28]);
    compare_and_iter_next(&delay_array[29], &a_array[29], &inc_term_prev_array[29], &error_array[29], &inc_term_array[29]);
    compare_and_iter_next(&delay_array[30], &a_array[30], &inc_term_prev_array[30], &error_array[30], &inc_term_array[30]);
    compare_and_iter_next(&delay_array[31], &a_array[31], &inc_term_prev_array[31], &error_array[31], &inc_term_array[31]);
    compare_and_iter_next(&delay_array[32], &a_array[32], &inc_term_prev_array[32], &error_array[32], &inc_term_array[32]);
}


void next_delay_frac(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    // for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
    //     compare_and_iter_next_frac(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], &inc_term_array[i]);
    //     inc_term_array[i] += 0b0100000; //+= 2
    // }

    compare_and_iter_next_frac(&delay_array[0], &a_array[0], &inc_term_prev_array[0], &error_array[0], &inc_term_array[0]);
    compare_and_iter_next_frac(&delay_array[1], &a_array[1], &inc_term_prev_array[1], &error_array[1], &inc_term_array[1]);
    compare_and_iter_next_frac(&delay_array[2], &a_array[2], &inc_term_prev_array[2], &error_array[2], &inc_term_array[2]);
    compare_and_iter_next_frac(&delay_array[3], &a_array[3], &inc_term_prev_array[3], &error_array[3], &inc_term_array[3]);
    compare_and_iter_next_frac(&delay_array[4], &a_array[4], &inc_term_prev_array[4], &error_array[4], &inc_term_array[4]);
    compare_and_iter_next_frac(&delay_array[5], &a_array[5], &inc_term_prev_array[5], &error_array[5], &inc_term_array[5]);
    compare_and_iter_next_frac(&delay_array[6], &a_array[6], &inc_term_prev_array[6], &error_array[6], &inc_term_array[6]);
    compare_and_iter_next_frac(&delay_array[7], &a_array[7], &inc_term_prev_array[7], &error_array[7], &inc_term_array[7]);
    compare_and_iter_next_frac(&delay_array[8], &a_array[8], &inc_term_prev_array[8], &error_array[8], &inc_term_array[8]);
    compare_and_iter_next_frac(&delay_array[9], &a_array[9], &inc_term_prev_array[9], &error_array[9], &inc_term_array[9]);
    compare_and_iter_next_frac(&delay_array[10], &a_array[10], &inc_term_prev_array[10], &error_array[10], &inc_term_array[10]);
    compare_and_iter_next_frac(&delay_array[11], &a_array[11], &inc_term_prev_array[11], &error_array[11], &inc_term_array[11]);
    compare_and_iter_next_frac(&delay_array[12], &a_array[12], &inc_term_prev_array[12], &error_array[12], &inc_term_array[12]);
    compare_and_iter_next_frac(&delay_array[13], &a_array[13], &inc_term_prev_array[13], &error_array[13], &inc_term_array[13]);
    compare_and_iter_next_frac(&delay_array[14], &a_array[14], &inc_term_prev_array[14], &error_array[14], &inc_term_array[14]);
    compare_and_iter_next_frac(&delay_array[15], &a_array[15], &inc_term_prev_array[15], &error_array[15], &inc_term_array[15]);
    compare_and_iter_next_frac(&delay_array[16], &a_array[16], &inc_term_prev_array[16], &error_array[16], &inc_term_array[16]);
    compare_and_iter_next_frac(&delay_array[17], &a_array[17], &inc_term_prev_array[17], &error_array[17], &inc_term_array[17]);
    compare_and_iter_next_frac(&delay_array[18], &a_array[18], &inc_term_prev_array[18], &error_array[18], &inc_term_array[18]);
    compare_and_iter_next_frac(&delay_array[19], &a_array[19], &inc_term_prev_array[19], &error_array[19], &inc_term_array[19]);
    compare_and_iter_next_frac(&delay_array[20], &a_array[20], &inc_term_prev_array[20], &error_array[20], &inc_term_array[20]);
    compare_and_iter_next_frac(&delay_array[21], &a_array[21], &inc_term_prev_array[21], &error_array[21], &inc_term_array[21]);
    compare_and_iter_next_frac(&delay_array[22], &a_array[22], &inc_term_prev_array[22], &error_array[22], &inc_term_array[22]);
    compare_and_iter_next_frac(&delay_array[23], &a_array[23], &inc_term_prev_array[23], &error_array[23], &inc_term_array[23]);
    compare_and_iter_next_frac(&delay_array[24], &a_array[24], &inc_term_prev_array[24], &error_array[24], &inc_term_array[24]);
    compare_and_iter_next_frac(&delay_array[25], &a_array[25], &inc_term_prev_array[25], &error_array[25], &inc_term_array[25]);
    compare_and_iter_next_frac(&delay_array[26], &a_array[26], &inc_term_prev_array[26], &error_array[26], &inc_term_array[26]);
    compare_and_iter_next_frac(&delay_array[27], &a_array[27], &inc_term_prev_array[27], &error_array[27], &inc_term_array[27]);
    compare_and_iter_next_frac(&delay_array[28], &a_array[28], &inc_term_prev_array[28], &error_array[28], &inc_term_array[28]);
    compare_and_iter_next_frac(&delay_array[29], &a_array[29], &inc_term_prev_array[29], &error_array[29], &inc_term_array[29]);
    compare_and_iter_next_frac(&delay_array[30], &a_array[30], &inc_term_prev_array[30], &error_array[30], &inc_term_array[30]);
    compare_and_iter_next_frac(&delay_array[31], &a_array[31], &inc_term_prev_array[31], &error_array[31], &inc_term_array[31]);
    compare_and_iter_next_frac(&delay_array[32], &a_array[32], &inc_term_prev_array[32], &error_array[32], &inc_term_array[32]);
}





/** Hardware accelerated functions **/

// Fits fraction of cordic module (6) with rest of application (4)
int cordic_cosine(int x_scale, unsigned char angle) {
    int out;
    _OA_CORDIC(angle, (x_scale << 2), out);
    return (out >> 2);
}










/* BASE INSTRUCTION SET FUNCTIONALITY */


void init_delay_base(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array) {
    // Finding delay N_{0,0}
    delay_array[0] = (r_0 << (4+4)) + (r_0 << (4-2)) - (r_0 >> (6-4)); //r_0 * N0_CONST; 

    // Finding cosine expressions
    int x_scale = (r_0 << (7+4)) + (r_0 << (1+4)) + (r_0 << (0+4)) + (r_0 << (4-1)) + (r_0 << (4-2)); //C0_CONST * r_0;                           //  2*p*(f_s/v_s)^2*r_0
    int c_0 = cordic_cosine(x_scale, angle);         //  2*p*(f_s/v_s)^2*r_0 * cos(angle)
    int inc_term_pos = A0_CONST - c_0;               //  A_0 - C_0

    int term_b_n = (r_0 << (5+4)) + (r_0 << (4-1)) - (r_0 >> (5-4)) - (r_0 >> (10-4)); //B_N_CONST * r_0;                  // 2(f_s/v_s)*r_0
    int cos_b_n = cordic_cosine(B_N_CORDIC_CONST, angle);    
    inc_term_array[0] = term_b_n - cos_b_n + (1 << 4);

    // Performing increment and compare iterations
    int inc_term_next;
    int error_next;
    int a_next;

    int inc_term_prev = 0;
    int error_prev = 0;
    int a_prev = 0;

    // for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
    //     // Finding increment values
    //     inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0

    //     // Calculating next delay value
    //     //compare_and_iter_frac(delay_array[i], &delay_array[i+1], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    //     increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);

    //     // Updating input parameters the next iteration
    //     a_prev = a_next;
    //     inc_term_prev = inc_term_next;
    //     error_prev = error_next;

    //     inc_term_array[i+1] = inc_term_array[i] - cos_b_n;
    // }

    int i = 0;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

        inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;

    i = i + 1;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);
    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;
    inc_term_array[i+1] = inc_term_array[i] - cos_b_n;
}

void next_delay_base(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    // for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
    //     increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    //     inc_term_array[i] += 0b0100000; //+= 2
    // }
    int i = 0;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
    i = i + 1;

    increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
    inc_term_array[i] += 0b0100000; //+= 2
}


// TODO: Possible to keep prev values across function calls?
// Function calculating next delay for initial scanpoint k= 0
void increment_and_compare_init(int n_prev, int a_prev, int inc_term_prev, int error_prev, int inc_term, 
                                int *n_next, int *a_next, int *inc_term_next, int *error_next) {

    // Propagate previous a to get an initial guess for a
    int a = a_prev;
    int inc_term_w_error = inc_term + error_prev;
    int sign_bit = (inc_term_w_error >= inc_term_prev) ? 1 : -1;
    int comp_term = inc_term_prev;

    int cur_error = 0;
    int iter_term = 0;


    // Finding a_n through increment and compare algorithm


    // *********************CAUSES STALLS**********************//
    if (sign_bit == -1) {
        while (comp_term > inc_term_w_error) {
            iter_term = - (n_prev >> 1) + 1 - (a >> 1);
            a -= INC_STEP;                                   
            comp_term += iter_term;
        }

        comp_term -= iter_term;
        a += INC_STEP;
        cur_error = inc_term_w_error - comp_term;    
    } else {
        while (comp_term < inc_term_w_error) {
            iter_term = (n_prev >> 1) + 1 + (a >> 1);;
            a += INC_STEP;
            comp_term += iter_term;
        } 

        comp_term -= iter_term;
        a -= INC_STEP;
        cur_error = inc_term_w_error - comp_term;        
    }
    // *********************CAUSES STALLS**********************//

    // Values to propagate to next calculation
    *inc_term_next = comp_term;
    *error_next = cur_error;
    *n_next = n_prev + a;
    *a_next = a;
}


// Function calculating delay to scanpoint k>0
void increment_and_compare_next(int *n_prev, int *a_prev, int *inc_term_prev, int *error_prev, int inc_term) {

    // Propagate previous values
    int a = *a_prev;
    int inc_term_w_error = inc_term + *error_prev;
    int sign_bit = (inc_term_w_error >= *inc_term_prev) ? 1 : -1;
    int comp_term = *inc_term_prev;

    int cur_error;
    int iter_term;

    if (sign_bit == -1) {
        while (comp_term > inc_term_w_error) {
            iter_term = - (*n_prev >> 1) + 1 - (a >> 1);
            a -= INC_STEP;                                  
            comp_term += iter_term;                        
        }
        comp_term -= iter_term;
        a += INC_STEP;
        cur_error = inc_term_w_error - comp_term;    
    } else {
        while (comp_term < inc_term_w_error) {
            iter_term = (*n_prev >> 1) + 1 + (a >> 1);
            a += INC_STEP;
            comp_term += iter_term;
        }
        comp_term -= iter_term;
        a -= INC_STEP;
        cur_error = inc_term_w_error - comp_term;        
    }


    // Values to propagate to next calculation
    *error_prev = cur_error;
    *inc_term_prev = comp_term;
    *n_prev = *n_prev + a;
    *a_prev = a;
}