#ifndef DELAY_WAIT_H_
#define DELAY_WAIT_H_

// delay mode macros
#define DELAY_MODE_NONE     (0)
#define DELAY_MODE_1MS      (1)
#define DELAY_MODE_10MS     (2)
#define DELAY_MODE_100MS    (3)
#define DELAY_MODE_250MS    (4)

// global storage declared in src/delay_wait.c
extern volatile alt_u32 LAST_DELAY;
extern volatile alt_u8  DELAY_MODE;

// function prototypes from src/delay_wait.c
void delay_wait(void);
void set_delay_mode_250ms(void);
void set_delay_mode_100ms(void);
void set_delay_mode_10ms(void);
void set_delay_mode_1ms(void);
void set_delay_mode_none(void);


#endif /*DELAY_WAIT_H_*/
