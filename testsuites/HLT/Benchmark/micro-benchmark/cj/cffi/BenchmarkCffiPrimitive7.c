#include <stdint.h>
#include <stdio.h>

int32_t testfunc(int32_t param1, int32_t param2, int32_t param3, int32_t param4) {
    int32_t res = param1 + param2 - param3 - param4;
    return res;
}