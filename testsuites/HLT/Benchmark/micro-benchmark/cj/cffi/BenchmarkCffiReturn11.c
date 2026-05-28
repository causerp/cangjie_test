#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>

int64_t* testfunc() {
    int64_t* ptr = (int64_t*)malloc(sizeof(int64_t));
    ptr[0] = 1;
    return ptr;
}
