// include the c and hal files that we need in main()
#include <string.h>
#include "sys/alt_stdio.h"
#include "alt_types.h"

// these includes allow us to perform a quick sanity check that the system was properly assembled in SOPC Builder
#include "system.h"
#include "inc/system_validation.h"

// all helper routine includes are condensed into this one file for neatness
#include "inc/main_includes.h"

#define MAX_COUNT 0xFF  //use a 8-bit maximum count value since we have a 8-bit LED PIO

// the main() application routine
int main(void)
{
  // declare the local variables need in main()
  alt_u8 binary_count;
  char input;
  int dir;
  
  // announce that we're running on STDOUT
  alt_printf("\nled_control program starting...\n\n");
  alt_printf ("CONGRATULATIONS!  You have successfully compiled a Nios II project!\n");

  // initialize some peripherals and helper routines
  alarm_init();           // see src/alarm_util.c
//    key_init();             // see src/key_util.c
//    sw_init();              // see src/sw_util.c
//    uart_init();            // see src/uart_util.c
  
  // start an infinite loop

  while(1) {

    alt_printf("\nPress 'u' to count up\n");
    alt_printf("Press 'd' to count down\n");
    alt_printf("Press '3' to count by threes\n");
    input = alt_getchar();
    alt_getchar();
    alt_printf("You selected: '%c'\n",input);
	if (input == 'u') {
        dir = 1;
    	binary_count = 0;
        alt_printf(" -  counting up by 1\n");
    }
    else if (input == 'd') {
        dir = -1;
    	binary_count = MAX_COUNT;
        alt_printf(" -  counting down by 1\n");
    }
    else if (input == '3') {
        dir = 3;
    	binary_count = 0;
        alt_printf(" -  counting up by 3\n");
    }
    else {
        dir = 1;
        binary_count = MAX_COUNT;
        alt_printf("INVALID ENTRY");
    }
        
    // initialize the line wrap count variable
    PRINT_STDIO_WRAP_COUNT = 0;

    // print the binary count out the STDOUT
    print_binary_count_stdio(binary_count);         // see src/jtag_uart_util.c

    // update the green led display with the binary count
    update_led(binary_count);                      // see src/led_util.c

    // wait for the delay period
    delay_wait();                                   // see src/delay_wait.c

    // count until we reach all the maximum count
    while( (binary_count < MAX_COUNT && dir > 0) || (binary_count > 0 && dir < 0) )
    {
        // increment the binary counter
        binary_count= binary_count + dir;

        // print the binary count out the STDOUT
        print_binary_count_stdio(binary_count);         // see src/jtag_uart_util.c
            
        // update the green led display with the binary count
        update_led(binary_count);                      // see src/led_util.c
    
        // wait for the delay period
        delay_wait();                                   // see src/delay_wait.c
    }
    // announce loop completion on STDOUT and the UART
    alt_printf("\n\n LED control program completed its loop ...\n\n");

    // wait for the delay period
    delay_wait();                                   // see src/delay_wait.c
        
  }
    
  // we should never get to this point
  return(0);
}
