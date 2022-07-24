#ifndef ALARM_UTIL_H_
#define ALARM_UTIL_H_

#include "alt_types.h"
#include <sys/alt_alarm.h>

// type definition for alarm isr context structure
typedef volatile struct {
        volatile alt_u32 alarm_timeout;
        volatile alt_u32 alarm_count;
} MY_ALARM_STRUCT;
    
// global storage declared in src/alarm_util.c
extern alt_alarm ALARM_250MS;
extern MY_ALARM_STRUCT ALARM_250MS_CONTEXT;
extern alt_alarm ALARM_100MS;
extern MY_ALARM_STRUCT ALARM_100MS_CONTEXT;
extern alt_alarm ALARM_10MS;
extern MY_ALARM_STRUCT ALARM_10MS_CONTEXT;
extern alt_alarm ALARM_1MS;
extern MY_ALARM_STRUCT ALARM_1MS_CONTEXT;

// function prototypes from src/alarm_util.c
void alarm_init(void);

#endif /*ALARM_UTIL_H_*/
