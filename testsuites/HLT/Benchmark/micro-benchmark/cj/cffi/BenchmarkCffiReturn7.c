#include <stdio.h>
#include <stdint.h>

struct Data64 {
	int8_t a0;
	int8_t a1;
	int16_t a2;
	int16_t a3;
	int32_t a4;
	int32_t a5;
	int64_t a6;
	int64_t a7;
    int8_t a8;
	int8_t a9;
	int16_t a10;
	int16_t a11;
	int32_t a12;
	int32_t a13;
	int64_t a14;
	int64_t a15;
};

struct Data64 testfunc() {
    struct Data64 res = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1};
    return res;
}
