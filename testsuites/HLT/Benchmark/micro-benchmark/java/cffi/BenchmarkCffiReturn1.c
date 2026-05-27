#include "BenchmarkCffiReturn1.h"

#include <stdint.h>

JNIEXPORT jlong JNICALL Java_BenchmarkCffiReturn1_testFunc(JNIEnv*, jclass)
{
    int64_t res = 1;
    return (jlong)res;
}
