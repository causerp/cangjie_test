#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int64_t* getptr(int64_t num) {
    int64_t* ptr = (int64_t*)malloc(sizeof(int64_t));
    ptr[0] = num;
    return ptr;
}

int32_t testfunc(int64_t* param1) {
    int32_t res = *param1 * 2;
    return res;
}