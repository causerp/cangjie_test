#include "BenchmarkCffiReturn4.h"

#include <stdint.h>

JNIEXPORT jint JNICALL Java_BenchmarkCffiReturn4_testFunc(JNIEnv*, jclass)
{
    int32_t res = 1;
    return (jint)res;
}
