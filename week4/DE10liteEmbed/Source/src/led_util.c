#include "system.h"
#include "alt_types.h"
#include "sys/alt_stdio.h"
#include <string.h>
#include "altera_avalon_pio_regs.h"

#include "../inc/main_includes.h"

// declare and initialize global variables for the led states and masks
volatile alt_u8  LED_STATE = 0;

volatile alt_u8  LED_MASK = 0;

// convenience routine for updating the bank of leds
void update_led(alt_u8 display_value)
{
            LED_STATE = display_value & 0xFF;
            LED_STATE &= ~LED_MASK;
            IOWR_ALTERA_AVALON_PIO_DATA(LED_PIO_BASE, LED_STATE);
}
