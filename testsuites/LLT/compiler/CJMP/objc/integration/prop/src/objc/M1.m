// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M1.h"

@implementation M1

@synthesize answer;

- (id)initWithAnswer:(double)answer {
    if (self = [super init]) {
        printf("objc: [M1 initWithAnswer: %lf]\n", answer);
        self.answer = answer;
    }

    return self;
}

@end
