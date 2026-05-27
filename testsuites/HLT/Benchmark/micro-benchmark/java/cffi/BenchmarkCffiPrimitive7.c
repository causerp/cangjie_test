#include "BenchmarkCffiPrimitive7.h"

#include <stdint.h>

JNIEXPORT jint JNICALL Java_BenchmarkCffiPrimitive7_testFunc(
    JNIEnv*, jclass, jint param1, jint param2, jint param3, jint param4)
{
    int32_t res = param1 + param2 - param3 - param4;
    return (jint)res;
}
