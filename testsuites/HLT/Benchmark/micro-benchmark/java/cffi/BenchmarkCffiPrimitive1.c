#include "BenchmarkCffiPrimitive1.h"

#include <stdint.h>

JNIEXPORT jint JNICALL Java_BenchmarkCffiPrimitive1_testFunc(
    JNIEnv*, jclass, jlong param1, jlong param2, jlong param3, jlong param4)
{
    int64_t res = param1 + param2 - param3 - param4;
    return (jint)res;
}
