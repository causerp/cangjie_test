// Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
// This source file is part of the Cangjie project, licensed under Apache-2.0
// with Runtime Library Exception.
//
// See https://cangjie-lang.cn/pages/LICENSE for license information.

#import "M.h"

@implementation M

- (instancetype)initWithDescription:(NSString *)description {
    if (self = [super init]) {
        printf("objc: [M initWithDescription: %s]\n", [description UTF8String]);
        self->_description = description;
    }

    return self;
}

- (NSString*)description {
    return self->_description;
}

@end
