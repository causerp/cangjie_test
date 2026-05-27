#include <stdint.h>

int32_t Fibonacci3(int32_t n, int32_t* fib, int32_t* res)
{
    int32_t i;
    fib[0] = 0;
    fib[1] = 1;

    for (i = 2; i < n; i++) {
        fib[i] = fib[i - 1] + fib[i - 2];
    }
    *res = fib[n - 1];
    return 0;
}
