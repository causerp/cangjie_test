// Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.
#import "NumChecker.h"

@implementation NumChecker
- (id)init {
  return [super init];
}
- (NSNumber *)checkWithNumber:(NSNumber *)num andError:(NSError **)error {
  if ([num intValue] > 0) {
    return num;
  }
  NSString *domain = @"com.Huawei.test.testDomain";
  NSString *desc = NSLocalizedString(@"Invalid number", @"");

  *error = [[NSError alloc] initWithDomain:domain
                                      code:100500
                                  userInfo:nil];
  return nil;
}
@end