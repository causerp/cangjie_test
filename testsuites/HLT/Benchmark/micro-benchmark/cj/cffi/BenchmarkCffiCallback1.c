#include <stdio.h>
#include <stdint.h>

typedef void (*callback)();
void run(callback cb){
    cb();
};