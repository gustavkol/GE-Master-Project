/* C implementation of delay application running on the processor architecture. Contains both extended and base operation set functionality. */

#ifndef _delay_h
#define _delay_h

#define INC_STEP                0b0100          // 0.25
#define NUM_HALF_TRANSDUCERS    32              // Total *2

// Algorithm constants
#define A0_CONST                0b0100001000        // 16.5
#define B_N_CORDIC_CONST        0b010000001         // 8.125

// Finds delays for all elements in next scanpoint k=0
void first_point_delay(int r_0, int angle, int *delay_array, int *inc_term_array);
// Finds delays for all elements in next scanpoint k=1
void second_point_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
// Finds delays for all elements in next scanpoint k>1
void next_point_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);

// Operation sequences for calculation of a single delay value
void compare_and_iter_init(int n_prev, int *n_next, signed int *a_next, signed int *inc_term_next, signed int *error_next, signed int inc_term);
void compare_and_iter_first_point(int n_prev, int *n_next, int *a_prev, int *inc_term_prev, int *error_prev, int *inc_term);
void compare_and_iter_second_point(int *n_prev, int a_prev, int *a_cur, int inc_term_prev, int *inc_term_next, int *error_prev, int *inc_term);
void compare_and_iter_next_point(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int *inc_term);

// Base instruction set functions
void init_delay_base(int r_0, int angle, int *delay_array, int *inc_term_array);
void next_delay_base(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
void increment_and_compare_next(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int inc_term);
void increment_and_compare_init(int n_prev, int a_prev, signed int inc_term_prev, signed int error_prev, signed int inc_term, int *n_next, int *a_next, signed int *inc_term_next, signed int *error_next);

#endif