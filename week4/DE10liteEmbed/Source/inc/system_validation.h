#ifndef SYSTEM_VALIDATION_H_
#define SYSTEM_VALIDATION_H_

// verify that all the appropriate peripheral types appear to be in the hardware system
#ifndef __ALTERA_AVALON_SYSID_QSYS
    #error You do not seem to have a SystemID peripheral in your SOPC Builder system, please check that you have properly constructed your hardware before compiling this program.
#endif
#ifndef __ALTERA_AVALON_ONCHIP_MEMORY2
    #error You do not seem to have an on-chip RAM peripheral in your SOPC Builder system, please check that you have properly constructed your hardware before compiling this program.
#endif
#ifndef __ALTERA_AVALON_JTAG_UART
    #error You do not seem to have a JTAG UART peripheral in your SOPC Builder system, please check that you have properly constructed your hardware before compiling this program.
#endif
#ifndef __ALTERA_AVALON_TIMER
    #error You do not seem to have a Timer peripheral in your SOPC Builder system, please check that you have properly constructed your hardware before compiling this program.
#endif
#ifndef __ALTERA_AVALON_PIO
    #error You do not seem to have a PIO peripheral in your SOPC Builder system, please check that you have properly constructed your hardware before compiling this program.
#endif

// validate that all the expected names of the peripherals appear to be in the system
#ifndef ALT_CPU_NAME 
    #error Your CPU peripheral must be named exactly "nios2_cpu" in your SOPC Builder system.  Please check that you have properly constructed your system before compiling this program.
#endif
#ifndef SYSID_NAME 
    #error Your SystemID peripheral must be named exactly "sysid" in your SOPC Builder system.  Please check that you have properly constructed your system before compiling this program.
#endif
#ifndef ONCHIP_RAM_NAME
    #error Your onchip RAM peripheral must be named exactly "onchip_ram" in your SOPC Builder system.  Please check that you have properly constructed your system before compiling this program.
#endif
#ifndef JTAG_UART_NAME 
    #error Your JTAG UART peripheral must be named exactly "jtag_uart" in your SOPC Builder system.  Please check that you have properly constructed your system before compiling this program.
#endif
#ifndef LED_PIO_NAME
    #error Your LED G peripheral must be named exactly "LED_PIO" in your SOPC Builder system.  Please check that you have properly constructed your system before compiling this program.
#endif

#endif /*SYSTEM_VALIDATION_H_*/
