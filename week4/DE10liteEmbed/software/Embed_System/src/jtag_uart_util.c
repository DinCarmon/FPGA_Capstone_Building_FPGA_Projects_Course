#include "sys/alt_stdio.h"
#include "alt_types.h"

#include "../inc/main_includes.h"

// declare some global variables for the stdout routine
volatile int PRINT_STDIO_WRAP_COUNT = 0;
volatile int PRINT_STDIO_MASK = 0;

// this routine is called by the main() loop
void print_binary_count_stdio(alt_u16 binary_count)
{
    // print if we aren't masked off
    if(!PRINT_STDIO_MASK)
    {
        // print the binary count
        alt_printf("0x%x ", binary_count);

        // print a new line character after every 16 prints
        PRINT_STDIO_WRAP_COUNT++;
        if(PRINT_STDIO_WRAP_COUNT >= 16)
        {
            alt_printf("\n");
            PRINT_STDIO_WRAP_COUNT = 0;
        }
    }
}
