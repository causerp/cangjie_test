// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "TrackedObject.h"

@implementation TrackedObject

static int64_t _counter;
static NSLock* _locker;

+(int64_t)counter {
    return _counter;
}

+(NSLock*)locker {
    return _locker;
}

+(void)initialize {
    _locker = [[NSLock alloc] init];
    _counter = 0;
}

-(instancetype)init {
    if (self = [super init]) {
        printf("objc: [TrackedObject init]\n");

        while (YES) {
            if ([[TrackedObject locker] tryLock]) {
                printf("objc: TrackedObject.counter++\n");
                _counter++;
                [[TrackedObject locker] unlock];
                break;
            }
            [NSThread sleepForTimeInterval:0.05];
        }
    }

    return self;
}

-(void)dealloc {
    printf("objc: [TrackedObject dealloc]\n");

    while (YES) {
        if ([[TrackedObject locker] tryLock]) {
            printf("objc: TrackedObject.counter--\n");
            _counter--;
            
            [[TrackedObject locker] unlock];
            break;
        }
        [NSThread sleepForTimeInterval:0.05];
    }
}

@end
