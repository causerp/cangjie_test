#include "BenchmarkCffiPrimitive2.h"

#include <stdint.h>

JNIEXPORT jint JNICALL Java_BenchmarkCffiPrimitive2_testFunc(JNIEnv*, jclass, jlong param1)
{
    int32_t res = param1 % 2;
    return (jint)res;
}
