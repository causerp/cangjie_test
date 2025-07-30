/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2025. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 2
// (CJNATIVE) EXEC: %compiler %cmp_opt %f -o %output --test
// (CJNATIVE) RUN-EXEC: %run %run_opt %output %run_args

import std.runtime.*

@Test
public class GCConfig {
    @TestCase
    func testRecordGCInfo() {
        setGCThreshold(100)
        if (true) {
            let a = Array<String>(2000, repeat: "aaa")
            @Expect(a.size > 0, true)
        }
        gc()
        sleep(2 * Duration.second)
        println("11111111111111111111111111111111")
        println(getGCCount())
        println("22222222222222222222222222222222222222")
        println(getGCTime())
        println("33333333333333333333333333333333333")
        @Expect(getGCCount() > 0, true)
        @Expect(getGCTime() > 0, true)
        @Expect(getGCFreedSize() == 0, true)
    }
}
