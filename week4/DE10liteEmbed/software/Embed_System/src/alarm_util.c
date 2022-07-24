#include "sys/alt_stdio.h"
#include <alt_types.h>
#include <sys/alt_alarm.h>

#include "../inc/main_includes.h"

// define the alarm call back routine that will be used by all alarms we start
// the alarm context will keep the alarms separate
alt_u32 my_alarm_callback (void* context)
{
    MY_ALARM_STRUCT *my_alarm_context;

    // cast the context pointer into our alarm context structure pointer
    my_alarm_context = context;

    // increment the alarm count
    my_alarm_context->alarm_count++;

    // return the timeout value for this alarm
    return (my_alarm_context->alarm_timeout);
}

// globally allocate some storage for the four alarms we plan to start
alt_alarm ALARM_250MS;
MY_ALARM_STRUCT ALARM_250MS_CONTEXT;
alt_alarm ALARM_100MS;
MY_ALARM_STRUCT ALARM_100MS_CONTEXT;
alt_alarm ALARM_10MS;
MY_ALARM_STRUCT ALARM_10MS_CONTEXT;
alt_alarm ALARM_1MS;
MY_ALARM_STRUCT ALARM_1MS_CONTEXT;

// main() should call this initialization routine when it starts to get the alarms running
void alarm_init(void)
{
    int return_result;

    // initialize the context structure for the 250ms alarm and start it running
    ALARM_250MS_CONTEXT.alarm_timeout = alt_ticks_per_second()/4;
    ALARM_250MS_CONTEXT.alarm_count = 0;
    return_result = alt_alarm_start (
                        &ALARM_250MS,                       //alt_alarm *alarm
                        ALARM_250MS_CONTEXT.alarm_timeout,  //alt_u32 nticks
                        my_alarm_callback,                  //alt_u32 (*callback) (void* context)
                        (void*)(&ALARM_250MS_CONTEXT)       //void* context
                    );

    if(return_result)
    {
        alt_printf("\n\nError when starting 250ms alarm...\n");
        error_loop();
    }

    // initialize the context structure for the 100ms alarm and start it running
    ALARM_100MS_CONTEXT.alarm_timeout = alt_ticks_per_second()/10;
    ALARM_100MS_CONTEXT.alarm_count = 0;
    return_result = alt_alarm_start (
                        &ALARM_100MS,                       //alt_alarm *alarm
                        ALARM_100MS_CONTEXT.alarm_timeout,  //alt_u32 nticks
                        my_alarm_callback,                  //alt_u32 (*callback) (void* context)
                        (void*)(&ALARM_100MS_CONTEXT)       //void* context
                    );

    if(return_result)
    {
        alt_printf("\n\nError when starting 100ms alarm...\n");
        error_loop();
    }

    // initialize the context structure for the 10ms alarm and start it running
    ALARM_10MS_CONTEXT.alarm_timeout = alt_ticks_per_second()/100;
    ALARM_10MS_CONTEXT.alarm_count = 0;
    return_result = alt_alarm_start (
                        &ALARM_10MS,                        //alt_alarm *alarm
                        ALARM_10MS_CONTEXT.alarm_timeout,   //alt_u32 nticks
                        my_alarm_callback,                  //alt_u32 (*callback) (void* context)
                        (void*)(&ALARM_10MS_CONTEXT)        //void* context
                    );

    if(return_result)
    {
        alt_printf("\n\nError when starting 10ms alarm...\n");
        error_loop();
    }

    // initialize the context structure for the 1ms alarm and start it running
    ALARM_1MS_CONTEXT.alarm_timeout = alt_ticks_per_second()/1000;
    ALARM_1MS_CONTEXT.alarm_count = 0;
    return_result = alt_alarm_start (
                        &ALARM_1MS,                         //alt_alarm *alarm
                        ALARM_1MS_CONTEXT.alarm_timeout,    //alt_u32 nticks
                        my_alarm_callback,                  //alt_u32 (*callback) (void* context)
                        (void*)(&ALARM_1MS_CONTEXT)         //void* context
                    );

    if(return_result)
    {
        alt_printf("\n\nError when starting 1ms alarm...\n");
        error_loop();
    }

}
