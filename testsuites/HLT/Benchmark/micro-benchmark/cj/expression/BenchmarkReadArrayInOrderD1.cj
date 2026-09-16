/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2026. All rights reserved.
 * This source file is part of the Cangjie project, licensed under Apache-2.0
 * with Runtime Library Exception.
 * 
 * See https://cangjie-lang.cn/pages/LICENSE for license information.
 */

// LEVEL: 3
// EXEC: %compiler %cmp_opt %import-cangjie-stdx -O2 %overflow_wrapping --no-sub-pkg --test -Woff=all %f -o %output
// RUN-EXEC: %export cjHeapSize=16gb && %export cjStackSize=64mb && %export JETVMPROP="-Xmx16G -Djet.cj.use.fibers -Djet.fiber.stack.size=64M" && %run_stdx %output %run_utest_opt %run_args --bench --no-color


import std.time.*
import std.collection.HashSet

@Test
@Configure[minDuration: Duration.second * 3]
@Configure[warmup: Duration.second]
@Measure[TimeNow(Nanos)]
public class Test_Read_Array_In_Order_D1 {

    static let arrD1_32 = Array<Int64>(32, {i => i})
    static let arrD1_256 = Array<Int64>(256, {i => i})
    static let arrD1_2048 = Array<Int64>(2048, {i => i})
    static let arrD1_16384 = Array<Int64>(16384, {i => i})

    static let blackhole = HashSet<Int64>()
    static var element = 0

    @AfterAll
    public func dumb(): Unit {
        blackhole.add(element)
    }

    @Bench
    func BenchmarkReadArrayInOrderD1_N32(): Unit {
        for (i in 0..32) {
            element = arrD1_32[i]
        }
    }

    @Bench
    func BenchmarkReadArrayInOrderD1_N256(): Unit {
        for (i in 0..256) {
            element = arrD1_256[i]
        }
    }

    @Bench
    func BenchmarkReadArrayInOrderD1_N2048(): Unit {
        for (i in 0..2048) {
            element = arrD1_2048[i]
        }
    }

    @Bench
    func BenchmarkReadArrayInOrderD1_N16384(): Unit {
        for (i in 0..16384) {
            element = arrD1_16384[i]
        }
    }
}