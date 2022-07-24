#include "sys/alt_stdio.h"
#include "alt_types.h"

#include "../inc/main_includes.h"

// declare some global variables for the delay state machine
volatile alt_u32 LAST_DELAY = 0;
volatile alt_u8  DELAY_MODE = DELAY_MODE_100MS;

// the main() loop can call this routine to delay based on the current delay mode
void delay_wait(void)
{
    alt_u32 this_delay = LAST_DELAY;

    if(DELAY_MODE != DELAY_MODE_NONE)
    {
        do      // wait until we see the proper delay count increment
        {
            switch(DELAY_MODE)
            {
                case(DELAY_MODE_250MS):
                    this_delay = ALARM_250MS_CONTEXT.alarm_count;
                    break;
                case(DELAY_MODE_100MS):
                    this_delay = ALARM_100MS_CONTEXT.alarm_count;
                    break;
                case(DELAY_MODE_10MS):
                    this_delay = ALARM_10MS_CONTEXT.alarm_count;
                    break;
                case(DELAY_MODE_1MS):
                    this_delay = ALARM_1MS_CONTEXT.alarm_count;
                    break;
                default:
                    alt_printf("Error: invalid delay mode detected...\n");
                    error_loop();
            }
        } while(LAST_DELAY == this_delay);

        LAST_DELAY = this_delay;
    }

}

// these are convenience routines for setting the delay modes
void set_delay_mode_250ms(void)
{
   DELAY_MODE = DELAY_MODE_250MS;
   LAST_DELAY = ALARM_250MS_CONTEXT.alarm_count;
}

void set_delay_mode_100ms(void)
{
   DELAY_MODE = DELAY_MODE_100MS;
   LAST_DELAY = ALARM_100MS_CONTEXT.alarm_count;
}

void set_delay_mode_10ms(void)
{
   DELAY_MODE = DELAY_MODE_10MS;
   LAST_DELAY = ALARM_10MS_CONTEXT.alarm_count;
}

void set_delay_mode_1ms(void)
{
   DELAY_MODE = DELAY_MODE_1MS;
   LAST_DELAY = ALARM_1MS_CONTEXT.alarm_count;
}

void set_delay_mode_none(void)
{
   DELAY_MODE = DELAY_MODE_NONE;
}
