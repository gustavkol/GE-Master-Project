#include "delay.h"

#ifdef _DEBUG
#include <stdio.h>
#endif

volatile long result_int = 0;
volatile long result_frac = 0;
  
int main(void) 
{   
    unsigned char r_0 = 100;
    unsigned char angle = 70;
    int delay_array[NUM_HALF_TRANSDUCERS];
    int inc_term_array[NUM_HALF_TRANSDUCERS];

    init_delay(r_0, angle, delay_array, inc_term_array);
    #ifdef _DEBUG
        for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
            iprintf("Delay, element %d: %d\n", i, delay_array[i] >> 4);
        }
    #endif


    // int num_points = 2;
    // int a_array[NUM_HALF_TRANSDUCERS] = {0};
    // int error_array[NUM_HALF_TRANSDUCERS] = {0};
    // for (int i = 0; i < num_points; i++) {
    //     next_delay(delay_array, inc_term_array, a_array, error_array);
    //     #ifdef _DEBUG
    //         for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
    //             iprintf("Delay, element %d: %d\n", i, delay_array[i] >> 4);
    //         }
    //     #endif
    // }

    return 0; 
}