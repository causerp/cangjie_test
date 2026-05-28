#include "BenchmarkCffiReturn3.h"

#include <stdint.h>

JNIEXPORT jshort JNICALL Java_BenchmarkCffiReturn3_testFunc(JNIEnv*, jclass)
{
    int16_t res = 1;
    return (jshort)res;
}
