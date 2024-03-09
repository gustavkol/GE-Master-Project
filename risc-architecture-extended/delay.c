#include "delay.h"
#include <stdio.h>



// #define REFLECT_REMAINDER(X)	((crc) reflect((X), WIDTH))         // DO SOMETHING SIMILAR WITH INCREMENT OF comp_term?

// Calculates delay to reference point
void init_delay(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array) {
    // TODO: Make constant multipliers and look at other instruction formats for several inputs/outputs (immediates)

    // Finding delay N_{0,0}
    _OA_RV_CONST_MULT_N0(r_0, 0, delay_array[0]); 
    //delay_array[0] = r_0 * N0_CONST; //(f_s/v_s)*r_0

    // Finding cosine expressions
    int x_scale;// = C0_CONST * r_0;                           //  2*p*(f_s/v_s)^2*r_0
    _OA_RV_CONST_MULT_C0(r_0, 0, x_scale);

    signed int c_0 = cordic_cosine(x_scale, angle);

    signed int term_b_n;// = B_N_CONST * r_0;
    _OA_RV_CONST_MULT_BN(r_0, 0, term_b_n);     //2(f_s/v_s)*r_0

    signed int cos_b_n = cordic_cosine(B_N_CORDIC_CONST, angle);
    inc_term_array[0] = term_b_n - cos_b_n + (1 << 4);


    // Performing increment and compare iterations
    signed int inc_term_pos = A0_CONST - c_0;               //A_0 - C_0
    
    signed int inc_term_prev = 0;
    signed int inc_term_next;
    signed int error_prev = 0;
    signed int error_next;
    signed int a_prev = 0;
    signed int a_next;

    inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0
    compare_and_iter(delay_array[0], &delay_array[1], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
    inc_term_array[1] = inc_term_array[0] - cos_b_n;

    a_prev = a_next;
    inc_term_prev = inc_term_next;
    error_prev = error_next;

    for (int i = 1; i < NUM_HALF_TRANSDUCERS; ++i) {
        // Finding increment values
        inc_term_pos = inc_term_pos + (A0_CONST << 1);      // A_0(2n+1) - C_0

        // Calculating next delay value
        //increment_and_compare_init(delay_array[i], a_prev, inc_term_prev, error_prev, inc_term_pos, &delay_array[i+1], &a_next, &inc_term_next, &error_next);  // pos indexed elements
        //compare_and_iter(delay_array[i], &delay_array[i+1], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);
        compare_and_iter_frac(delay_array[i], &delay_array[i+1], a_prev, &a_next, inc_term_prev, &inc_term_next,error_prev, &error_next, inc_term_pos);

        //iprintf("inc_term: %d, error_prev %d, inc_term_prev: %d, a_prev %d\n", inc_term_pos, error_prev, inc_term_prev, a_prev);


        // Updating input parameters the next iteration
        a_prev = a_next;
        inc_term_prev = inc_term_next;
        error_prev = error_next;

        inc_term_array[i+1] = inc_term_array[i] - cos_b_n;
    }
}



void compare_and_iter(int n_prev, int *n_next, signed int a_prev, signed int *a_next, 
                    signed int inc_term_prev, signed int *inc_term_next, signed int error_prev, signed int *error_next, signed int inc_term) {
    signed int inc_term_w_error = inc_term + error_prev;
    signed int in2 = inc_term_w_error - inc_term_prev;
    signed int out;

    _OA_RV_COMPARE_AND_ITER(n_prev, in2, out);
                                                            //signed int compensated    = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_RV_SHIFT_ADD(-out, in2,*error_next);                //*error_next               = in2 - compensated;
    _OA_RV_SHIFT_ADD(out, inc_term_prev,*inc_term_next);    //*inc_term_next            = compensated + inc_term_prev;
    _OA_RV_MASK_ADD(out, a_prev, *a_next);                  //*a_next                   = a_prev + delta_a;
    *n_next         = n_prev + *a_next;
}

void compare_and_iter_frac(int n_prev, int *n_next, signed int a_prev, signed int *a_next, 
                    signed int inc_term_prev, signed int *inc_term_next, signed int error_prev, signed int *error_next, signed int inc_term) {
    signed int inc_term_w_error = inc_term + error_prev;
    signed int in2 = inc_term_w_error - inc_term_prev;
    signed int out;

    _OA_RV_COMPARE_AND_ITER_F(n_prev, in2, out);    
                                                            //signed int compensated    = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_RV_SHIFT_ADD(-out, in2,*error_next);                //*error_next               = in2 - compensated;
    _OA_RV_SHIFT_ADD(out, inc_term_prev,*inc_term_next);    //*inc_term_next            = compensated + inc_term_prev;
    _OA_RV_MASK_ADD(out, a_prev, *a_next);                  //*a_next                   = a_prev + delta_a;
    *n_next         = n_prev + *a_next;
}








void next_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
        //increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
        compare_and_iter_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
        inc_term_array[i] += 0b0100000; //+= 2
    }
}

void next_delay_frac(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array) {
    for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
        //increment_and_compare_next(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
        compare_and_iter_next_frac(&delay_array[i], &a_array[i], &error_array[i], &inc_term_prev_array[i], inc_term_array[i]);
        inc_term_array[i] += 0b0100000; //+= 2
    }
}




void compare_and_iter_next(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int inc_term) {

    // Propagate previous values

    signed int inc_term_w_error = inc_term + *error_prev;
    signed int in2 = inc_term_w_error - *inc_term_prev;
    signed int out;


    _OA_RV_COMPARE_AND_ITER(n_prev, in2, out);
                                                            //signed int compensated    = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_RV_SHIFT_ADD(-out, in2,*error_prev);                //*error_next               = in2 - compensated;
    _OA_RV_SHIFT_ADD(out, inc_term_prev,*inc_term_prev);    //*inc_term_next            = compensated + inc_term_prev;
    _OA_RV_MASK_ADD(out, a_prev, *a_prev);                  //*a_next                   = a_prev + delta_a;
    *n_prev         = *n_prev + *a_prev;
}

void compare_and_iter_next_frac(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int inc_term) {

    // Propagate previous values

    signed int inc_term_w_error = inc_term + *error_prev;
    signed int in2 = inc_term_w_error - *inc_term_prev;
    signed int out;


    _OA_RV_COMPARE_AND_ITER_F(n_prev, in2, out);
                                                            //signed int compensated    = out >> 8;
                                                            //signed char delta_a       = out & 0xFF;
    _OA_RV_SHIFT_ADD(-out, in2,*error_prev);                //*error_next               = in2 - compensated;
    _OA_RV_SHIFT_ADD(out, inc_term_prev,*inc_term_prev);    //*inc_term_next            = compensated + inc_term_prev;
    _OA_RV_MASK_ADD(out, a_prev, *a_prev);                  //*a_next                   = a_prev + delta_a;
    *n_prev         = *n_prev + *a_prev;
}






/** Hardware accelerated functions **/

// Fits fraction of cordic module (6) with rest of application (4)
signed int cordic_cosine(int x_scale, unsigned char angle) {
    signed int out;
    _OA_RV_CORDIC(angle, (x_scale << 2), out);
    return (out >> 2);
}










/* OLD FUNCTIONS*/


// TODO: Possible to keep prev values across function calls?
// Function calculating next delay for initial scanpoint k= 0
void increment_and_compare_init(int n_prev, int a_prev, signed int inc_term_prev, signed int error_prev, signed int inc_term, 
                                int *n_next, int *a_next, signed int *inc_term_next, signed int *error_next) {

    // Propagate previous a to get an initial guess for a
    signed int a = a_prev;
    signed int inc_term_w_error = inc_term + error_prev;
    signed int sign_bit = (inc_term_w_error >= inc_term_prev) ? 1 : -1;
    signed int comp_term = inc_term_prev;

    signed int cur_error = 0;
    signed int iter_term = 0;


    // *********************CAUSES STALLS**********************//
    if (sign_bit == -1) {
        while (comp_term > inc_term_w_error) {
            a -= INC_STEP;                                  
            _OA_RV_COMP_TERM_ITER(a, n_prev, iter_term);
            comp_term -= iter_term;                         
        }
        comp_term += iter_term;
        a += INC_STEP;
        cur_error = inc_term_w_error - comp_term;    
    } else {
        while (comp_term < inc_term_w_error) {
            a += INC_STEP;
            _OA_RV_COMP_TERM_ITER(a, n_prev, iter_term);
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
void increment_and_compare_next(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int inc_term) {

    // Propagate previous values
    signed int a = *a_prev;
    signed int inc_term_w_error = inc_term + *error_prev;
    signed int comp_term = *inc_term_prev;

    signed int cur_error;
    signed int iter_term;
    
    // Finding a_n through increment and compare algorithm
    // for (int i = 1; i <= MAX_ITER; i++) {
    //     a += INC_STEP;

    //     _OA_RV_COMP_TERM_ITER(a, *n_prev, iter_term);
    //     //iter_term = ((*n_prev + a) >> 1) + 0b0010;
        
    //     comp_term += iter_term;

    //     if (comp_term > inc_term_w_error) {
    //         comp_term -= iter_term;
    //         a -= INC_STEP;
    //         cur_error = inc_term_w_error - comp_term;
    //         break;
    //     }
    // }

    while (comp_term < inc_term_w_error) {
        a += INC_STEP;
        _OA_RV_COMP_TERM_ITER(a, *n_prev, iter_term);
        comp_term += iter_term;
    }
    comp_term -= iter_term;
    a -= INC_STEP;
    cur_error = inc_term_w_error - comp_term;  


    // Values to propagate to next calculation
    *error_prev = cur_error;
    *inc_term_prev = comp_term;
    *n_prev = *n_prev + a;
    *a_prev = a;
}