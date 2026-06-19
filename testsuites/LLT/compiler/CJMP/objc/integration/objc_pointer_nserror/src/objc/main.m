// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "A.h"
#import "TrackedObject.h"
#import <Foundation/Foundation.h>

void waitForCangjieGC() {
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

int main(int argc, char **argv) {
  @autoreleasepool {
    printf("objc: test with 10\n");
    [A testWithNumber:@10];

    printf("objc: wait for Cangjie GC after test with NSDictionary\n");
    waitForCangjieGC();

    printf("objc: test with -10\n");
    [A testWithNumber:@-10];

    printf("objc: wait for Cangjie GC after test with NSDictionary\n");
    waitForCangjieGC();
  }
  return 0;
}
