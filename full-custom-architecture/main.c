#include "delay.h"

#ifdef _DEBUG
#include <stdio.h>
#endif

volatile int delay_array_v[NUM_HALF_TRANSDUCERS+1];
  
int main(void) 
{   

    unsigned char r_0 = 100;
    unsigned char angle = 110;//110;
    int delay_array[NUM_HALF_TRANSDUCERS+1];
    int inc_term_array[NUM_HALF_TRANSDUCERS+1];

    init_delay(r_0, angle, delay_array, inc_term_array);
    //init_delay_base(r_0, angle, delay_array, inc_term_array);

    int a_array[NUM_HALF_TRANSDUCERS+1]             = {0};
    int inc_term_prev_array[NUM_HALF_TRANSDUCERS+1] = {0};
    int error_array[NUM_HALF_TRANSDUCERS+1]         = {0};

    next_delay(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    next_delay_frac(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_delay_frac(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);

    for (int i = 0; i < NUM_HALF_TRANSDUCERS+1; ++i) {
        delay_array_v[i] = delay_array[i];
    }
    

    #ifdef _DEBUG
        for (int i = 0; i < NUM_HALF_TRANSDUCERS; ++i) {
            iprintf("Delay, element %d: %d\n", i, delay_array[i] >> 4);
        }
    #endif

    return 0; 
}