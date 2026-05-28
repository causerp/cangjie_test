#include <stdio.h>
#include <stdint.h>

typedef int32_t*(*testfunc1)();

int32_t* func1() {
    return 0;
};

testfunc1 testfunc()
{
    testfunc1 ret = &func1;
    return ret;
}
