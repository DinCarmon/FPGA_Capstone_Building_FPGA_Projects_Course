#ifndef JTAG_UART_UTIL_H_
#define JTAG_UART_UTIL_H_

// global storage declared in src/jtag_uart_util.c
extern volatile int PRINT_STDIO_WRAP_COUNT;
extern volatile int PRINT_STDIO_MASK;

// function prototypes from src/jtag_uart_util.c
void print_binary_count_stdio(alt_u16 binary_count);

#endif /*JTAG_UART_UTIL_H_*/
