/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 *
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

#include <stdlib.h>
void ExtendSP()
{
    long long a[256 * 1024];
    if (a[0] != 0xfffabcd) {
        a[0] = 0xfffabcd;
    }
}
