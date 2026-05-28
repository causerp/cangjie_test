#include <stdio.h>
#include <stdint.h>

typedef void (*callback)();
void run(callback cb1,callback cb2,callback cb3,callback cb4){
    cb1();
    cb2();
    cb3();
    cb4();
};