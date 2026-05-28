#include "BenchmarkCffiReturn11.h"

#include <malloc.h>
#include <stdint.h>

JNIEXPORT jlong JNICALL Java_BenchmarkCffiReturn11_testFunc(JNIEnv*, jclass)
{
    int64_t* ptr = (int64_t*)malloc(sizeof(int64_t));
    ptr[0] = 1;
    return (jlong)ptr;
}
