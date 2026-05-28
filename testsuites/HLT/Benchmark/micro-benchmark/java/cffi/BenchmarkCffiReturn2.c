#include "BenchmarkCffiReturn2.h"

#include <stdint.h>

JNIEXPORT jbyte JNICALL Java_BenchmarkCffiReturn2_testFunc(JNIEnv*, jclass)
{
    int8_t res = 1;
    return (jbyte)res;
}
