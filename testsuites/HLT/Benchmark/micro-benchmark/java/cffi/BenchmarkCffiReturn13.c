#include "BenchmarkCffiReturn13.h"

#include <stdint.h>

typedef int32_t* (*testfunc1)();

int32_t* func1()
{
    return 0;
}

JNIEXPORT jlong JNICALL Java_BenchmarkCffiReturn13_testFunc(JNIEnv*, jclass)
{
    testfunc1 ret = &func1;
    return (jlong)ret;
}
