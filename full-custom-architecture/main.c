#include "delay.h"

#ifdef _DEBUG
#include <stdio.h>
#endif

volatile int delay_array_v[NUM_HALF_TRANSDUCERS+1];

  
int main(void) 
{   
    int r_0 = 100;
    int angle = 120;

    int delay_array[NUM_HALF_TRANSDUCERS];
    int inc_term_array[NUM_HALF_TRANSDUCERS];

    int error_array[NUM_HALF_TRANSDUCERS]         = {0};
    int a_array[NUM_HALF_TRANSDUCERS]             = {0};
    int inc_term_prev_array[NUM_HALF_TRANSDUCERS] = {0};

    /***    Custom operation set implementation   ***/
    first_point_delay(r_0, angle, delay_array, inc_term_array);
    second_point_delay(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    next_point_delay(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_point_delay(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_point_delay(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_point_delay(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_point_delay(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);


    /***    Base operation set implementation   ***/
    //init_delay_base(r_0, angle, delay_array, inc_term_array);
    //next_delay_base(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_delay_base(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_delay_base(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_delay_base(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_delay_base(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);
    //next_delay_base(delay_array, a_array, inc_term_prev_array, error_array, inc_term_array);




    for (int i = 0; i < NUM_HALF_TRANSDUCERS+1; i++) {
        delay_array_v[i] = delay_array[i];
    }

    #ifdef _DEBUG
        for (int i = 0; i < NUM_HALF_TRANSDUCERS; i++) {
            iprintf("Delay, element %d: %d\n", i, delay_array[i] >> 4);
        }
    #endif

    return 0; 
}