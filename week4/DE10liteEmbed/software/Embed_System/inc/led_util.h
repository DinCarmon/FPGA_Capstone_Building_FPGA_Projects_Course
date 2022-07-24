#ifndef LED_UTIL_H_
#define LED_UTIL_H_

// global storage declared in src/led_util.c
extern volatile alt_u8  LEDG_STATE;
extern volatile alt_u8  LEDG_MASK;

// function prototypes from src/led_util.c
void update_led(alt_u8 display_value);

#endif /*LED_UTIL_H_*/
