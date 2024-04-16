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


// Calculates delay for all transducer elements to reference point k=0
void init_delay(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array);

// Finds next delay based on previous delay for initial scanpoint k=0
void compare_and_iter(int n_prev, int *n_next, signed int *a_next, signed int *inc_term_next, signed int *error_next, signed int inc_term);
void compare_and_iter_frac(int n_prev, int *n_next, signed int a_prev, signed int *a_next, signed int inc_term_prev, signed int *inc_term_next, signed int error_prev, signed int *error_next, signed int inc_term);

// Finds delays for all elements in next scanpoint k+1
void next_delay(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
void compare_and_iter_next(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int *inc_term);
void next_delay_frac(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
void compare_and_iter_next_frac(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int *inc_term);

// Fits fraction of cordic module (6) with rest of application (4)
signed int cordic_cosine(int x_scale, unsigned char angle);

// Old functions
void init_delay_base(unsigned char r_0, unsigned char angle, int *delay_array, int *inc_term_array);
void next_delay_base(int *delay_array, int *a_array, int *inc_term_prev_array, int *error_array, int *inc_term_array);
void increment_and_compare_next(int *n_prev, signed int *a_prev, signed int *inc_term_prev, signed int *error_prev, signed int inc_term);
void increment_and_compare_init(int n_prev, int a_prev, signed int inc_term_prev, signed int error_prev, signed int inc_term, 
                                int *n_next, int *a_next, signed int *inc_term_next, signed int *error_next);

#endif