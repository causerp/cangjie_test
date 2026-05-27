#include <stdio.h>
#include <stdint.h>

struct Data32 {
	int8_t a0;
	int8_t a1;
	int16_t a2;
	int16_t a3;
	int32_t a4;
	int32_t a5;
	int64_t a6;
	int64_t a7;
};

int32_t testfunc(struct Data32 param1, struct Data32 param2, struct Data32 param3, struct Data32 param4) {
    int32_t res = param1.a0 + param2.a2 + param3.a4 + param4.a7;
    return res;
}
