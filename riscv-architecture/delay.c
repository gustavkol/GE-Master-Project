#include "delay.h"
#include <stdio.h>



// #define REFLECT_REMAINDER(X)	((crc) reflect((X), WIDTH))         // DO SOMETHING SIMILAR WITH INCREMENT OF comp_term?


// TODO: Possible to keep prev values across function calls?
// Function calculating next delay for initial scanpoint k= 0
void increment_and_compare_init(int n_prev, signed int a_prev, signed int inc_term_prev, signed int error_prev, signed int inc_term, 
                                int *n_next, signed int *a_next, signed int *inc_term_next, signed int *error_next) {

    // Propagate previous a to get an initial guess for a
    signed int a = a_prev;

    // Propagate error into inc_term
    signed int inc_term_w_error = inc_term + error_prev;
    
    // Decide whether a has to increase or decrease
    signed int sign_bit;
    if (inc_term_w_error >= inc_term_prev) {
        sign_bit = 1;
    } else {
        sign_bit = -1;
    }
    
    // Finding a_n through increment and compare algorithm
    signed int cur_error;
    signed int comp_term; // = 2 * a * n_prev + a * a;
    for (int i = 1; i <= MAX_ITER; i++) {
        a += sign_bit * INC_STEP;
        comp_term = ((2 * a * n_prev) >> 4) + ((a * a) >> 4);     // comp_term += 2 * INC_STEP * (n_prev + a) + INC_STEP * INC_STEP;

        /* VERSION 1 */
        if (sign_bit == -1) {
            if (comp_term < inc_term_w_error) {
                a += INC_STEP;
                cur_error = inc_term_w_error - comp_term;
                break;
            }
        } else if (sign_bit == 1) {
            if (comp_term > inc_term_w_error) {
                a -= INC_STEP;
                cur_error = inc_term_w_error - comp_term;
                break;
            }
        }

        /* Version 2 */
        // if (sign_bit * inc_term < sign_bit * comp_term) {
        //     a -= sign_bit * INC_STEP;
        //     cur_error = inc_term - comp_term;
        //     break;
        // }
    }

    // Values to propagate to next calculation
    *inc_term_next = comp_term;
    *error_next = cur_error;
    *n_next = n_prev + a;
    *a_next = a;
}

// Function calculating delay to scanpoint k>0
void increment_and_compare_next(int *n_prev, int *a_prev, signed int *error_prev, signed int inc_term) {

    // Propagate previous a to get an initial guess for a
    int a = *a_prev;
    signed int inc_term_w_error = inc_term + *error_prev;
    
    // Finding a_n through increment and compare algorithm
    signed int cur_error;
    signed int comp_term; // = 2 * a * n_prev + a * a;
    for (int i = 1; i <= MAX_ITER; i++) {
        a += INC_STEP;
        comp_term = ((2 * a * *n_prev) >> 4) + ((a * a) >> 4);     // comp_term += 2 * INC_STEP * (n_prev + a) + INC_STEP * INC_STEP;

        if (comp_term > inc_term_w_error) {
            a -= INC_STEP;
            cur_error = inc_term_w_error - comp_term;
            break;
        }
    }

    // Values to propagate to next calculation
    *error_prev = cur_error;
    *n_prev = *n_prev + a;
    *a_prev = a;
}


// Calculates delay to reference point
void init_delay(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array) {
    // Finding delay N_{0,0}
    delay_array[0] = r_0 * N0_CONST;                        //  4 fraction bits

    // Finding cosine expressions
    int x_scale = C0_CONST * r_0;                           //  2*p*(f_s/v_s)^2*r_0
    signed int c_0 = cordic_cosine(x_scale, angle);

    
    signed int cos_b_n = cordic_cosine(B_N_CORDIC_CONST, angle);
    signed int term_b_n = B_N_CONST * r_0;
    inc_term_array[0] = term_b_n - cos_b_n + 1;


    // Performing increment and compare iterations
    signed int inc_term_pos = A0_CONST - c_0;               //A_0 - C_0
    signed int inc_term_next;
    signed int inc_term_prev = 0;
    signed int a_next;
    signed int a_prev = 0;
    signed int error_next;
    signed int error_prev = 0;
    for (int i = 0; i < NUM_HALF_TRANSDUCERS-1; ++i) {
        // Finding increment values
        inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0

        // Calculating next delay value
        increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);  // pos indexed elements
        
        // Updating input parameters the next iteration
        a_prev = a_next;
        inc_term_prev = inc_term_next;
        error_prev = error_next;

        inc_term_array[i+1] = inc_term_array[i] - cos_b_n;
    }
}

// Fits fraction of cordic module (6) with rest of application (4)
signed int cordic_cosine(int x_scale, unsigned char angle) {
    signed int out;
    _OA_RV_CORDIC(angle, (x_scale << 2), out);
    return (out >> 2);
}

void next_delay(int *delay_array, int *inc_term_array, int *a_array, int *error_array) {
    for (int i = 0; i < NUM_HALF_TRANSDUCERS-1; ++i) {
        inc_term_array[i] += 2;
        increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], inc_term_array[i]);
    }
}