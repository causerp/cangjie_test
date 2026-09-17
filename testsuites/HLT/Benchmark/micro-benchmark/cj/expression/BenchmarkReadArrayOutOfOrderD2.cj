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
public class Test_Read_Array_Out_Of_Order_D2 {

    static let arrD2_32 = Array<Array<Int64>>(32, {i => Array<Int64>(32, {i => i})})
    static let arrD2_256 = Array<Array<Int64>>(256, {i => Array<Int64>(256, {i => i})})
    static let arrD2_2048 = Array<Array<Int64>>(2048, {i => Array<Int64>(2048, {i => i})})
    static let arrD2_16384 = Array<Array<Int64>>(16384, {i => Array<Int64>(16384, {i => i})})

    static let blackhole = HashSet<Int64>()
    static var element = 0

    @AfterAll
    public func dumb(): Unit {
        blackhole.add(element)
    }

    @Bench
    func BenchmarkReadArrayOutOfOrderD2_N32(): Unit {
        for (j in 0..32:64) {
            for (i in 0..32:64) {
                element = arrD2_32[j][i]
            }
        }
    }

    @Bench
    func BenchmarkReadArrayOutOfOrderD2_N256(): Unit {
        for (j in 0..256:64) {
            for (i in 0..256:64) {
                element = arrD2_256[j][i]
            }
        }
    }

    @Bench
    func BenchmarkReadArrayOutOfOrderD2_N2048(): Unit {
        for (j in 0..2048:64) {
            for (i in 0..2048:64) {
                element = arrD2_2048[j][i]
            }
        }
    }

    @Bench
    func BenchmarkReadArrayOutOfOrderD2_N16384(): Unit {
        for (j in 0..16384:64) {
            for (i in 0..16384:64) {
                element = arrD2_16384[j][i]
            }
        }
    }
}