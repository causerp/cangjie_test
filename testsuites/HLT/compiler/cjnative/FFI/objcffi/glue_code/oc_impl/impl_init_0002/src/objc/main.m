/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

#import "A.h"
#import "B.h"
#import <Foundation/Foundation.h>

int main(int argc, char** argv) {
    @autoreleasepool {
        B* b = [[B alloc] init];
        A* a = [b test];
    }
    return 0;
}
