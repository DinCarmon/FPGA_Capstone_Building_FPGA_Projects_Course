#include "sys/alt_stdio.h"

#include "../inc/main_includes.h"

// any non-recoverable errors that are detected in the application can jump to here
void error_loop(void)
{
    // indicate that we got into the error loop
    alt_printf("\nError loop entered...\n");
    alt_printf("\nApplication halted...\n");

    // infinite loop
    while(1);
}
