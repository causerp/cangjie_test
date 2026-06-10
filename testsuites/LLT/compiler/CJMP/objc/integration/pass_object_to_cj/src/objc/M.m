// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M.h"

@implementation M

- (instancetype)initWithNumber:(NSNumber *)num {
    if (self = [super init]) {
        printf("objc: [M initWithNumber: %s]\n", [[num stringValue] UTF8String]);
        self->_num = num;
    }

    return self;
}

- (void)printNumber {
    printf("objc: the number is: %s\n", [[self->_num stringValue] UTF8String]);
}

@end
