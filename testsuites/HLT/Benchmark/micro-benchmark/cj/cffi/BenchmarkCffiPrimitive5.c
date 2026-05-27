#include <stdint.h>
#include <stdio.h>

int32_t testfunc(int8_t param1, int8_t param2, int8_t param3, int8_t param4) {
    int32_t res = param1 + param2 - param3 - param4;
    return res;
}