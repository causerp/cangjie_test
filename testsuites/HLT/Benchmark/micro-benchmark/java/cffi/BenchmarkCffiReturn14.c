#include "BenchmarkCffiReturn13.h"

JNIEXPORT jlong JNICALL Java_BenchmarkCffiReturn14_testFunc(JNIEnv*, jclass)
{
    char* res = "123456";
    return (jlong)res;
}
