// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"
#import "TrackedObject.h"
#import "M.h"
#import <Foundation/Foundation.h>

void waitForCangjieGC() {
  @autoreleasepool {
    while (YES) {
      if ([[TrackedObject locker] tryLock]) {
        if ([TrackedObject counter] == 0) {
          [[TrackedObject locker] unlock];
          printf("objc: Cangjie GC cleared objects\n");
          break;
        }
        [[TrackedObject locker] unlock];
        [NSThread sleepForTimeInterval:0.05];
      }
    }
  }
}

int main(int argc, char **argv) {
  @autoreleasepool {
    M *obj = [[M alloc] initWithNumber: @42];

    printf("objc: pass object to cangjie and get it back\n");
    M *objCopy = [A testPassObject: obj];

    printf("objc: wait for Cangjie GC after testPassObject\n");
    waitForCangjieGC();

    printf("objc: [obj printNumber]\n");
    [obj printNumber];
    printf("objc: [objCopy printNumber]\n");
    [objCopy printNumber];
  }
  return 0;
}
