/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// DEPENDENCE: ./macros
// EXEC: %compiler macros/m.cj %cmp_macro --output-dir ./
// EXEC-PIPE: %compiler %cmp_opt %f --profile-compile-memory --profile-compile-time 2>&1 | compare %f
// ASSERT: scan Code Info of [ default ]
// ASSERT: scan Memory Usage of [ default ]
// ASSERT: regex [0-9]+.[0-9]+ => [0-9]+.[0-9]+ MB
// ASSERT: scan Compile Time of [ default ]
// ASSERT: regex cost [0-9]+ ms

import define.*

@Outer
class Demo {
    @Inner
    var state = 1
    @Inner
    var cnt = 42
}

main() {
    println("test macro time memory")
    0
}
