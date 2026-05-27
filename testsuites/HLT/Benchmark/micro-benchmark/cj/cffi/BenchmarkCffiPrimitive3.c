#include <stdint.h>
#include <stdio.h>

int32_t testfunc(int64_t param1, int64_t param2, int64_t param3, int64_t param4,
                      int64_t param5, int64_t param6, int64_t param7, int64_t param8) {
    int32_t res = param1 + param2 + param3 + param4 - param5 - param6 - param7 - param8;
    return res;
}