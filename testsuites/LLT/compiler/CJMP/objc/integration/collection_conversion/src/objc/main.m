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
    printf("objc: test with NSDictionary\n");
    NSDictionary *dict = @{@"first" : @1, @"second" : @-2, @"" : @100500};
    [A testWithDict:dict];

    printf("objc: wait for Cangjie GC after test with NSDictionary\n");
    waitForCangjieGC();

    printf("objc: [A testHashMap]\n");
    NSDictionary *dictFromCj = [A testHashMap];

    printf("objc: wait for Cangjie GC after test HashMap\n");
    waitForCangjieGC();

    if ([dict isEqualToDictionary:dictFromCj]) {
      printf("objc: original dict and dict from Cangjie are equal\n");
    } else {
      printf("dicts are not equal!\n");
    }
  }
  return 0;
}
