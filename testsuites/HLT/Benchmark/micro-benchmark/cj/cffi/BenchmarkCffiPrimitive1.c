#include <stdio.h>
#include <stdint.h>

int32_t testfunc(int64_t param1, int64_t param2, int64_t param3, int64_t param4) {
    int64_t res = param1 + param2 - param3 - param4;
    return (int32_t)res;
}
