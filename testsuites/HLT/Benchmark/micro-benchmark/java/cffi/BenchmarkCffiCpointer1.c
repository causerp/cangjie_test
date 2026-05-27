#include "BenchmarkCffiCpointer1.h"

#include <malloc.h>
#include <stdint.h>

JNIEXPORT jlong JNICALL Java_BenchmarkCffiCpointer1_getPtr(JNIEnv*, jclass, jlong num)
{
    int64_t* ptr = (int64_t*)malloc(sizeof(int64_t));
    ptr[0] = num;
    return (jlong)ptr;
}

JNIEXPORT jint JNICALL Java_BenchmarkCffiCpointer1_testFunc(
    JNIEnv*, jclass, jlong param1, jlong param2, jlong param3, jlong param4)
{
    int32_t res = *(int64_t*)param1 + *(int64_t*)param2 + *(int64_t*)param3 - *(int64_t*)param4;
    return res;
}
