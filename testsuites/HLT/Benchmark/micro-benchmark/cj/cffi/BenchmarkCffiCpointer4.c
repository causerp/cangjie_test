#include <stdio.h>
#include <stdint.h>

typedef void*(*testfunc1)();

void* func1() {
    return 0;
};

testfunc1 cfuncptr()
{
    void* (*ret)(void*) = &func1;
    return ret;
}

int32_t testfunc(testfunc1 func1,testfunc1 func2,testfunc1 func3,testfunc1 func4){
    func1();
    func2();
    func3();
    func4();
    return 0;
};
