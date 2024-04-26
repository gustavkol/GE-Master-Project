#ifndef _delay_h
#define _delay_h

#define INC_STEP                0b0100          // 0.25
#define NUM_HALF_TRANSDUCERS    32              // Total *2
#define NUM_POINTS              3

// Algorithm constants
#define A0_CONST                0b0100001000        // 16.5
#define N0_CONST                0b0100000100        // 16.25
#define C0_CONST                0b0100000111100     // 131.75
#define B_N_CORDIC_CONST        0b010000001         // 8.125
#define B_N_CONST               0b01000000111       // 32.4375


// Initiates compare and iter algorithm
void compare_and_iter_init(int n_prev, int *n_next, signed int *a_next, signed int *inc_term_next, signed int *error_next, signed int inc_term);

// Calculates delay for all transducer elements to reference point k=0
void first_point_delay(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array);
void compare_and_iter_first_point(int n_prev, int *n_next, int *a_prev, int *inc_term_prev, int *error_prev, int *inc_term);

// Finds delays for all elements in next scanpoint k=1
void second_point_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
void compare_and_iter_second_point(int *n_prev, int a_prev, int *a_cur, int inc_term_prev, int *inc_term_next, int *error_prev, int *inc_term);

// Finds delays for all elements in next scanpoint k>1
void next_point_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
void compare_and_iter_next_point(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int *inc_term);

// Fits fraction of cordic module (6) with rest of application (4)
signed int cordic_cosine(int x_scale, unsigned char angle);

// Base instruction set functions
void init_delay_base(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array);
void next_delay_base(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
void increment_and_compare_next(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int inc_term);
void increment_and_compare_init(int n_prev, int a_prev, signed int inc_term_prev, signed int error_prev, signed int inc_term, int *n_next, int *a_next, signed int *inc_term_next, signed int *error_next);

#endif